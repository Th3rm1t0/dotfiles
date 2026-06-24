{
  config,
  lib,
  ...
}:

{
  options.dotfiles.programs.gh.enable = lib.mkEnableOption "GitHub CLI" // {
    default = true;
  };

  config = lib.mkIf config.dotfiles.programs.gh.enable {
    programs.gh.enable = true;
  };
}
