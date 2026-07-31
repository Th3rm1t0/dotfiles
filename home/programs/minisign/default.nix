{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.dotfiles.programs.minisign.enable = lib.mkEnableOption "minisign" // {
    default = true;
  };

  config = lib.mkIf config.dotfiles.programs.minisign.enable {
    home.packages = [ pkgs.minisign ];
  };
}
