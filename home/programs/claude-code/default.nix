{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:

{
  options.dotfiles.programs.claude-code.enable = lib.mkEnableOption "Claude Code" // {
    default = true;
  };

  config = lib.mkIf config.dotfiles.programs.claude-code.enable {
    nixpkgs.overlays = [ inputs.claude-code.overlays.default ];
    home.packages = [ pkgs.claude-code ];
  };
}
