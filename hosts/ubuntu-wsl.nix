{ config, pkgs, ... }:

{
  imports = [
    ./common.nix
  ];

  home = {
    username = "th3rm1t3";
    homeDirectory = "/home/th3rm1t3";
  };

  programs.wezterm.enable = false;

  home.sessionVariables = {
    # wslview は Ubuntu WSL に標準で入っている wslu (apt) から利用できる。
    # nixpkgs の wslu はプロジェクト終了により削除されたため、ここでは導入しない。
    BROWSER = "wslview";
  };

  programs.git.settings.core = {
    autocrlf = "input";
    sshCommand = "ssh.exe";
  };
}
