# Dotfiles

Nix flakes、NixOS、home-manager で管理する dotfiles リポジトリ。

## 対応環境

- **NixOS**: `mars`（デスクトップ、主環境）
- **NixOS-WSL**: `triton`（WSL2 上で NixOS を実行）
- **Ubuntu on WSL2**（home-manager 単体構成）: `ubuntu-wsl`。NixOS を導入しない WSL2 環境向け
- Ubuntu Desktop（予定）

## セットアップ

システム全体を管理する NixOS ホストと、ユーザー環境だけを管理する home-manager 単体構成の
2 通りがある。手順が異なるため、該当する方を参照する。

### NixOS ホストの場合（mars / triton）

NixOS はシステム全体を宣言的に管理するため、リポジトリを直接 `nixos-rebuild` で適用する。
ユーザー環境（home-manager）もシステムと同時に適用されるため、後述の
「home-manager 単体構成の場合」の手順は不要。

```sh
git clone https://github.com/Th3rm1t0/dotfiles.git ~/dotfiles
cd ~/dotfiles
sudo nixos-rebuild switch --flake .#<hostname>
```

以降は `just os-switch` で設定を適用する。適用後、[1Password CLI のセットアップ](#1password-cli-のセットアップ) に進む。

### home-manager 単体構成の場合（ubuntu-wsl 等、NixOS を導入しない環境）

#### 1. Nix をインストール

[nix-installer](https://github.com/NixOS/nix-installer) を使う。

```sh
curl -sSfL https://artifacts.nixos.org/nix-installer | sh -s -- install --enable-flakes
```

インストール後、シェルを再起動して `nix` コマンドが使えることを確認する。

#### 2. dotfiles を適用

リモートから直接実行できる（リポジトリのクローンは不要）。

```sh
nix run github:Th3rm1t0/dotfiles
```

ホスト名から設定を自動検出する。明示的に指定する場合：

```sh
nix run github:Th3rm1t0/dotfiles -- th3rm1t3@ubuntu-wsl
```

初回の適用時に以下が自動で行われる：

- zsh がデフォルトシェルに設定される（sudo を要求）
- 1Password shell-plugins のシェルラッパーが有効化される

適用後、シェルを再起動する。

#### 3. リポジトリをクローン（日常操作用）

```sh
git clone https://github.com/Th3rm1t0/dotfiles.git ~/dotfiles
cd ~/dotfiles
direnv allow
```

以降は `just switch` で設定を適用する。適用後、[1Password CLI のセットアップ](#1password-cli-のセットアップ) に進む。

### 1Password CLI のセットアップ

NixOS / home-manager 単体構成のどちらでも共通の手順。1Password shell-plugins は
宣言的に管理されているため、`op plugin init` は不要。アカウント登録とサインインだけ
手動で行う。

```sh
op account add --address my.1password.com
eval "$(op signin)"
```

サインイン後、`gh` を初回実行すると vault アイテムの選択を求められる。画面の指示に従って GitHub の認証情報を紐付ける。

```sh
gh auth status
```

## 開発環境

devShell に nixfmt・deadnix・statix・just・nh を含む。
direnv が有効な環境ではリポジトリに `cd` するだけで自動ロードされる。

```sh
direnv allow   # 初回のみ
```

### just レシピ

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

## ディレクトリ構成

このリポジトリは独立した 2 つの層で構成される。NixOS 層はシステム全体で 1 つに定まる設定、
home-manager 層はユーザーごとの設定を担う。両層は `common.nix` / `roles/` / `hosts/`（または
`services/` / `programs/`）/ `default.nix` という同じ形の構造を持つ。

### `flake.nix`

Nix flakes のエントリーポイント。
外部依存（nixpkgs、home-manager など）の宣言と、各ホスト設定のエクスポートを行う。
新規ホスト追加時は `home/hosts/<hostname>.nix`（home-manager 単体構成）または
`nixos/hosts/<hostname>/`（NixOS）を作成し、`lib.mkHome` / `lib.mkNixos` で 1 行追加する。

シークレットは 1Password CLI（`op`）を使い、実行時に取得する。
詳細は `home/programs/1password/README.md` を参照。

### `home/`（home-manager 層）

ユーザー環境の設定を定義する。

- **`common.nix`**：全ホスト共通設定
- **`default.nix`**：エントリーポイント。`programs/` 配下のディレクトリを自動探索してインポートする
- **`roles/`**：ホストの用途ごとに共通する設定（`wsl` / `desktop` / `bare-metal`）
- **`hosts/`**：ホストごとの設定。`common.nix` と `roles/` を組み合わせる
- **`programs/`**：アプリケーションごとにディレクトリを作成し、それぞれ `default.nix` を配置する。各モジュールは `dotfiles.programs.<name>.enable` オプションを持ち、ホスト設定から個別に有効/無効を切り替えられる（デフォルトは有効）。GUI・デスクトップ環境向けモジュールは全ホストへ無条件に import されるため、例外的にデフォルト無効とし `roles/desktop.nix` から有効化する
- **`claude/`**：Claude の Agent Skill を宣言的に管理する。詳細は `home/claude/README.md` を参照
- **`services/`**（予定）：バックグラウンドサービスの設定を定義する。home-manager の `services.*` に対応

### `nixos/`（NixOS 層）

システム全体の設定を定義する。

- **`common.nix`**：全ホスト共通設定
- **`default.nix`**：エントリーポイント。`services/` 配下のディレクトリを自動探索してインポートする
- **`roles/`**：ホストの用途ごとに共通する設定（`secure-boot` / `desktop`）
- **`hosts/`**：ホストごとの設定。`hardware-configuration.nix` 等のハードウェア固有情報を含む
- **`services/`**：システムサービスごとにディレクトリを作成し、それぞれ `default.nix` を配置する。各モジュールは `dotfiles.services.<name>.enable` オプションを持つ（デフォルトは無効。ホストごとに必要なものだけ有効化する）

### `overlays/`

nixpkgs の既存パッケージに対するオーバーレイを定義する。
外部 flake の overlay 集約、バージョン固定、パッチ適用に使う。

### `pkgs/`

nixpkgs に存在しないパッケージや、特殊なビルド定義を必要とするパッケージを定義する。
GitHub のみで公開されているツールの導入や、特定オプションを指定したビルドに使う。

### `lib/`

ヘルパー関数を定義する。`mkHome`（home-manager 単体構成）と `mkNixos`（NixOS）で
ホスト定義のボイラープレートを削減している。

## 参照の流れ

### home-manager 層

```text
flake.nix
│
│ lib.mkHome で参照
▼
home/hosts/<hostname>.nix
│
│ 共有設定を参照
▼
home/common.nix
│
│ アプリケーション設定を参照
▼
home/default.nix
│
│ programs/ を自動探索
▼
home/programs/*、home/services/*（予定）
```

### NixOS 層

```text
flake.nix
│
│ lib.mkNixos で参照
▼
nixos/hosts/<hostname>/
│
│ 共通設定・role を参照
▼
nixos/common.nix、nixos/roles/*
│
│ サービス設定を参照
▼
nixos/default.nix
│
│ services/ を自動探索
▼
nixos/services/*
```

NixOS ホストは home-manager モジュールを内蔵しているため、`nixosConfigurations` の評価時に
`home/hosts/<hostname>.nix` が `users.${username}` として組み込まれ、home-manager 層も
同時に評価される。

## 注意事項

- Nix flakes は Git にコミットまたはステージングされたファイルだけを参照してビルドする。
  新規ファイルは `git add` してからビルドすること。
- home-manager 単体構成では `just switch` の前に `just build` で成功を確認するのを推奨する。
  NixOS では `just os-switch` の前に `just os-build` で確認する。
- 問題発生時は `home-manager generations`（home-manager）または
  `sudo nixos-rebuild list-generations`（NixOS）で世代を確認し、ロールバックできる。
