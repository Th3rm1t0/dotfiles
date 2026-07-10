{ ... }:
{
  imports = [
    ./common.nix
    ./roles/wsl.nix
  ];

  home = {
    username = "th3rm1t3";
    homeDirectory = "/home/th3rm1t3";
  };

  programs.wezterm.enable = false;
}
