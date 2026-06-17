# 編集して使う雛形。{{ op://Vault/Item/field }} が `nix run .#render-secrets` 実行時に解決される。
database:
  password: {{ op://Private/example-db/password }}
api_key: {{ op://Private/example/api-key }}
