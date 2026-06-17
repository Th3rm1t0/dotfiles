# home/claude — Claude skill 管理基盤

`~/.claude/skills/<name>/SKILL.md` として読み込まれる Agent Skill を、
[agent-skills-nix](https://github.com/Kyure-A/agent-skills-nix) で宣言的に管理する。
自作 (ローカル) skill と外部 skill を統一して扱う。

claude-code パッケージ導入 (`home/programs/claude-code`) とは別モジュールにしてある:
パッケージ追従は overlay の技術的関心、skill は自分で書くコンテンツでライフサイクルが
異なり、かつ skill は複数エージェントが共有で読む資産であるため。

## ローカル skill を追加する

`skills/<name>/SKILL.md` を作って `git add` する。`skills.enableAll = [ "local" ]`
により自動で有効化され、`~/.claude/skills/<name>/` へ store symlink で配置される。

## 外部 skill を追加する

1. `flake.nix` の inputs に取り込み元を追加 (`inputs.nixpkgs.follows = "nixpkgs"`)。
   flake でない配布なら `{ url = "..."; flake = false; }`。
2. `default.nix` に source を宣言:

   ```nix
   sources.anthropic = {
     input    = "anthropic-skills";  # inputs のキー名
     subdir   = "skills";
     idPrefix = "anthropic";         # ID 衝突回避 (pdf -> anthropic/pdf)
   };
   ```
3. `skills.enableAll = [ "local" "anthropic" ];` あるいは
   `skills.enable = [ "local/<id>" "anthropic/pdf" ];` で選択。

source に `input` 参照を使うため home-manager へ `extraSpecialArgs` で `inputs` を
渡す必要がある (WSL は flake.nix で対応済み。NixOS ホストを足す場合は
`home-manager.extraSpecialArgs` で渡すこと)。

## 配置方式

`targets.claude.structure = "link"` は home.file の store symlink
(`recursive = true; force = true`) で配置される。read-only・アトミック更新・
世代ロールバックを得るため可変リンク (`mkOutOfStoreSymlink`) は使わない。

`dest` は静的パス `.claude/skills` を明示している。claude の既定 dest
`${CLAUDE_CONFIG_DIR:-$HOME/.claude}/skills` は upstream の `staticDest` で
シェル変数入りパスとして扱われ、フォールバック抽出用の正規表現
`.*:-\$HOME/([^}]+)\}(.*)` が Nix の正規表現エンジン (POSIX ERE) では不正
(`\}` が不正エスケープ) なため評価が落ちる。静的パスならこの分岐を踏まない。

## 照合済みスキーマ

`github:Kyure-A/agent-skills-nix` の実ソースで確認:

- namespace: `programs.agent-skills`
- HM モジュール: `homeManagerModules.default` のみ (`inputs` は export 時に bake 済み)
- `nixosModules` は無い → NixOS では home-manager の NixOS モジュール経由で読み込む
- `sources.<n>` = `{ input | path, subdir, idPrefix, filter.maxDepth, filter.nameRegex }`
- `skills` = `{ enable(list), enableAll(bool | list), explicit(attrs) }`
- `targets.<n>` = `{ enable, dest, structure(link|symlink-tree|copy-tree), systems }`
- 既定 target は全て `enable = false` (opt-in)
