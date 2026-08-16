{ ... }:
{
  wsl = {
    enable = true;
    defaultUser = "th3rm1t3";
    interop.register = true;
    wslConf.network.hostname = "triton";
  };

  # VS Code Remote (WSL) 等の動的リンクバイナリ用
  programs.nix-ld.enable = true;

  dotfiles.services = {
    changedetection-io.enable = true;
  };

  system.stateVersion = "25.05";
}
