{
  config,
  lib,
  ...
}:

{
  options.dotfiles.programs.zsh.enable = lib.mkEnableOption "zsh" // {
    default = true;
  };

  config = lib.mkIf config.dotfiles.programs.zsh.enable {
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      history = {
        size = 10000;
        save = 10000;
        ignoreDups = true;
        share = true;
      };

      shellAliases = {
        ll = "eza -al";
        gs = "git status -sb";
      };

      initContent = ''
        bindkey -v
      '';

      dotDir = "${config.xdg.configHome}/zsh";
    };
  };
}
