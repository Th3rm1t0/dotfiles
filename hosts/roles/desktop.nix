{ pkgs, ... }:
{
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      "$mod" = "SUPER";
      bind = [
        "$mod, Return, exec, foot"   # 仮のターミナル
        "$mod, Q, killactive"
        "$mod SHIFT, E, exit"
      ];
    };
  };
}