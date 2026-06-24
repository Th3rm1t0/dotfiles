{
  config,
  lib,
  ...
}:

{
  options.dotfiles.programs.fzf.enable = lib.mkEnableOption "fzf" // {
    default = true;
  };

  config = lib.mkIf config.dotfiles.programs.fzf.enable {
    programs.fzf = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}
