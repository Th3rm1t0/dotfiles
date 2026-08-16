# AGENTS.md

このドキュメントは、AI エージェントがこの dotfiles リポジトリで作業する際のガイドラインを定義する。

## プロジェクト概要

Nix flakes と home-manager を使用して、複数環境のユーザー環境を宣言的に管理するリポジトリ。

### 技術スタック

- **Nix flakes**: 依存関係の固定と再現性の保証
- **home-manager** (standalone): ユーザー環境の宣言的管理
- **just**: タスクランナー
- **nh**: home-manager switch/build の UX 改善ラッパー
- **direnv + nix-direnv**: 開発環境の自動ロード
- **1Password shell-plugins**: CLI ツール（gh 等）の認証を 1Password 経由で管理
- **GitHub Actions**: CI（flake check、flake.lock 自動更新）

### 対象環境

- **NixOS**: `mars`（デスクトップ、主環境）
- **NixOS-WSL**: `triton`（WSL2 上で NixOS を実行）
- **Ubuntu on WSL2**（home-manager 単体構成）: `ubuntu-wsl`。NixOS を導入しない WSL2 環境向け
- Ubuntu Desktop（予定）

## ディレクトリ構造と役割

```
.
├── flake.nix           # エントリポイント：inputs / outputs の定義
├── flake.lock          # 依存関係のロックファイル（自動生成）
├── justfile            # タスクランナーのレシピ定義
├── .envrc              # direnv 設定（use flake）
├── home/               # home-manager 層
│   ├── common.nix      # 全ホスト共通設定
│   ├── default.nix     # エントリポイント（programs/ を自動探索）
│   ├── roles/          # ホストの用途ごとに共通する設定（wsl / desktop / bare-metal）
│   ├── hosts/
│   │   └── <hostname>.nix  # 各ホストの設定（common.nix + roles/ を組み合わせる）
│   ├── programs/       # アプリケーション設定（1 アプリ 1 ディレクトリ）
│   └── claude/         # Claude の Agent Skill 管理（agent-skills-nix）
├── nixos/              # NixOS 層
│   ├── common.nix      # 全ホスト共通設定
│   ├── default.nix     # エントリポイント（services/ を自動探索）
│   ├── roles/          # ホストの用途ごとに共通する設定（secure-boot / desktop）
│   ├── hosts/
│   │   └── <hostname>/     # 各ホストの設定（hardware-configuration.nix 等を含む）
│   │       └── default.nix
│   └── services/       # サービス設定（1 サービス 1 ディレクトリ）
├── lib/                # ヘルパー関数（mkHome / mkNixos 等）
│   └── default.nix
├── overlays/           # nixpkgs のオーバーレイ（外部 flake の overlay 集約）
│   └── default.nix
├── pkgs/               # カスタムパッケージ定義
│   └── default.nix
├── inputs/
│   └── skills/         # Agent Skills 用サブ flake
└── .github/workflows/  # CI ワークフロー
    ├── check.yml       # push/PR 時の flake check
    └── update.yml      # flake.lock の週次自動更新
```

## 2 層構造（NixOS 層 / home-manager 層）

このリポジトリは独立した 2 つの層で構成される。

- **NixOS 層**（`nixos/`）: システム全体で 1 つに定まる設定。ブートローダ、カーネル、ネットワーク、マルチユーザーで共有するサービスなど。
- **home-manager 層**（`home/`）: ユーザーごとの設定。シェル、CLI ツール、ユーザーセッションで動くアプリケーションなど。

設定をどちらに書くかは「システム全体で 1 つに定まるか」で判断する。迷ったら「複数ユーザーがいたら共有すべき設定か」を基準に考えるとよい。

Hyprland はこの判断基準がそのまま両層にまたがる例になっている：

- システム側の `programs.hyprland.enable`（NixOS 層）: Wayland セッションとして起動できるようにする setuid wrapper のインストールなど、システム全体に関わる部分
- ユーザー側の `wayland.windowManager.hyprland`（home-manager 層）: キーバインド、起動アプリ、ウィンドウルールなど、ユーザーごとの設定

## 重要な規則

### Git 追跡の必須化

Nix flakes は Git で追跡されているファイルのみを認識する。新規ファイル作成後は必ず `git add` を実行すること。

### inputs.nixpkgs.follows の統一

外部 flake を inputs に追加する際は、nixpkgs を follows させてバージョンを統一する：

```nix
some-flake = {
  url = "github:owner/repo";
  inputs.nixpkgs.follows = "nixpkgs";
};
```

追加前に `nix flake metadata` で対象 flake が nixpkgs input を持っているか確認すること。

### コメントポリシー

コメントは Why のみ記述する。What や How はコードから読み取れるため書かない。

### コミットメッセージ

- 内部的なタスク参照やトラッキング番号（G1, G3 等）を含めない
- 変更内容そのものを簡潔に日本語で記述する

## モジュールの構造（home-manager 層）

### enable オプション

各プログラムモジュールは `dotfiles.programs.<name>.enable` オプションを持つ。デフォルトは `true`。ホスト設定から無効化できる：

```nix
# home/hosts/<hostname>.nix で特定プログラムを無効化
dotfiles.programs.lazygit.enable = false;
```

### モジュールのテンプレート

```nix
# home/programs/<name>/default.nix
{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.dotfiles.programs.<name>.enable = lib.mkEnableOption "<name>" // {
    default = true;
  };

  config = lib.mkIf config.dotfiles.programs.<name>.enable {
    # 設定内容
  };
}
```

