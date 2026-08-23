{ ... }:
{
  imports = [
    ../common.nix
    ../roles/bare-metal.nix
    ../roles/desktop.nix
  ];

  home = {
    username = "th3rm1t3";
    homeDirectory = "/home/th3rm1t3";
  };

  dotfiles.programs = {
    neovim.enable = true;
  };

  # 自動検出だとスケール1.5倍になり文字が大きすぎるため等倍に固定する。
  wayland.windowManager.hyprland.settings.monitor = [
    "eDP-1,1920x1080@60,0x0,1.0"
  ];
}
