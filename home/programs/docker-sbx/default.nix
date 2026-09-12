{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.dotfiles.programs.docker-sbx.enable = lib.mkEnableOption "docker-sbx" // {
    default = true;
  };

  config = lib.mkIf config.dotfiles.programs.docker-sbx.enable {
    home.packages = [ pkgs.docker-sbx ];
  };
}
