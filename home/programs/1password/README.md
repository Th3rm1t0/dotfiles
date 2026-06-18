# 1Password CLI の導入と秘密管理

`op` CLI を導入し、1Password を秘密の唯一の真実源とする。
平文の秘密は dotfiles にもコミットにも置かない。
WSL でも Windows アプリに依存せず、Ubuntu 側だけで完結する。

## サインイン（初回のみ）

```bash
op account add --address my.1password.com --email <メールアドレス>
eval "$(op signin)"
op whoami
```

設定は `~/.config/op/` に保存され、以後はパスワードだけで解錠できる。
デスクトップアプリは導入していないため、生体認証は使えない。

## 秘密ファイルの宣言的な生成（render-secrets）

`{{ op://... }}` 参照だけのテンプレートを配置し、`nix run` で実値ファイルへ解決する。
実値は Nix store に入れず、`$HOME` 下に 0600 で出力する。

| ファイル | 役割 |
|---|---|
| `secrets.nix` | 管理対象の一覧（増やすのはここ） |
| `templates/*.tpl` | `{{ op://Vault/Item/field }}` 入りの雛形 |
| `render-secrets.nix` | 生成ロジック（通常は変更不要） |

### 実行

```bash
eval "$(op signin)"
nix run .#render-secrets   # 一覧の全テンプレートを実値ファイルへ生成
```

### 秘密ファイルの追加

1. `templates/foo.tpl` を作る（中に `{{ op://Vault/Item/field }}` を記述）。

2. `secrets.nix` に 1 行追加する。

   ```nix
   { template = ./templates/foo.tpl; out = ".aws/credentials"; }
   ```

   `out` は `$HOME` からの相対パス。
   親ディレクトリは自動作成される。

3. `git add` してから `nix run .#render-secrets` を実行する。

参照先（vault、item、field）は 1Password に実在する必要がある。
コミットするのはテンプレートと一覧だけであり、生成物（実値入り）はコミットしない。

## その他の取得方法

```bash
op read "op://Private/GitHub/token"     # 単発で 1 個だけ取得
op run --env-file=.env -- <command>      # 環境変数で渡す（ファイルを作らない）
```

## 採用していないもの

- **SSH エージェントと git コミット署名**：WSL では Windows デスクトップアプリか WSL 内 Linux アプリが必要なため、導入していない。
- **sops-nix**：1Password を真実の源とするため不要。暗号化ファイルを git で管理したい用途が出た場合に検討する。
