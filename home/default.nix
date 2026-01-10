{ config, pkgs, ... }:

{
    imports = [];

    programs.home-manager.enable = true;

    # Nix
    nix = {
        package = pkgs.nix;
        settings = {
            experimental-features = [ "nix-command" "flakes" ];
      warn-dirty = false;
        };
    };
}