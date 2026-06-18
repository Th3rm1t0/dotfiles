# Dotfiles

Nix flakes と home-manager で管理する dotfiles リポジトリ。

## 対応環境

- Ubuntu on WSL2
- Ubuntu Desktop（予定）
- NixOS（予定）

## セットアップ

1. Nix をインストールする。

   ```sh
   sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install) --daemon
   ```

   OS ごとの差異は[公式ドキュメント](https://nixos.org/download/)を参照。

2. home-manager で設定を適用する。

   ```sh
   NIX_CONFIG="experimental-features = nix-command flakes" \
   nix run nixpkgs#home-manager -- switch --flake .#<username>@<hostname>
   ```

   `<username>` と `<hostname>` は環境に合わせて指定する。

## ディレクトリ構成

### `flake.nix`

Nix flakes のエントリーポイント。
外部依存（nixpkgs、home-manager など）の宣言と、各ホスト設定のエクスポートを行う。
新規ホスト追加時は `homeConfigurations` にエントリを追加する。

`apps.<system>.render-secrets` も公開しており、`nix run .#render-secrets` で 1Password の秘密参照テンプレート（`{{ op://... }}`）を実値へ解決する。
詳細は `home/programs/1password/README.md` を参照。

### `hosts/`

ホストとユーザーの組み合わせごとの設定を定義する。
`common.nix` に全ホスト共有の設定を置き、各ホストファイルで差分を上書きする。

### `home/`

ユーザー環境の設定を定義する。

- **`default.nix`**：エントリーポイント。各アプリケーションの設定をインポートし、home-manager の基本設定を行う
- **`programs/`**：アプリケーションごとにディレクトリを作成し、それぞれ `default.nix` を配置する。home-manager の `programs.*` に対応
- **`claude/`**：Claude の Agent Skill を宣言的に管理する。詳細は `home/claude/README.md` を参照
- **`services/`**（予定）：バックグラウンドサービスの設定を定義する。home-manager の `services.*` に対応

### `modules/`（予定）

home-manager や NixOS の標準モジュールにない設定を追加するカスタムモジュールを定義する。

### `pkgs/`（予定）

nixpkgs に存在しないパッケージや、特殊なビルド定義を必要とするパッケージを定義する。
GitHub のみで公開されているツールの導入や、特定オプションを指定したビルドに使う。

### `overlays/`（予定）

nixpkgs の既存パッケージに対するオーバーレイを定義する。
バージョン固定、パッチ適用、unstable チャンネルからの部分取得に使う。
`pkgs/` で定義したパッケージを nixpkgs に追加するオーバーレイもここで定義する。

### `lib/`（予定）

ユーティリティ関数を定義する。
共通化は、既存コードが十分に複雑で共通化の利点が上回る場合にのみ行う。

## 参照の流れ

```text
flake.nix
│
│ homeConfigurations で参照
▼
hosts/<hostname>.nix
│
│ 共有設定を参照
▼
hosts/common.nix
│
│ アプリケーション設定を参照
▼
home/default.nix
│
│ 各プログラムの設定を参照
▼
home/programs/*、home/services/*
```

## 注意事項

- Nix flakes は Git にコミットまたはステージングされたファイルだけを参照してビルドする。
  新規ファイルは `git add` してからビルドすること。
- `home-manager switch` の前に `home-manager build` で成功を確認するのを推奨する。
- 問題発生時は `home-manager switch --rollback` で直前の世代に戻せる。
