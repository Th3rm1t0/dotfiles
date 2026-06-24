{
  config,
  lib,
  ...
}:

{
  options.dotfiles.programs.starship.enable = lib.mkEnableOption "starship" // {
    default = true;
  };

  config = lib.mkIf config.dotfiles.programs.starship.enable {
    programs.starship = {
      enable = true;
      enableZshIntegration = true;

      settings = {
        character = {
          success_symbol = "[[ ](green) ❯](peach)";
          error_symbol = "[[ ](red) ❯](peach)";
          vimcmd_symbol = "[ ❮](subtext1)";
        };

        directory = {
          truncation_length = 4;
          style = "bold lavender";
        };

        git_branch.style = "bold mauve";

        nix_shell = {
          symbol = " ";
          format = "via [$symbol$state( \($name\))](bold blue) ";
        };
      };
    };
  };
}
