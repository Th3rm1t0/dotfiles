{
  config,
  lib,
  ...
}:

{
  options.dotfiles.programs.direnv.enable = lib.mkEnableOption "direnv" // {
    default = true;
  };

  config = lib.mkIf config.dotfiles.programs.direnv.enable {
    programs.direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };
  };
}
