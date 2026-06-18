{ inputs, ... }:

{
  imports = [ inputs.agent-skills.homeManagerModules.default ];

  programs.agent-skills = {
    enable = true;

    sources.local = {
      path = ./skills;
      filter.maxDepth = 1;
    };

    sources.japanese-techwriting = {
      path = builtins.fetchGit {
        url = "https://gist.github.com/k16shikano/fd287c3133457c4fd8f5601d34aa817d";
        rev = "5ed08e4475365fd233aa0d3ab71c19b87e1a5732";
      };
      filter.maxDepth = 1;
    };

    skills.enableAll = [ "local" "japanese-techwriting" ];

    targets.claude = {
      enable = true;
      structure = "link"; # store symlink にして read-only・再現性を確保
      # upstream はシェル変数入り dest を正規表現バグで処理できないため静的パスを渡す
      dest = ".claude/skills";
    };
  };
}
