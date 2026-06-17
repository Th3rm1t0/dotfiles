{ inputs, ... }:

{
  imports = [ inputs.agent-skills.homeManagerModules.default ];

  programs.agent-skills = {
    enable = true;

    sources.local = {
      path = ./skills;
      filter.maxDepth = 1;
    };

    skills.enableAll = [ "local" ];

    targets.claude = {
      enable = true;
      structure = "link"; # store symlink にして read-only・再現性を確保
      # upstream はシェル変数入り dest を正規表現バグで処理できないため静的パスを渡す
      dest = ".claude/skills";
    };
  };
}
