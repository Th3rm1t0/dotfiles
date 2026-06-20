# 1Password CLI の導入と秘密管理

`op` CLI を導入し、1Password を秘密の唯一の真実源とする。
平文の秘密は dotfiles にもコミットにも置かない。
シークレットはファイルに書き出さず、実行時に 1Password から取得する。

## 初期設定

サインインとプラグインの設定は `setup.sh` が実行する。
対話的にメールアドレス、マスターパスワード、vault/item の選択を求められる。
設定は `~/.config/op/` に保存され、以後はパスワードだけで解錠できる。
デスクトップアプリは導入していないため、生体認証は使えない。

## シークレットの取得方法

優先度順に使い分ける。

### 1. `op plugin` — CLI ツールの透過的ラップ

対応ツール（`gh`, `aws` など）は `op plugin` でシークレット注入を自動化できる。

```bash
op plugin init gh
```

設定後は `gh` を普通に実行するだけで 1Password からトークンが注入される。
対応ツールの一覧は `op plugin list` で確認できる。

### 2. アプリ固有の credential hook

外部コマンドからの認証取得を公式にサポートするツールでは、`op read` を組み合わせる。

```ini
# ~/.aws/config の例
[default]
credential_process = op read "op://Vault/AWS/access-key" --format json
```

### 3. `op run` — 環境変数でコマンドに渡す

ファイルを作らず、環境変数経由でシークレットを渡す。

```bash
op run --env-file=.env.tpl -- <command>
```

`.env.tpl` にはプレースホルダだけを記述する。

```env
API_KEY={{ op://Vault/Item/api-key }}
DB_PASSWORD={{ op://Vault/Item/password }}
```

頻繁に使うコマンドは zsh の `shellAliases` でラップする。

```nix
shellAliases = {
    myapp = ''op run --env-file="$HOME/.config/myapp/env.tpl" -- myapp'';
};
```

### 4. `op read` — 単発で 1 個だけ取得

```bash
op read "op://Private/GitHub/token"
```

## 採用していないもの

- **秘密ファイルの事前生成（`op inject`）**：HM の宣言的ライフサイクルに合わず、命令的な別ステップが必要になるため廃止した。
- **sops-nix / agenix**：暗号化鍵のホスト間配布が必要になる。1Password を真実の源とするため不要。
- **SSH エージェントと git コミット署名**：WSL では Windows デスクトップアプリか WSL 内 Linux アプリが必要なため、導入していない。
