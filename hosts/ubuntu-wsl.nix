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
        BROWSER = "wslview";
    };

    home.packages = with pkgs; [
        wslu # WSL utilities
    ];

    programs.git.settings = {
        # Avoid CRLF conversion issues in WSL
        core.autocrlf = "input";
    };
}
