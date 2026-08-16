{ pkgs, ... }:
{
  fonts.fontconfig.enable = true;

  programs.foot.enable = true;
  programs.rofi.enable = true;

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

  # Hyprland 0.55 で設定形式が hyprlang から Lua へ移行中で、Stylix / home-manager の
  # 対応が追従途上のため、Hyprland の配色のみ Stylix の自動適用対象から外し、
  # home-manager 側で config.lib.stylix.colors を手動参照する。移行が安定したら
  # 元に戻す一時対応。
  stylix.targets.hyprland.enable = false;
}
