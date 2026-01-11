{ config, pkgs, ... }:

{
    imports = [
        ./programs/fzf
        ./programs/zsh
    ];

    programs.home-manager.enable = true;

    # Nix
    nix = {
        package = pkgs.nix;
        settings = {
            experimental-features = [ "nix-command" "flakes" ];
      warn-dirty = true;
        };
    };
}
