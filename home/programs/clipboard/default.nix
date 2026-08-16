{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.dotfiles.programs.clipboard.enable = lib.mkEnableOption "clipboard" // {
    default = false;
  };

  config = lib.mkIf config.dotfiles.programs.clipboard.enable {
    home.packages = [
      pkgs.wl-clipboard
      pkgs.cliphist
    ];
  };
}
