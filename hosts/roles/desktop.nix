{ pkgs, ... }:
{
  programs.foot.enable = true;

  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      "$mod" = "SUPER";
      bind = [
        "$mod, Return, exec, foot"   # 仮のターミナル
        "$mod, Q, killactive"
        "$mod SHIFT, E, exit"
      ];
      input = {
        kb_layout = "jp";
      };
      exec-once = [
        "${pkgs.kdePackages.polkit-kde-agent-1}/libexec/polkit-kde-authentication-agent-1"
      ];
    };
  };
}