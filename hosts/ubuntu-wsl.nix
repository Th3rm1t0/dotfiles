{ config, pkgs, ... }:

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

  targets.genericLinux.enable = true;

  nix = {
    package = pkgs.nix;
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      warn-dirty = true;
    };
  };
}
