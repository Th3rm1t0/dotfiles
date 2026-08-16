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
}
