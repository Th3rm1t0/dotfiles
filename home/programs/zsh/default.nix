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
    home.activation.setDefaultShell =
      let
        zshPath = "$HOME/.nix-profile/bin/zsh";
      in
      lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        currentShell=$(grep "^$USER:" /etc/passwd | cut -d: -f7)
        if [ "$currentShell" != "${zshPath}" ]; then
          if ! grep -qxF "${zshPath}" /etc/shells 2>/dev/null; then
            echo "${zshPath}" | /usr/bin/sudo tee -a /etc/shells >/dev/null
          fi
          /usr/bin/sudo chsh -s "${zshPath}" "$USER"
        fi
      '';

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
