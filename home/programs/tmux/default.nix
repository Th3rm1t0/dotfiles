{ config, pkgs, ... }:

{
    programs.tmux = {
        enable = true;
        terminal = "tmux-256color";
        historyLimit = 10000;
        escapeTime = 0;
        baseIndex = 1;
        mouse = true;
        keyMode = "vi";
        prefix = "C-a";

        extraConfig = ''
            set -g renumber-windows on
            set -g set-titles on
            set -g focus-events on
            set -sa terminal-features ',xterm-256color:RGB'

            bind | split-window -h -c "#{pane_current_path}"
            bind - split-window -v -c "#{pane_current_path}"
            bind c new-window -c "#{pane_current_path}"

            bind h select-pane -L
            bind j select-pane -D
            bind k select-pane -U
            bind l select-pane -R
        '';
    };
}
