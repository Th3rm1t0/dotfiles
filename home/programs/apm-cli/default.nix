{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.dotfiles.programs.apm-cli.enable = lib.mkEnableOption "apm-cli" // {
    default = true;
  };

  config = lib.mkIf config.dotfiles.programs.apm-cli.enable {
    home.packages = [ pkgs.apm-cli ];
  };
}
