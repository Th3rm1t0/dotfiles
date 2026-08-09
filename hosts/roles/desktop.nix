{ pkgs, ... }:
{
  programs.foot.enable = true;

  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
  };

  programs.waybar = {
    enable = true;
    settings.mainBar = {
      layer = "top";
      position = "top";
      height = 32;
      modules-left = [ "hyprland/workspaces" ];
      modules-center = [ "clock" ];
      modules-right = [ "pulseaudio" "network" "battery" "tray" ];
    };
  };

  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      "$mod" = "SUPER";
      bind = [
        "$mod, Return, exec, foot"
        "$mod, Q, killactive"
        "$mod SHIFT, E, exit"
        "$mod, V, togglefloating"
        "$mod, D, exec, rofi -show drun"
      ];
      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];
      exec-once = [
        "${pkgs.kdePackages.polkit-kde-agent-1}/libexec/polkit-kde-authentication-agent-1"
        "waybar"
      ];
    };
  };
}