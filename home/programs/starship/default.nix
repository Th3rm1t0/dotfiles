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
    catppuccin.starship.enable = false;

    programs.starship = {
      enable = true;
      enableZshIntegration = true;

      settings = {
        format = "[░▒▓](#b4befe)[  ](bg:#b4befe fg:#1e1e2e)[](bg:#89b4fa fg:#b4befe)$directory[](fg:#89b4fa bg:#45475a)$git_branch$git_status[](fg:#45475a bg:#313244)$nodejs$rust$golang$php[](fg:#313244 bg:#1e1e2e)$time[ ](fg:#1e1e2e)$line_break$nix_shell$character";

        character = {
          success_symbol = "[➜](bold green)";
          error_symbol = "[➜](bold red)";
        };

        directory = {
          truncation_length = 3;
          truncation_symbol = "…/";
          style = "fg:#cdd6f4 bg:#89b4fa";
          format = "[ $path ]($style)";
          read_only = " ";
        };

        git_branch = {
          symbol = " ";
          style = "bg:#45475a";
          format = "[[ $symbol$branch ](fg:#89b4fa bg:#45475a)]($style)";
        };

        git_status = {
          style = "bg:#45475a";
          format = "[[($all_status$ahead_behind )](fg:#89b4fa bg:#45475a)]($style)";
        };

        nix_shell = {
          symbol = " ";
          format = "via [$symbol$state( \($name\))](bold blue) ";
        };

        nodejs = {
          symbol = " ";
          style = "bg:#313244";
          format = "[[ $symbol($version) ](fg:#89b4fa bg:#313244)]($style)";
        };

        rust = {
          symbol = "󱘗 ";
          style = "bg:#313244";
          format = "[[ $symbol($version) ](fg:#89b4fa bg:#313244)]($style)";
        };

        golang = {
          symbol = " ";
          style = "bg:#313244";
          format = "[[ $symbol($version) ](fg:#89b4fa bg:#313244)]($style)";
        };

        php = {
          symbol = " ";
          style = "bg:#313244";
          format = "[[ $symbol($version) ](fg:#89b4fa bg:#313244)]($style)";
        };

        time = {
          disabled = false;
          time_format = "%R";
          style = "bg:#1e1e2e";
          format = "[[  $time ](fg:#a6adc8 bg:#1e1e2e)]($style)";
        };
      };
    };
  };
}
