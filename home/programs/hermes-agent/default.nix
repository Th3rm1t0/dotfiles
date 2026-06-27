{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:

{
  options.dotfiles.programs.hermes-agent.enable = lib.mkEnableOption "Hermes Agent" // {
    default = true;
  };

  config = lib.mkIf config.dotfiles.programs.hermes-agent.enable {
    home.packages = [
      inputs.hermes-agent.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
  };
}
