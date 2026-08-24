{ config, lib, ... }:

let
  cfg = config.dotfiles.programs.swaync;
  colors = config.lib.stylix.colors.withHashtag;
in
{
  options.dotfiles.programs.swaync.enable = lib.mkEnableOption "swaync" // {
    default = false;
  };

  config = lib.mkIf cfg.enable {
    services.swaync = {
      enable = true;

      settings = {
        positionX = "right";
        positionY = "top";
        layer = "overlay";
        control-center-layer = "top";
        layer-shell = true;
        cssPriority = "application";

        control-center-margin-top = 8;
        control-center-margin-bottom = 8;
        control-center-margin-right = 8;
        control-center-margin-left = 0;
        control-center-width = 380;
        control-center-height = 600;
        notification-window-width = 380;

        image-visibility = "when-available";
        transition-time = 200;
        hide-on-clear = false;
        hide-on-action = true;
        script-fail-notify = true;

        widgets = [
          "inhibitors"
          "title"
          "dnd"
          "notifications"
        ];
        widget-config = {
          title = {
            text = "通知";
            clear-all-button = true;
            button-text = "すべてクリア";
          };
          dnd = {
            text = "通知を一時停止";
          };
        };
      };

      style = ''
        @define-color base00 ${colors.base00};
        @define-color base01 ${colors.base01};
        @define-color base02 ${colors.base02};
        @define-color base03 ${colors.base03};
        @define-color base04 ${colors.base04};
        @define-color base05 ${colors.base05};
        @define-color base06 ${colors.base06};
        @define-color base07 ${colors.base07};
        @define-color base08 ${colors.base08};
        @define-color base09 ${colors.base09};
        @define-color base0A ${colors.base0A};
        @define-color base0B ${colors.base0B};
        @define-color base0C ${colors.base0C};
        @define-color base0D ${colors.base0D};
        @define-color base0E ${colors.base0E};
        @define-color base0F ${colors.base0F};

        * {
            font-family: "JetBrainsMono Nerd Font", sans-serif;
            font-size: 13px;
            box-shadow: none;
            text-shadow: none;
        }

        .control-center,
        .floating-notifications {
            background: transparent;
        }

        .control-center-list {
            background: transparent;
        }

        .notification-row {
            outline: none;
            margin: 6px 12px;
        }

        .notification {
            background: alpha(@base00, 0.9);
            border: 1px solid alpha(@base06, 0.08);
            border-radius: 14px;
            padding: 0;
        }

        .notification-content {
            padding: 8px;
        }

        .notification .summary {
            color: @base05;
            font-weight: bold;
        }

        .notification .body {
            color: @base04;
        }

        .notification .time {
            color: alpha(@base05, 0.5);
        }

        .notification.critical {
            border: 1px solid alpha(@base08, 0.4);
        }

        .close-button {
            background: alpha(@base02, 0.6);
            color: @base05;
            border-radius: 999px;
            padding: 0;
        }

        .close-button:hover {
            background: @base08;
        }

        .control-center {
            background: alpha(@base00, 0.9);
            border: 1px solid alpha(@base06, 0.08);
            border-radius: 14px;
        }

        .widget-title {
            color: @base05;
            font-weight: bold;
            padding: 8px;
        }

        .widget-title button {
            color: @base05;
            background: alpha(@base02, 0.6);
            border-radius: 999px;
        }

        .widget-dnd {
            padding: 8px;
        }

        .widget-dnd > switch {
            background: alpha(@base02, 0.6);
            border-radius: 999px;
        }

        .widget-dnd > switch:checked {
            background: @base0D;
        }

        .widget-dnd > switch slider {
            background: @base05;
            border-radius: 999px;
        }

        .widget-inhibitors {
            color: @base05;
            padding: 8px;
        }

        .widget-inhibitors > button {
            background: alpha(@base02, 0.6);
            border-radius: 999px;
        }
      '';
    };
  };
}
