# Agent Skills

[agent-skills-nix](https://github.com/Kyure-A/agent-skills-nix) を使い、`~/.claude/skills/<name>/SKILL.md` として読み込まれる Agent Skill を宣言的に管理するサブ flake。
自作スキルと外部スキルを同じ仕組みで扱える。

## 構成

外部スキルは `flake.nix` に flake input として宣言し、`default.nix` の `sources` で参照する。
バージョンは `flake.lock` で固定され、`nix flake update --flake ./inputs/skills` で一括更新できる。

`home/default.nix` から `inputs.agent-skills.homeManagerModules.default` として import される。

## ローカルスキルの追加

`local/<name>/SKILL.md` を作って `git add` する。
`skills.enable` リストへの追加により有効化され、`~/.claude/skills/<name>/` へ store symlink で配置される。

## 外部スキルの追加

`flake.nix` に flake input を追加し、`default.nix` の `sources` に宣言する。

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
read-only かつアトミック更新、世代ロールバックが得られる。

`dest` には静的パス `.claude/skills` を明示している。
claude の既定 dest はシェル変数入りパスとして扱われるが、upstream の正規表現が Nix の POSIX ERE で不正エスケープとなり評価が失敗するため、静的パスで回避する。
