{
  config,
  lib,
  pkgs,
  ...
}:

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

      # nm-applet は wlroots 系の SNI tray に表示されないため rofi + nmcli で代替
      wifiMenu = pkgs.writeShellApplication {
        name = "waybar-wifi-menu";
        runtimeInputs = [
          pkgs.networkmanager
          pkgs.rofi
          pkgs.gawk
        ];
        text = ''
          wifi_list=$(nmcli -t -f active,ssid dev wifi list --rescan yes)

          menu=$(printf '%s\n' "$wifi_list" | awk -F: '
            $2 != "" && !seen[$2]++ {
              printf "%s %s\n", ($1 == "yes" ? "*" : " "), $2
            }
          ')

          chosen=$(printf '%s\n' "$menu" | rofi -dmenu -i -p "Wi-Fi")
          if [ -z "$chosen" ]; then
            exit 0
          fi
          ssid=''${chosen#??}

          if err=$(nmcli device wifi connect "$ssid" 2>&1); then
            exit 0
          fi

          if ! printf '%s' "$err" | grep -qi "secrets"; then
            rofi -e "Wi-Fi 接続に失敗しました: $ssid"
            exit 1
          fi

          password=$(rofi -dmenu -password -p "Password for $ssid")
          if [ -z "$password" ]; then
            exit 0
          fi

          if ! nmcli device wifi connect "$ssid" password "$password"; then
            rofi -e "Wi-Fi 接続に失敗しました: $ssid"
          fi
        '';
      };
    in
    {
      home.packages = [
        pkgs.pavucontrol
        pkgs.playerctl
      ];

      programs.waybar = {
        enable = true;
        settings.mainBar = {
          layer = "top";
          position = "top";
          height = 0;
          spacing = 4;

          modules-left = [
            "hyprland/workspaces"
            "wlr/taskbar"
          ];
          modules-center = [ "clock" ];
          modules-right = [
            "mpris#player"
            "mpris#title"
            "pulseaudio"
            "network"
            "battery"
            "custom/notification"
            "tray"
          ];

          clock = {
            format = "{:%H:%M}";
            format-alt = "{:%Y-%m-%d (%a)}";
            tooltip-format = "{:%Y年%m月%d日 (%A)}";
          };

          "wlr/taskbar" = {
            format = "{icon}";
            icon-size = 18;
            tooltip-format = "{title}";
            on-click = "activate";
            on-click-middle = "close";
          };

          "mpris#player" = {
            format = "{player_icon} {player}";
            player-icons = {
              default = "󰐊";
              spotify = "󰓇";
            };
          };

          "mpris#title" = {
            format = "{status_icon} {dynamic}";
            dynamic-len = 40;
            status-icons = {
              playing = "󰐊";
              paused = "󰏤";
            };
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
            scroll-step = 5;
            on-click = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
            on-click-right = "pavucontrol";
          };

          network = {
            format-wifi = "󰤨 {essid}";
            format-ethernet = "󰈀 Wired";
            format-disconnected = "󰤮 Offline";
            tooltip-format = "{ifname}: {ipaddr}/{cidr}";
            on-click = "${wifiMenu}/bin/waybar-wifi-menu";
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

          "custom/notification" = {
            tooltip = false;
            format = "{icon}";
            format-icons = {
              notification = "󱅫";
              none = "󰂚";
              dnd-notification = "󱏨";
              dnd-none = "󰂛";
            };
            return-type = "json";
            exec-if = "which swaync-client";
            exec = "swaync-client -swb";
            on-click = "swaync-client -t -sw";
            on-click-right = "swaync-client -d -sw";
            escape = true;
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
          #taskbar,
          #clock,
          #player,
          #title,
          #pulseaudio,
          #network,
          #battery,
          #custom-notification,
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

          #taskbar {
              border-left: 1px solid alpha(@base03, 0.5);
              margin-left: 4px;
          }

          #taskbar button {
              all: unset;
              padding: 0 4px;
              margin: 0 2px;
              border-radius: 8px;
              transition: all 0.2s ease-in-out;
          }

          #taskbar button.active {
              background: alpha(@base0D, 0.25);
          }

          #player,
          #title,
          #pulseaudio,
          #network,
          #battery {
              color: @base05;
          }

          #title,
          #pulseaudio,
          #network,
          #battery,
          #custom-notification {
              border-left: 1px solid alpha(@base03, 0.5);
              margin-left: 4px;
          }

          #player.paused,
          #title.paused {
              opacity: 0.5;
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

          #custom-notification {
              color: @base05;
              opacity: 0.6;
              border-radius: 8px;
              transition: all 0.2s ease-in-out;
          }

          #custom-notification:hover {
              opacity: 1;
              background: alpha(@base0D, 0.15);
          }

          #custom-notification.notification {
              opacity: 1;
              color: @base0D;
              background: alpha(@base0D, 0.18);
          }

          #custom-notification.dnd-notification {
              opacity: 1;
              color: @base0A;
              background: alpha(@base0A, 0.18);
          }

          #custom-notification.dnd-none {
              opacity: 0.4;
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
