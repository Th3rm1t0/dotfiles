{ config, pkgs, ... }:

{
  imports = [
    ../home
  ];

  home.stateVersion = "24.05";

  catppuccin = {
    enable = true;
    autoEnable = true;
    flavor = "mocha";
    accent = "blue";
  };

  targets.genericLinux.enable = true;

  # XDG Base Directory
  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;
      setSessionVariables = true;
    };
  };

  # Common packages
  home.packages = with pkgs; [
    coreutils
    curl
    wget
    git
    just

    ripgrep
    fd
    eza
    bat
    jq
    yq
    tree
  ];

  # Git
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Th3rm1t0";
        email = "80260010+Th3rm1t0@users.noreply.github.com";
      };
      init.defaultBranch = "main";
    };
  };
}
