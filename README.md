# Dotfiles

Nix flakes および home-manager をメインに使用している dotfiles リポジトリ

# 対応環境

- Ubuntu on WSL2
- Ubuntu Desktop(予定)
- NixOS(予定)

# セットアップ手順

1. Nix をインストール
```sh
sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install) --daemon
```
※ OSによって違いがあるので詳細は [公式ドキュメント](https://nixos.org/download/)を参照

2. 
```sh
NIX_CONFIG="experimental-features = nix-command flakes" \
nix run nixpkgs#home-manager -- switch --flake .#<username>@<hostname>
```

<username> と <hostname> をそれぞれ指定の上で実行


# ディレクトリ構成

## flake.nix

Nix flakes のエントリーポイントとして機能
外部への依存 (nixpkgs や home-manager など) の宣言、および各ホストに対する設定のエクスポートを実施
新規ホスト追加時には `homeConfigurations` に設定を追加する

## hosts/

ホストマシンとユーザーの組み合わせ、およびそれらの組み合わせに紐付く設定を定義する

`common.nix` で全ホスト共有の設定を定義し、各ホストファイル側ではその値を継承しつつ差分を上書きする形で定義する。

<例>
- WSL において不要な設定を無効化
- GUI系ツールはデスクトップ環境でのみ有効化

## home/

ユーザー環境設定を定義する
ホームディレクトリに対して配置される各種設定ファイルの内容の定義を行う

`programs/` 配下は、アプリケーションごとにディレクトリを作成する。各ディレクトリには `default.nix` を配置し、必要に応じてエイリアス定義や生の設定ファイルを分離できる。

- `default.nix` : エントリーポイント。各種アプリケーション・ツールの設定情報のインポートと home-manager の基本設定を実施
- `programs/` : 各アプリケーション・ツールの設定を定義。 home-manager の `programs.*` namespace に対応させている
- `services/` : バックグラウンドで動作するサービスの設定を定義。 home-manager の `services.*` namespace に対応させている

## modules/

再利用可能なカスタムモジュールを定義する
home-manager や NixOS の標準モジュールに存在しない設定を追加したい場合に使用する

- `home-manager/` : home-manager 用カスタムモジュール

## pkgs/

nixpkgs に存在しないパッケージや、特殊なビルド定義を必要とするパッケージを定義する
GitHub のみで公開されてるツールの導入や、特定のオプションを指定してビルドしたいパッケージなどの定義はここに追加する

## overlays/

nixpkgs の既存パッケージに対するオーバーレイを定義する
主な用途は特定パッケージのバージョンの固定やパッチの適用、unstable チャンネルからの部分的なパッケージの取得などを想定
また、pkgs/ 配下で定義したパッケージを nixpkgs に対して追加するオーバーレイもここで定義する

## lib/

ボイラープレートコードやユーティリティ関数を定義する
認知的複雑度の観点もあるので、共通化に際しては既存のコードが十分に複雑であるかを考慮した上で、共通化のメリットの方が大きいと判断できる場合にのみ関数化する

# 参照の流れ
```text
flake.nix
│
│ homeConfigurations で指定した内容を参照
▼
hosts/<hostname>.nix
│
│ 共有設定を参照
▼
hosts/common.nix
│
│ 各種アプリケーションの設定を参照
▼
home/default.nix
│
│ 各種アプリケーションの具体的な設定を参照
▼
home/programs/* および home/services/*
```

# 注意
- Nix flakes は Git にコミットされているか、ステージングされた状態を参照してビルドするため、新規ファイルを追加した後は必ず `git add` を実行する
- `home-manager switch` の前に `home-manager build` でビルドが成功することを確認することを推奨する
- 設定変更後に問題が発生した場合は、`home-manager switch --rollback` で直前の状態に戻せる