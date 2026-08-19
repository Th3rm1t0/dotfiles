{ config, lib, pkgs, ... }:

{
  options.dotfiles.programs.spotify.enable = lib.mkEnableOption "spotify" // {
    default = false;
  };

  config = lib.mkIf config.dotfiles.programs.spotify.enable {
    home.packages = [ pkgs.spotify ];
  };
}
