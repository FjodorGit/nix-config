{
  config,
  pkgs,
  inputs,
  ...
}:
{
  programs.waybar =
    let
      iconSize = 28;
    in
    {
      enable = true;

      settings = {
        mainBar = {
          layer = "top";
          position = "top";
          # height = 15;
          # spacing = 7;
          fixed-center = true;
          exclusive = true;

          modules-left = [
            "custom/launcher"
            "hyprland/workspaces"
            "wlr/taskbar"
            "hyprland/window"
            "hyprland/submap"
          ];

          modules-center = [
            "privacy"
            "custom/recorder"
            "clock"
            "mpd"
            "mpris"
          ];

          modules-right = [
            "tray"
            "network"
            "backlight"
            "battery"
            "memory"
            "wireplumber"
            "custom/power"
          ];

          "hyprland/workspaces" = {
            format = "{icon}";
            disable-scroll = false;
            all-outputs = true;
            active-only = false;
            show-special = true;
            on-click = "activate";
            format-icons = {
              "1" = "1";
              "2" = "2";
              "3" = "3";
              "4" = "4";
              "5" = "5";
              "6" = "6";
            };
          };

          "hyprland/window" = {
            "format" = "{}";
            "separate-outputs" = true;
            "max-length" = 35;
            "rewrite" = {
              "(.*) - Mozilla Firefox" = "🦊 $1";
              "(.*) - LibreWolf" = "🐺 $1";
              "(.*) - Brave" = "🦁 $1";
              "(.*) - GNU Emacs (.*)" = " $1";
              "(.*).epub(.*)" = "󰂽 $1";
              "(.*)foot" = " Terminal $1";
            };
          };

          "hyprland/submap" = {
            "format" = " {}";
            "max-length" = 14;
            "tooltip" = false;
          };

          "wlr/taskbar" = {
            "format" = "{icon}";
            "icon-size" = iconSize;
            "spacing" = 0;
            "tooltip-format" = "{title}";
            "on-click" = "activate";
            "on-click-middle" = "close";
          };

          "custom/launcher" = {
            "format" = " ";
            "tooltip" = false;
            "on-click" = "fuzzel";
            "interval" = 86400;
          };

          "battery" = {
            "bat" = "BAT1";
            "interval" = 60;
            "states" = {
              "good" = 95;
              "warning" = 40;
              "critical" = 20;
            };
            "max-length" = 25;
            "format" = "{icon} {capacity}%";
            "format-charging" = " {capacity}%";
            "format-plugged" = " {capacity}%";
            "format-alt" = "{time} {icon}";
            "format-icons" = [
              "󰂎"
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

          };

          "mpd" = {
            "format" = "{stateIcon} {title}  ";
            "format-disconnected" = "  ";
            "format-stopped" = "  ";
            "title-len" = 20;
            "interval" = 10;
            "on-click" = "mpc toggle";
            "state-icons" = {
              "paused" = "";
              "playing" = "";
            };
            "tooltip-format" = "Mpd Connected";
            "tooltip-format-disconnected" = "";
          };

          "mpris" = {
            "format" = " {player_icon} {dynamic}";
            "format-paused" = "{status_icon} <i>{dynamic}</i>";
            "player-icons" = {
              "default" = "▶";
              "mpv" = "🎵";
            };
            "status-icons" = {
              "paused" = "󰏤";
            };
            "max-length" = 20;
          };

          "custom/power" = {
            "format" = "⏻";
            "on-click" = "d-power";
            "tooltip" = false;
            "interval" = 86400;
          };

          "clock" = {
            "format-alt" = " {:%a %d %b  %I:%M %p}";
            "format" = " {:%H:%M}";
            ##"timezones" = [ "Kolkata" ];
            ##"max-length" = 200;
            "interval" = 1;
            "calendar" = {
              "format" = {
                "months" = "<span color='#ffead3'><b>{}</b></span>";
                "today" = "<span color='#ff6699'><b>{}</b></span>";
              };
            };
            "tooltip-format" = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          };

          "tray" = {
            "icon-size" = iconSize;
            "spacing" = 10;
          };

          "cpu" = {
            "format" = " {usage: >3}%";
            "on-click" = "footclient -e btop";
          };

          "memory" = {
            "on-click" = "foot -e btop";
            "interval" = 30;
            "format" = " {percentage}%";
            "format-alt" = " {used}GB";
            "max-length" = 10;
          };

          "network" = {
            # "interface" = "wlp2s0";
            "format" = "⚠ Disabled";
            "format-wifi" = " {bandwidthDownBytes}  {bandwidthUpBytes}";
            "format-ethernet" = " {bandwidthDownBytes}  {bandwidthUpBytes}";
            "format-disconnected" = "⚠ Disconnected";
            "on-click" = "d-wifi";
            "interval" = 2;
          };

          "wireplumber" = {
            "scroll-step" = 2;
            "format" = "{icon} {volume: >3}%";
            "format-bluetooth" = "{icon} {volume: >3}%";
            "format-muted" = " ";
            "on-click" = "d-volume toggle";
            "on-click-middle" = "pavucontrol";
            "format-icons" = {
              "headphones" = "";
              "handsfree" = "";
              "headset" = "";
              "phone" = "";
              "portable" = "";
              "car" = "";
              "default" = [
                ""
                ""
              ];
            };
          };

          "backlight" = {
            "tooltip" = false;
            "format" = " {}%";
            "interval" = 1;
            "on-scroll-up" = "brigthnessctl set +5%";
            "on-scroll-down" = "brigthnessctl set 5%-";
          };

          "custom/recorder" = {
            "format" = "{}";
            "interval" = "once";
            "exec" = "echo ' '";
            "tooltip" = "false";
            "exec-if" = "pgrep wl-screenrec";
            "on-click" = "pkill -INT wl-screenrec";
            "signal" = 8;
          };

          "privacy" = {
            "icon-spacing" = 4;
            "icon-size" = iconSize;
            "transition-duration" = 250;
          };

          "custom/wallpaper" = {
            "format" = " ";
            "on-click" = "d-walls";
          };

        };
      };

      style = ''
        <<waybar-stylix>>
      '';

    };
  # home.file.".config/waybar/style.css".source = config.lib.file.mkOutOfStoreSymlink "/home/${vars.username}/d-git/d-nix/gdk/configs/style.css";

}
