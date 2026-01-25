{ ... }:

{
    programs.starship = {
        enable = true;
        enableZshIntegration = true;

        settings = {
            # Tokyo Night プリセット
            format = "[░▒▓](#a3aed2)[  ](bg:#a3aed2 fg:#090c0c)[](bg:#769ff0 fg:#a3aed2)$directory[](fg:#769ff0 bg:#394260)$git_branch$git_status[](fg:#394260 bg:#212736)$nodejs$rust$golang$php[](fg:#212736 bg:#1d2230)$time[ ](fg:#1d2230)$line_break$nix_shell$character";

            # 文字設定
            character = {
                success_symbol = "[➜](bold green)";
                error_symbol = "[➜](bold red)";
            };

            # ディレクトリ表示
            directory = {
                truncation_length = 3;
                truncation_symbol = "…/";
                style = "fg:#e3e5e5 bg:#769ff0";
                format = "[ $path ]($style)";
                read_only = " ";
            };

            # Git設定
            git_branch = {
                symbol = " ";
                style = "bg:#394260";
                format = "[[ $symbol$branch ](fg:#769ff0 bg:#394260)]($style)";
            };

            git_status = {
                style = "bg:#394260";
                format = "[[($all_status$ahead_behind )](fg:#769ff0 bg:#394260)]($style)";
            };

            # Nix Shell
            nix_shell = {
                symbol = " ";
                format = "via [$symbol$state( \($name\))](bold blue) ";
            };

            # プログラミング言語
            nodejs = {
                symbol = " ";
                style = "bg:#212736";
                format = "[[ $symbol($version) ](fg:#769ff0 bg:#212736)]($style)";
            };

            rust = {
                symbol = "󱘗 ";
                style = "bg:#212736";
                format = "[[ $symbol($version) ](fg:#769ff0 bg:#212736)]($style)";
            };

            golang = {
                symbol = " ";
                style = "bg:#212736";
                format = "[[ $symbol($version) ](fg:#769ff0 bg:#212736)]($style)";
            };

            php = {
                symbol = " ";
                style = "bg:#212736";
                format = "[[ $symbol($version) ](fg:#769ff0 bg:#212736)]($style)";
            };

            # 時間
            time = {
                disabled = false;
                time_format = "%R";
                style = "bg:#1d2230";
                format = "[[  $time ](fg:#a0a9cb bg:#1d2230)]($style)";
            };
        };
    };
}
