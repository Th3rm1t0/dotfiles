# Claude Agent Skill の宣言的管理

[agent-skills-nix](https://github.com/Kyure-A/agent-skills-nix) を使い、`~/.claude/skills/<name>/SKILL.md` として読み込まれる Agent Skill を宣言的に管理する。
自作スキルと外部スキルを同じ仕組みで扱える。

claude-code パッケージの導入（`home/programs/claude-code`）とは別モジュールにしている。
パッケージ追従は overlay の技術的関心であり、skill は自分で書くコンテンツでライフサイクルが異なるためである。
加えて、skill は複数のエージェントが共有で読む資産でもある。

## 構成

skill ソースは `inputs/skills/` にサブ flake として分離し、各リポジトリを flake input で宣言している。
バージョンは `inputs/skills/flake.lock` で固定され、`nix flake update --flake ./inputs/skills` で一括更新できる。

このモジュール（`home/claude/default.nix`）はサブ flake の home-manager モジュールを import するだけの薄いラッパーである。

## ローカル skill の追加

`inputs/skills/local/<name>/SKILL.md` を作って `git add` する。
`enableAll` もしくは `skills.enable` リストへの追加により有効化され、`~/.claude/skills/<name>/` へ store symlink で配置される。

## 外部 skill の追加

`inputs/skills/flake.nix` に flake input を追加し、`inputs/skills/default.nix` の `sources` に宣言する。

```nix
# flake.nix
new-skill = {
  url = "github:owner/repo";
  flake = false;
};

# default.nix
sources.new-skill = {
  path = new-skill;
  subdir = "skills";
};
```

## 配置方式

`targets.claude.structure = "link"` は `home.file` の store symlink（`recursive = true; force = true`）で配置する。
read-only かつアトミック更新、世代ロールバックを得るため、可変リンク（`mkOutOfStoreSymlink`）は使わない。

`dest` には静的パス `.claude/skills` を明示している。
claude の既定 dest `${CLAUDE_CONFIG_DIR:-$HOME/.claude}/skills` は upstream の `staticDest` でシェル変数入りパスとして扱われる。
フォールバック抽出用の正規表現 `.*:-\$HOME/([^}]+)\}(.*)` が Nix の POSIX ERE では不正（`\}` が不正エスケープ）なため、評価が失敗する。
静的パスを指定すればこの分岐を踏まない。

## スキーマ

`github:Kyure-A/agent-skills-nix` の実ソースで確認した内容を以下に示す。

- **namespace**：`programs.agent-skills`
- **HM モジュール**：`homeManagerModules.default` のみ（`inputs` は export 時に bake 済み）
- **`nixosModules`**：存在しない。NixOS では home-manager の NixOS モジュール経由で読み込む
- **`sources.<n>`**：`{ input | path, subdir, idPrefix, filter.maxDepth, filter.nameRegex }`
- **`skills`**：`{ enable(list), enableAll(bool | list), explicit(attrs) }`
- **`targets.<n>`**：`{ enable, dest, structure(link|symlink-tree|copy-tree), systems }`
- 既定 target はすべて `enable = false`（opt-in）
