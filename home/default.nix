{ config, pkgs, ... }:

{
    imports = [
        ./programs/claude-code
        ./programs/fzf
        ./programs/starship
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
