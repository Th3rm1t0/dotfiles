# Dotfiles

Nix flakes と home-manager で管理する dotfiles リポジトリ。

## 対応環境

- Ubuntu on WSL2
- Ubuntu Desktop（予定）
- NixOS（予定）

## セットアップ

### 1. Nix をインストール

[nix-installer](https://github.com/NixOS/nix-installer) を使う。

```sh
curl -sSfL https://artifacts.nixos.org/nix-installer | sh -s -- install --enable-flakes
```

インストール後、シェルを再起動して `nix` コマンドが使えることを確認する。

### 2. dotfiles を適用

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

### 3. 1Password CLI のセットアップ

1Password shell-plugins は宣言的に管理されているため、`op plugin init` は不要。
アカウント登録とサインインだけ手動で行う。

```sh
op account add --address my.1password.com
eval "$(op signin)"
```

サインイン後、`gh` を初回実行すると vault アイテムの選択を求められる。画面の指示に従って GitHub の認証情報を紐付ける。

```sh
gh auth status
```

### 4. リポジトリをクローン（日常操作用）

```sh
git clone https://github.com/Th3rm1t0/dotfiles.git ~/dotfiles
cd ~/dotfiles
direnv allow
```

以降は `just switch` で設定を適用する。

## 開発環境

devShell に nixfmt・deadnix・statix・just・nh を含む。
direnv が有効な環境ではリポジトリに `cd` するだけで自動ロードされる。

```sh
direnv allow   # 初回のみ
```

### just レシピ

| コマンド | 内容 |
|----------|------|
| `just build` | nh home build |
| `just switch` | nh home switch |
| `just update` | flake.lock を更新 |
| `just gc` | Nix ストアのガベージコレクション |
| `just check` | nix flake check |
| `just fmt` | nixfmt でフォーマット |
| `just lint` | deadnix + statix で警告表示 |
| `just fix` | deadnix + statix の自動修正 + フォーマット |

## ディレクトリ構成

### `flake.nix`

Nix flakes のエントリーポイント。
外部依存（nixpkgs、home-manager など）の宣言と、各ホスト設定のエクスポートを行う。
新規ホスト追加時は `hosts/<hostname>.nix` を作成し、`lib.mkHome` で 1 行追加する。

シークレットは 1Password CLI（`op`）を使い、実行時に取得する。
詳細は `home/programs/1password/README.md` を参照。

### `hosts/`

ホストとユーザーの組み合わせごとの設定を定義する。
`common.nix` に全ホスト共有の設定を置き、各ホストファイルで差分を上書きする。

### `home/`

ユーザー環境の設定を定義する。

- **`default.nix`**：エントリーポイント。`programs/` 配下のディレクトリを自動探索してインポートする
- **`programs/`**：アプリケーションごとにディレクトリを作成し、それぞれ `default.nix` を配置する。各モジュールは `dotfiles.programs.<name>.enable` オプションを持ち、ホスト設定から個別に有効/無効を切り替えられる（デフォルトは有効）
- **`claude/`**：Claude の Agent Skill を宣言的に管理する。詳細は `home/claude/README.md` を参照
- **`services/`**（予定）：バックグラウンドサービスの設定を定義する。home-manager の `services.*` に対応

### `overlays/`

nixpkgs の既存パッケージに対するオーバーレイを定義する。
外部 flake の overlay 集約、バージョン固定、パッチ適用に使う。

### `pkgs/`

nixpkgs に存在しないパッケージや、特殊なビルド定義を必要とするパッケージを定義する。
GitHub のみで公開されているツールの導入や、特定オプションを指定したビルドに使う。

### `modules/`（予定）

home-manager や NixOS の標準モジュールにない設定を追加するカスタムモジュールを定義する。

### `lib/`

ヘルパー関数を定義する。`mkHome` でホスト定義のボイラープレートを削減している。

## 参照の流れ

```text
flake.nix
│
│ lib.mkHome で参照
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
│ programs/ を自動探索
▼
home/programs/*、home/services/*
```

## 注意事項

- Nix flakes は Git にコミットまたはステージングされたファイルだけを参照してビルドする。
  新規ファイルは `git add` してからビルドすること。
- `just switch` の前に `just build` で成功を確認するのを推奨する。
- 問題発生時は `home-manager generations` で世代を確認し、ロールバックできる。