### 自動探索

`home/default.nix` は `programs/` 配下のディレクトリを `builtins.readDir` で自動探索する。新しいプログラムは `home/programs/<name>/default.nix` を作成して `git add` するだけで認識される。`home/default.nix` の編集は不要。

### programs.* vs xdg.configFile の使い分け

- **programs.***：home-manager がそのプログラムのオプションを提供している場合
- **xdg.configFile / home.file**：home-manager がサポートしていない場合、または既存の設定ファイルをそのまま使いたい場合

## モジュールの構造（NixOS 層）

home 層の `dotfiles.programs.<name>.enable` と対になる規約として、NixOS のサービスモジュールは `dotfiles.services.<name>.enable` オプションを持つ。home 層のプログラムはデフォルト有効（`default = true`）だが、NixOS のサービスはホストごとに必要なものだけ立てるためデフォルト無効（`mkEnableOption` の既定値のまま）とし、各ホストの `nixos/<hostname>/default.nix` から明示的に有効化する。

```nix
# nixos/services/<name>/default.nix
{ config, lib, ... }:

let
  cfg = config.dotfiles.services.<name>;
in
{
  options.dotfiles.services.<name>.enable = lib.mkEnableOption "<name>";

  config = lib.mkIf cfg.enable {
    # 設定内容
  };
}
```

`nixos/default.nix` が `services/` 配下のディレクトリを `builtins.readDir` で自動探索する。新しいサービスは `nixos/services/<name>/default.nix` を作成して `git add` するだけで認識される。

## overlay とカスタムパッケージ

### overlay の追加

外部 flake の overlay は `overlays/default.nix` に集約する。`flake.nix` の `pkgsFor` で全 overlay を一括適用するため、個別モジュールでの `nixpkgs.overlays` 設定は不要：

```nix
# overlays/default.nix
{ inputs, ... }:
{
  some-package = inputs.some-flake.overlays.default;
}
```

### カスタムパッケージの追加

nixpkgs に存在しないパッケージは `pkgs/` に定義する：

```nix
# pkgs/my-tool/default.nix
{ stdenv, fetchFromGitHub }:
stdenv.mkDerivation { ... }

# pkgs/default.nix
pkgs: {
  my-tool = pkgs.callPackage ./my-tool { };
}
```

## コマンドリファレンス

日常の操作は justfile で抽象化されている：

| コマンド | 内容 |
|----------|------|
| `just build` | home-manager のビルドのみ（適用しない、nh 経由） |
| `just switch` | home-manager をビルドして適用（nh 経由） |
| `just os-build` | NixOS のビルドのみ（適用しない、nh 経由） |
| `just os-switch` | NixOS をビルドして適用（nh 経由） |
| `just update` | flake.lock を更新 |
| `just gc` | Nix ストアのガベージコレクション |
| `just check` | nix flake check |
| `just fmt` | nixfmt でフォーマット |
| `just lint` | deadnix + statix で警告表示 |
| `just fix` | deadnix + statix の自動修正 + フォーマット |

## 新規追加の手順

### 新しいプログラムを追加する場合

1. `home/programs/<name>/default.nix` を作成（テンプレートに従い enable オプションを含める）
2. `git add home/programs/<name>/`
3. `just build` でビルド確認

### 新しい home-manager ホストを追加する場合

1. `home/hosts/<hostname>.nix` を作成し、`../common.nix` をインポート
2. `flake.nix` の `homeConfigurations` に `lib.mkHome` で 1 行追加：
```nix
"<user>@<hostname>" = lib.mkHome { hostname = "<hostname>"; };
```
3. 必要に応じて `dotfiles.programs.<name>.enable = false;` でモジュールを無効化
4. `git add` してビルド確認

### 新しい NixOS ホストを追加する場合

1. `nixos/hosts/<hostname>/default.nix` を作成（`hardware-configuration.nix` の import を含める）
2. `flake.nix` の `nixosConfigurations` に `lib.mkNixos` で 1 行追加：
```nix
"<hostname>" = lib.mkNixos { hostname = "<hostname>"; };
```
   NixOS-WSL の場合は `extraModules = [ inputs.nixos-wsl.nixosModules.default ];` を追加する。
3. `mkNixos` は home-manager モジュールを内蔵しており、`home/hosts/<hostname>.nix` を `users.${username}` に自動で割り当てる。ユーザー環境の設定はここに用意する
4. `git add` してビルド確認：`nixos-rebuild build --flake .#<hostname>`

## よくある問題と解決策

### "file not found" / "is not tracked by Git" エラー

新規ファイルが `git add` されていない。`git add <ファイル>` で解決。

### "infinite recursion" エラー

モジュール間の循環参照。`lib.mkDefault` や `lib.mkForce` で優先度を明示するか、imports の構造を見直す。

### "collision" エラー（ファイル衝突）

既存ファイルと home-manager 生成ファイルの競合。既存ファイルをバックアップして削除する。

### 設定変更が反映されない

シェルの再起動が必要な場合がある（特に direnv のフック追加後など）。

## 参考リソース

- [Home Manager Manual](https://nix-community.github.io/home-manager/)
- [Home Manager Options Search](https://home-manager-options.extranix.com/)
- [NixOS & Flakes Book](https://nixos-and-flakes.thiscute.world/)
- [Nix Flakes Wiki](https://wiki.nixos.org/wiki/Flakes)
- [nix-starter-configs](https://github.com/Misterio77/nix-starter-configs)
