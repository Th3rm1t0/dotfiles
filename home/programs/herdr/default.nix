{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.dotfiles.programs.herdr.enable = lib.mkEnableOption "herdr" // {
    default = true;
  };

  config = lib.mkIf config.dotfiles.programs.herdr.enable {
    home.packages = [ pkgs.herdr ];
  };
}
