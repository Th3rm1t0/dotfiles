{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.dotfiles.programs.claude-code.enable = lib.mkEnableOption "Claude Code" // {
    default = true;
  };

  config = lib.mkIf config.dotfiles.programs.claude-code.enable {
    home.packages = [ pkgs.claude-code ];
  };
}
