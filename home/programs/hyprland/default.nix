{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.dotfiles.programs.hyprland.enable = lib.mkEnableOption "hyprland" // {
    default = false;
  };

  config = lib.mkIf config.dotfiles.programs.hyprland.enable {
    wayland.windowManager.hyprland = {
      enable = true;
      settings = {
        "$mod" = "SUPER";
        bind = [
          "$mod, Return, exec, kitty"
          "$mod, Q, killactive"
          "$mod SHIFT, E, exit"
          "$mod, V, togglefloating"
          "$mod, D, exec, rofi -show drun"
          "$mod SHIFT, V, exec, cliphist list | rofi -dmenu | cliphist decode | wl-copy"
        ];
        bindm = [
          "$mod, mouse:272, movewindow"
          "$mod, mouse:273, resizewindow"
        ];
        decoration.blur = {
          enabled = true;
          size = 6;
          passes = 2;
          new_optimizations = true;
        };
        layerrule = [
          "blur, waybar"
          "ignorealpha 0.2, waybar"
        ];
        exec-once = [
          "${pkgs.kdePackages.polkit-kde-agent-1}/libexec/polkit-kde-authentication-agent-1"
          "waybar"
          "wl-paste --watch cliphist store"
          "fcitx5 -d"
        ];
      };
    };
  };
}
