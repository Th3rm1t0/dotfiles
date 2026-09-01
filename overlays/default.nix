{ inputs, ... }:

{
  claude-code = inputs.claude-code.overlays.default;
  herdr = inputs.herdr.overlays.default;

  apm-cli = final: prev: {
    apm-cli = prev.apm-cli.overridePythonAttrs (
      oldAttrs:
      let
        version = "0.28.0";
      in
      {
        inherit version;

        src = final.fetchFromGitHub {
          owner = "microsoft";
          repo = "apm";
          tag = "v${version}";
          hash = "sha256-dQrbDvewO7rL1oFR2bWaxA1DjcLJqdn483tHPv4Lod4=";
        };

        postPatch = ''
          substituteInPlace pyproject.toml \
            --replace-fail '"llm-github-models>=0.18.0",' ""
        '';

        dependencies =
          oldAttrs.dependencies
          ++ (with final.python3Packages; [
            truststore
            tomlkit
            websockets
          ]);
      }
    );
  };
}
