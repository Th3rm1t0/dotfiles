# home/programs/1password — 1Password CLI (op)

1Password CLI (`op`) をパッケージとして導入する。秘密情報は dotfiles や
平文ファイルに置かず、実行時に `op` 経由で取得する運用を前提とする。

WSL だが Windows デスクトップアプリには依存せず、Ubuntu 側だけで認証〜
秘密取得まで完結させる。

## 初期セットアップ（手動サインイン）

アカウント登録はブートストラップなので手動で一度だけ行う。リポジトリには
認証情報を一切置かない。

```bash
op account add --address my.1password.com --email <あなたのメール>
eval "$(op signin)"   # セッション解錠（既定で約 30 分キャッシュ）
op whoami             # 動作確認
```

設定は `~/.config/op/` に保存され、以後はパスワードだけで解錠できる。
デスクトップアプリ非導入のため生体認証は使えない。

## 基本的な使い方

```bash
# 単一フィールドの取得
op read "op://Private/GitHub/token"

# アイテムの取得
op item get "GitHub" --fields label=token

# 秘密を環境変数に注入してコマンド実行（.env を平文で置かない）
op run --env-file=.env -- <command>

# テンプレートに秘密を埋め込む
op inject -i config.tpl -o config
```

`op run` / `op inject` では値を `op://Vault/Item/field` 参照で書く。

## サービスアカウント（任意・自動化向け）

対話解錠を避けたい場合はサービスアカウントトークンを使う。トークンは
gitignore したファイルや実行時 env に置き、**Nix store には絶対に書かない**
（store は誰でも読める平文のため）。

```bash
export OP_SERVICE_ACCOUNT_TOKEN="ops_..."
op read "op://Private/GitHub/token"
```

## スコープ外（今回は入れていない）

- **SSH エージェント / git コミット署名**: 鍵を保管庫に封印したまま使う純正
  エージェントは、WSL では Windows デスクトップアプリ（`ssh.exe` 転送 +
  `op-ssh-sign-wsl`）か WSL 内 Linux アプリが必要。要るときに別途追加する。
- **sops-nix**: 1Password を秘密の根に据えるなら不要。秘密は `op read` で
  直接取れるため、暗号鍵を二重管理するだけになる。
