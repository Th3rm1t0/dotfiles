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
          success_symbol = "[➜](bold green)";
          error_symbol = "[➜](bold red)";
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
