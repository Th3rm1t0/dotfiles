{ pkgs, ... }:
{
  wsl = {
    enable = true;
    defaultUser = "th3rm1t3";
    interop.register = true;
    wslConf.network.hostname = "triton";
  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # VS Code Remote (WSL) 等の動的リンクバイナリ用
  programs.nix-ld.enable = true;

  programs.zsh.enable = true;
  users.users.th3rm1t3 = {
    shell = pkgs.zsh;
    extraGroups = [ "docker" ];
  };

  virtualisation.docker.enable = true;

  system.stateVersion = "25.05";
}
