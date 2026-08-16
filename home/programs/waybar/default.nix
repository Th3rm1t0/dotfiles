{ config, lib, ... }:

{
  options.dotfiles.programs.waybar.enable = lib.mkEnableOption "waybar" // {
    default = false;
  };

  config = lib.mkIf config.dotfiles.programs.waybar.enable {
    programs.waybar = {
      enable = true;
      settings.mainBar = {
        layer = "top";
        position = "top";
        height = 34;
        modules-left = [ "hyprland/workspaces" ];
        modules-center = [ "clock" ];
        modules-right = [
          "pulseaudio"
          "network"
          "battery"
          "tray"
        ];
      };
    };
  };
}
