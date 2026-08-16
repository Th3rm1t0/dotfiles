{
  config,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    inputs.op-shell-plugins.hmModules.default
    ./default.nix
  ];

  home.stateVersion = "24.05";

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
