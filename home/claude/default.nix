{ inputs, ... }:

let
  fetchSkillRepo = { url, rev, subdir ? "skills" }: {
    path = "${builtins.fetchGit { inherit url rev; }}/${subdir}";
    filter.maxDepth = 1;
  };

  sources = {
    # ── ローカル ──
    local = {
      path = ./skills;
      filter.maxDepth = 1;
    };

    # ── 日本語・ライティング ──
    japanese-techwriting = {
      path = builtins.fetchGit {
        url = "https://gist.github.com/k16shikano/fd287c3133457c4fd8f5601d34aa817d";
        rev = "5ed08e4475365fd233aa0d3ab71c19b87e1a5732";
      };
      filter.maxDepth = 1;
    };

    # ── コーディング規範 ──
    karpathy-guidelines = fetchSkillRepo {
      url = "https://github.com/multica-ai/andrej-karpathy-skills";
      rev = "2c606141936f1eeef17fa3043a72095b4765b9c2";
    };

    # ── Vercel / React / Next.js ──
    vercel-agent-skills = fetchSkillRepo {
      url = "https://github.com/vercel-labs/agent-skills";
      rev = "f8a72b9603728bb92a217a879b7e62e43ad76c81";
    };

    vercel-skills = fetchSkillRepo {
      url = "https://github.com/vercel-labs/skills";
      rev = "e5c075e3a84b37c5eb398ab74e581558d3fceb0e";
    };

    # ── UI / デザイン ──
    ui-skills = fetchSkillRepo {
      url = "https://github.com/ibelick/ui-skills";
      rev = "ec9ea2bbb53a0ddc7f8356c9030e2a3e4fe21149";
    };
  };
in
{
  imports = [ inputs.agent-skills.homeManagerModules.default ];

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
