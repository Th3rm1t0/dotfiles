{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.dotfiles.programs.hyperfine.enable = lib.mkEnableOption "hyperfine" // {
    default = true;
  };

  config = lib.mkIf config.dotfiles.programs.hyperfine.enable {
    home.packages = [ pkgs.hyperfine ];
  };
}
