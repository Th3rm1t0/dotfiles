{ config, lib, ... }:

let
  cfg = config.dotfiles.programs.waybar;
in
{
  options.dotfiles.programs.waybar.enable = lib.mkEnableOption "waybar" // {
    default = false;
  };

  config = lib.mkIf cfg.enable (
    let
      colors = config.lib.stylix.colors.withHashtag;
    in
    {
      programs.waybar = {
        enable = true;
        settings.mainBar = {
          layer = "top";
          position = "top";
          height = 0;
          spacing = 4;

          modules-left = [ "hyprland/workspaces" ];
          modules-center = [ "clock" ];
          modules-right = [
            "pulseaudio"
            "network"
            "battery"
            "tray"
          ];

          clock = {
            format = "{:%H:%M}";
            format-alt = "{:%Y-%m-%d (%a)}";
            tooltip-format = "{:%Y年%m月%d日 (%A)}";
          };

          pulseaudio = {
            format = "{icon} {volume}%";
            format-muted = "󰝟 Muted";
            format-icons = {
              default = [
                "󰕿"
                "󰖀"
                "󰕾"
              ];
            };
          };

          network = {
            format-wifi = "󰤨 {essid}";
            format-ethernet = "󰈀 Wired";
            format-disconnected = "󰤮 Offline";
            tooltip-format = "{ifname}: {ipaddr}/{cidr}";
          };

          battery = {
            format = "{icon} {capacity}%";
            format-charging = "󰂄 {capacity}%";
            format-icons = [
              "󰁺"
              "󰁻"
              "󰁼"
              "󰁽"
              "󰁾"
              "󰁿"
              "󰂀"
              "󰂁"
              "󰂂"
              "󰁹"
            ];
            states = {
              warning = 25;
              critical = 10;
            };
          };

          tray = {
            spacing = 8;
            icon-size = 16;
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
              min-height: 0;
              box-shadow: none;
              text-shadow: none;
          }

          window#waybar {
              background: transparent;
          }

          tooltip {
              background: alpha(@base00, 0.9);
              border: 1px solid alpha(@base0D, 0.4);
              border-radius: 10px;
          }

          tooltip label {
              color: @base05;
              padding: 2px 4px;
          }

          .modules-left,
          .modules-center,
          .modules-right {
              background: alpha(@base00, 0.55);
              border: 1px solid alpha(@base06, 0.08);
              border-radius: 14px;
              margin: 6px 0;
              padding: 0 4px;
          }

          .modules-left {
              margin-left: 10px;
          }

          .modules-right {
              margin-right: 10px;
          }

          #workspaces,
          #clock,
          #pulseaudio,
          #network,
          #battery,
          #tray {
              padding: 0 8px;
          }

          #workspaces button {
              all: unset;
              min-width: 22px;
              margin: 4px 3px;
              padding: 2px 0;
              border-radius: 9px;
              color: alpha(@base05, 0.5);
              background: transparent;
              transition: all 0.2s ease-in-out;
          }

          #workspaces button.active {
              min-width: 30px;
              color: @base00;
              background: @base0D;
              font-weight: bold;
          }

          #workspaces button:hover {
              background: alpha(@base0D, 0.2);
              color: @base05;
          }

          #workspaces button.urgent {
              background: @base08;
              color: @base00;
          }

          #clock {
              color: @base0D;
              font-weight: 600;
          }

          #pulseaudio,
          #network,
          #battery {
              color: @base05;
          }

          #network,
          #battery {
              border-left: 1px solid alpha(@base03, 0.5);
              margin-left: 4px;
          }

          #network.disconnected {
              color: @base08;
          }

          #pulseaudio.muted {
              color: alpha(@base05, 0.4);
          }

          #battery.warning {
              color: @base0A;
          }

          #battery.critical:not(.charging) {
              color: @base08;
          }

          #battery.charging {
              color: @base0B;
          }

          #tray {
              margin-left: 4px;
          }

          #tray > .passive {
              opacity: 0.5;
          }

          #tray > .needs-attention {
              background: alpha(@base08, 0.6);
              border-radius: 8px;
          }
        '';
      };
    }
  );
}
