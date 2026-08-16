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
  };
}
