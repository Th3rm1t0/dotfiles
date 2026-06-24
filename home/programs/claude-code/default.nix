{ inputs, pkgs, ... }:

{
  nixpkgs.overlays = [ inputs.claude-code.overlays.default ];

  home.packages = with pkgs; [
    claude-code
  ];
}
