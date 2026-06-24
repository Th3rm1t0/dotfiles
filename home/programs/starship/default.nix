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
        format = "[░▒▓](lavender)[  ](bg:lavender fg:base)[](bg:blue fg:lavender)$directory[](fg:blue bg:surface1)$git_branch$git_status[](fg:surface1 bg:surface0)$nodejs$rust$golang$php[](fg:surface0 bg:base)$time[ ](fg:base)$line_break$nix_shell$character";

        character = {
          success_symbol = "[➜](bold green)";
          error_symbol = "[➜](bold red)";
        };

        directory = {
          truncation_length = 3;
          truncation_symbol = "…/";
          style = "fg:text bg:blue";
          format = "[ $path ]($style)";
          read_only = " ";
        };

        git_branch = {
          symbol = " ";
          style = "bg:surface1";
          format = "[[ $symbol$branch ](fg:blue bg:surface1)]($style)";
        };

        git_status = {
          style = "bg:surface1";
          format = "[[($all_status$ahead_behind )](fg:blue bg:surface1)]($style)";
        };

        nix_shell = {
          symbol = " ";
          format = "via [$symbol$state( \($name\))](bold blue) ";
        };

        nodejs = {
          symbol = " ";
          style = "bg:surface0";
          format = "[[ $symbol($version) ](fg:blue bg:surface0)]($style)";
        };

        rust = {
          symbol = "󱘗 ";
          style = "bg:surface0";
          format = "[[ $symbol($version) ](fg:blue bg:surface0)]($style)";
        };

        golang = {
          symbol = " ";
          style = "bg:surface0";
          format = "[[ $symbol($version) ](fg:blue bg:surface0)]($style)";
        };

        php = {
          symbol = " ";
          style = "bg:surface0";
          format = "[[ $symbol($version) ](fg:blue bg:surface0)]($style)";
        };

        time = {
          disabled = false;
          time_format = "%R";
          style = "bg:base";
          format = "[[  $time ](fg:subtext0 bg:base)]($style)";
        };
      };
    };
  };
}
