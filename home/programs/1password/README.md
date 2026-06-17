# home/programs/1password — 1Password CLI (op)

`op` CLI を導入し、秘密は **1Password を真実の源**として実行時に取得する。
平文の秘密は dotfiles にもコミットにも置かない。WSL でも Windows アプリに
依存せず、Ubuntu 側だけで完結する。

## サインイン（初回のみ・手動）

```bash
op account add --address my.1password.com --email <あなたのメール>
eval "$(op signin)"
op whoami
```
設定は `~/.config/op/` に保存され、以後はパスワードだけで解錠できる
（デスクトップアプリ非導入のため生体認証は使えない）。

## 秘密ファイルを宣言的に生成する（render-secrets）

`{{ op://... }}` 参照だけのテンプレートを置き、`nix run` で実値ファイルへ解決する。
実値は Nix store に焼かず `$HOME` 下に 0600 で出力する。

| ファイル | 役割 |
|---|---|
| `secrets.nix` | **管理対象の一覧**（増やすのはここ） |
| `templates/*.tpl` | `{{ op://Vault/Item/field }}` 入りの雛形 |
| `render-secrets.nix` | 生成ロジック（基本は触らない） |

### 実行

```bash
eval "$(op signin)"
nix run .#render-secrets   # 一覧の全テンプレを実値ファイルへ生成
```

### 秘密ファイルを増やす

1. `templates/foo.tpl` を作る（中に `{{ op://Vault/Item/field }}`）
2. `secrets.nix` に1行足す:
   ```nix
   { template = ./templates/foo.tpl; out = ".aws/credentials"; }
   ```
   `out` は `$HOME` からの相対パス。親ディレクトリは自動作成される。
3. `git add` して `nix run .#render-secrets`

参照先（vault/item/field）が 1Password に実在する必要がある。**コミットするのは
テンプレートと一覧だけ**で、生成物（実値入り）はコミットしない。

## その他の取得方法

```bash
op read "op://Private/GitHub/token"     # 単発で1個だけ
op run --env-file=.env -- <command>      # env で渡す（ファイルを作らない）
```

## 採用していないもの

- **SSH エージェント / git コミット署名**: WSL では Windows デスクトップアプリか
  WSL 内 Linux アプリが必要なため、今回は入れていない。
- **sops-nix**: 1Password を真実の源にするため不要。暗号化したファイルを git で
  バージョン管理したい用途が出てきたら別途検討する。
