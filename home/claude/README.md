# Claude Agent Skill の宣言的管理

[agent-skills-nix](https://github.com/Kyure-A/agent-skills-nix) を使い、`~/.claude/skills/<name>/SKILL.md` として読み込まれる Agent Skill を宣言的に管理する。
自作スキルと外部スキルを同じ仕組みで扱える。

claude-code パッケージの導入（`home/programs/claude-code`）とは別モジュールにしている。
パッケージ追従は overlay の技術的関心であり、skill は自分で書くコンテンツでライフサイクルが異なるためである。
加えて、skill は複数のエージェントが共有で読む資産でもある。

## ローカル skill の追加

`skills/<name>/SKILL.md` を作って `git add` する。
`skills.enableAll = [ "local" ]` により自動で有効化され、`~/.claude/skills/<name>/` へ store symlink で配置される。

## 外部 skill の追加

`default.nix` に source を宣言し、有効化する。
`flake.nix` の `inputs` に追加する必要はない。

```nix
sources.japanese-techwriting = {
  path = builtins.fetchGit {
    url = "https://gist.github.com/k16shikano/fd287c3133457c4fd8f5601d34aa817d";
    rev = "5ed08e4475365fd233aa0d3ab71c19b87e1a5732";
  };
  filter.maxDepth = 1;
};

skills.enableAll = [ "local" "japanese-techwriting" ];
```

skill は Markdown であり、ビルド成果物の再現性が問題にならないため、`rev` 固定の `builtins.fetchGit` で十分である。
`flake.nix` の `inputs` と `flake.lock` による管理は不要である。

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
