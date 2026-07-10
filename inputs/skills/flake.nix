{
  description = "Agent Skills";

  inputs = {
    agent-skills.url = "github:Kyure-A/agent-skills-nix";
    japanese-techwriting = {
      url = "git+https://gist.github.com/k16shikano/fd287c3133457c4fd8f5601d34aa817d";
      flake = false;
    };
    karpathy-guidelines = {
      url = "github:multica-ai/andrej-karpathy-skills";
      flake = false;
    };
    vercel-agent-skills = {
      url = "github:vercel-labs/agent-skills";
      flake = false;
    };
    vercel-skills = {
      url = "github:vercel-labs/skills";
      flake = false;
    };
    ui-skills = {
      url = "github:ibelick/ui-skills";
      flake = false;
    };
    anthropic = {
      url = "github:anthropics/skills";
      flake = false;
    };
  };

  outputs =
    {
      self,
      agent-skills,
      japanese-techwriting,
      karpathy-guidelines,
      vercel-agent-skills,
      vercel-skills,
      ui-skills,
      anthropic,
      ...
    }:
    {
      homeManagerModules.default =
        args:
        import ./default.nix (
          args
          // {
            inherit
              agent-skills
              japanese-techwriting
              karpathy-guidelines
              vercel-agent-skills
              vercel-skills
              ui-skills
              anthropic
              ;
          }
        );
    };
}
