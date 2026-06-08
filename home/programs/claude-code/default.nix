{ inputs, pkgs, ... }:

{
  nixpkgs.overlays = [ inputs.claude-code.overlays.default ]; # 最新の claude-code への追従のため
 
  home.packages = with pkgs; [
    claude-code
  ];
}

