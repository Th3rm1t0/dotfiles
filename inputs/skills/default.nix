{
  lib,
  agent-skills,
  japanese-techwriting,
  karpathy-guidelines,
  vercel-agent-skills,
  vercel-skills,
  ui-skills,
  ...
}:

let
  sources = {
    local = {
      path = ./local;
      filter.maxDepth = 1;
    };

    japanese-techwriting = {
      path = japanese-techwriting;
      filter.maxDepth = 1;
    };

    karpathy-guidelines = {
      path = karpathy-guidelines;
      subdir = "skills";
    };

    vercel-agent-skills = {
      path = vercel-agent-skills;
      subdir = "skills";
    };

    vercel-skills = {
      path = vercel-skills;
      subdir = "skills";
    };

    ui-skills = {
      path = ui-skills;
      subdir = "skills";
    };
  };
in
{
  imports = [
    # homeManagerModules.default は inputs を bake するため、
    # サブ flake では raw import でソースを自前管理する
    (import "${agent-skills.outPath}/modules/home-manager/agent-skills.nix" {
      inherit lib;
      inputs = { };
    })
  ];

  programs.agent-skills = {
    enable = true;
    inherit sources;

    skills.enableAll = builtins.attrNames sources;

    targets.claude = {
      enable = true;
      structure = "link";
      dest = ".claude/skills";
    };
  };
}
