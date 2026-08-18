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

          "$mod, left, movefocus, l"
          "$mod, right, movefocus, r"
          "$mod, up, movefocus, u"
          "$mod, down, movefocus, d"

          "$mod SHIFT, left, movewindow, l"
          "$mod SHIFT, right, movewindow, r"
          "$mod SHIFT, up, movewindow, u"
          "$mod SHIFT, down, movewindow, d"

          "$mod CTRL, left, resizeactive, -50 0"
          "$mod CTRL, right, resizeactive, 50 0"
          "$mod CTRL, up, resizeactive, 0 -50"
          "$mod CTRL, down, resizeactive, 0 50"

          "$mod, F, fullscreen"
          "$mod, P, pseudo"
          "$mod, J, layoutmsg, togglesplit"
        ]
        ++ (lib.concatMap (i: [
          "$mod, ${toString i}, workspace, ${toString i}"
          "$mod SHIFT, ${toString i}, movetoworkspace, ${toString i}"
        ]) (lib.range 1 9))
        ++ [
          "$mod, 0, workspace, 10"
          "$mod SHIFT, 0, movetoworkspace, 10"
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
          "match:namespace waybar, blur 1, ignore_alpha 0.2"
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
