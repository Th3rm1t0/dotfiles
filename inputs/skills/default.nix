{
  lib,
  agent-skills,
  japanese-techwriting,
  karpathy-guidelines,
  vercel-agent-skills,
  vercel-skills,
  ui-skills,
  anthropic,
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

    anthropic = {
      path = anthropic;
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

    skills.enable = [
      # ── 日本語・ライティング ──
      "japanese-techwriting"

      # ── コーディング規範 ──
      "karpathy-guidelines"

      # ── Vercel / React / Next.js ──
      "composition-patterns"
      "deploy-to-vercel"
      "find-skills"
      "react-best-practices"
      "react-native-skills"
      "react-view-transitions"

      # ── UI / デザイン ──
      "baseline-ui"
      "fixing-accessibility"
      "fixing-metadata"
      "fixing-motion-performance"
      "ui-skills-root"
      "web-design-guidelines"
      "writing-guidelines"

      # ── Anthropic 公式 ──
      "claude-api"
      "doc-coauthoring"
      "mcp-builder"
      "pdf"
      "skill-creator"
    ];

    targets.claude = {
      enable = true;
      structure = "link";
      dest = ".claude/skills";
    };
  };
}
