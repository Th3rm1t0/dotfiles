# AGENTS.md

このドキュメントは、AI エージェントがこの dotfiles リポジトリで作業する際のガイドラインを定義する。Nix flakes と home-manager を使用した dotfiles 管理のベストプラクティスに基づいている。

## プロジェクト概要

このリポジトリは Nix flakes と home-manager を使用して、複数環境（Linux/WSL）のユーザー環境を宣言的に管理する。

### 技術スタック

- **Nix flakes**: 依存関係の固定と再現性の保証
- **home-manager**: ユーザー環境（dotfiles、パッケージ）の宣言的管理
- **対象環境**: Linux (Ubuntu)、WSL

## ディレクトリ構造と役割
```
.
├── flake.nix           # エントリポイント：入力と出力の定義
├── flake.lock          # 依存関係のロックファイル（自動生成）
├── home/               # ユーザー環境設定の本体
│   ├── default.nix     # home/ のエントリポイント
│   ├── claude/         # Claude skill 管理（agent-skills-nix。programs と分離）
│   ├── programs/       # アプリケーション設定（programs.* に対応）
│   └── services/       # サービス設定（services.* に対応）
├── hosts/              # ホスト固有の設定
│   ├── common.nix      # 全ホスト共通設定
│   └── <hostname>.nix  # 各ホストの設定
├── modules/            # カスタムモジュール
│   ├── home-manager/   # home-manager 用カスタムモジュール
│   └── nixos/          # NixOS 用カスタムモジュール（将来用）
├── pkgs/               # カスタムパッケージ定義
├── overlays/           # nixpkgs の上書き・拡張
└── lib/                # ヘルパー関数
```

## 重要な規則

### Git 追跡の必須化

Nix flakes は Git で追跡されているファイルのみを認識する。新規ファイル作成後は必ず `git add` を実行すること。これを怠ると以下のエラーが発生する：
```
error: getting status of '/nix/store/...-source/flake.nix': No such file or directory
```

### ファイル作成・変更時の手順

1. ファイルを作成または編集
2. `git add <ファイル>` で追跡対象に追加
3. `nix build` または `home-manager build` でビルド確認
4. 問題なければ `home-manager switch` で適用

### inputs.nixpkgs.follows の使用

home-manager の nixpkgs バージョンを flake の nixpkgs と一致させること。これにより依存関係の不整合を防ぐ：
```nix
home-manager = {
  url = "github:nix-community/home-manager";
  inputs.nixpkgs.follows = "nixpkgs";  # 必須
};
```

## 設定の書き方

### programs.* vs xdg.configFile の使い分け

home-manager には2つの設定アプローチがある：

#### programs.* を使用すべき場合

- home-manager がそのプログラムのオプションを提供している場合
- Nix の型チェックや補完の恩恵を受けたい場合
- 設定の抽象化や条件分岐が必要な場合
```nix
programs.git = {
  enable = true;
  userName = "Your Name";
  userEmail = "you@example.com";
  delta.enable = true;
};
```

#### xdg.configFile / home.file を使用すべき場合

- home-manager がそのプログラムをサポートしていない場合
- 既存の設定ファイルをそのまま使いたい場合
- 設定ファイルの形式（Lua、TOML等）を維持したい場合
```nix
xdg.configFile."wezterm/wezterm.lua".source = ./wezterm.lua;
```

#### ハイブリッドアプローチ

複雑なプログラム（neovim 等）では両方を組み合わせる：
```nix
programs.neovim = {
  enable = true;
  extraPackages = with pkgs; [ nil lua-language-server ];
};

xdg.configFile = {
  "nvim/init.lua".source = ./config/init.lua;
  "nvim/lua".source = ./config/lua;
};
```

### モジュール分割の指針

設定が以下の条件を満たす場合、独立したファイルに分割する：

- 20行以上の設定がある
- 複数のオプションや依存パッケージを持つ
- 他のホストで有効/無効を切り替える可能性がある

分割時は `home/programs/<name>/default.nix` に配置する。

## コマンドリファレンス

### ビルドと適用
```bash
# ビルドのみ（適用しない）- 変更確認に使用
home-manager build --flake .#<user>@<host>

# ビルドして適用
home-manager switch --flake .#<user>@<host>

# 生成されたファイルの確認
ls -la ./result/home-files/
```

### 依存関係の管理
```bash
# flake.lock の更新
nix flake update

# 特定の入力のみ更新
nix flake lock --update-input nixpkgs

# flake の情報確認
nix flake show
nix flake metadata
```

### トラブルシューティング
```bash
# 過去の世代を確認
home-manager generations

# ロールバック
home-manager switch --rollback

# ガベージコレクション
nix-collect-garbage -d
```

## 新規追加の手順

### 新しいホストを追加する場合

1. `hosts/<hostname>.nix` を作成
2. `common.nix` をインポートし、ホスト固有設定を記述
3. `flake.nix` の `homeConfigurations` に追加：
```nix
homeConfigurations."<user>@<hostname>" = home-manager.lib.homeManagerConfiguration {
  pkgs = pkgsFor "x86_64-linux";
  modules = [ ./hosts/<hostname>.nix ];
};
```

4. `git add` してビルド確認

### 新しいプログラムを追加する場合

1. `home/programs/<name>/default.nix` を作成
2. home-manager オプションまたは xdg.configFile で設定
3. `home/default.nix` の imports に追加
4. `git add` してビルド確認

### カスタムモジュールを追加する場合

1. `modules/home-manager/<name>.nix` を作成
2. `options` と `config` を定義
3. `modules/home-manager/default.nix` でエクスポート
4. 使用する hosts ファイルでインポート

## よくある問題と解決策

### "file not found" エラー

原因: ファイルが Git で追跡されていない

解決:
```bash
git add -A
```

### "infinite recursion" エラー

原因: モジュール間の循環参照

解決:
- `lib.mkDefault` や `lib.mkForce` で優先度を明示
- imports の構造を見直し、循環を排除

### "collision" エラー（ファイル衝突）

原因: 既存ファイルと home-manager 生成ファイルの競合

解決:
```bash
# 既存ファイルをバックアップして削除
mv ~/.config/<file> ~/.config/<file>.bak
home-manager switch --flake .#<user>@<host>
```

### 設定変更が反映されない

原因: Nix store のキャッシュ

解決:
```bash
# 明示的に再ビルド
home-manager switch --flake .#<user>@<host> --recreate-lock-file
```

## コーディング規約

### ファイル命名規則

- Nix ファイル: `kebab-case.nix` または `default.nix`
- ディレクトリ: `kebab-case`
- 設定ファイル: 元のプログラムの規約に従う

## 参考リソース

- [Home Manager Manual](https://nix-community.github.io/home-manager/)
- [Home Manager Options Search](https://home-manager-options.extranix.com/)
- [NixOS & Flakes Book](https://nixos-and-flakes.thiscute.world/)
- [Nix Flakes Wiki](https://wiki.nixos.org/wiki/Flakes)
- [nix-starter-configs](https://github.com/Misterio77/nix-starter-configs)

## 変更履歴

このドキュメントは dotfiles リポジトリの進化に合わせて更新される。大きな構造変更があった場合は、このファイルも併せて更新すること。