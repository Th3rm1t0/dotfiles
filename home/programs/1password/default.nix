{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.dotfiles.programs._1password.enable = lib.mkEnableOption "1Password CLI" // {
    default = true;
  };

  config = lib.mkIf config.dotfiles.programs._1password.enable {
    home.packages = [ pkgs._1password-cli ];
  };
}
