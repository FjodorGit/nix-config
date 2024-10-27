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
      catppuccin = {
        enable = true;
        mode = "createLink";
      };

      settings = {
        mainBar = {
          "margin-top" = 5;
          "margin-left" = 10;
          "margin-right" = 10;
          "height" = 30;
          "modules-left" =
            [
            ];
          "modules-center" = [
            "hyprland/workspaces"
          ];
          "modules-right" = [
            "pulseaudio"
            "network"
            "bluetooth"
            "temperature"
            "hyprland/language"
            "battery"
            "clock"
          ];
          "hyprland/window" = {
            "format" = "{}";
            "max-length" = 35;
            "rewrite" = {
              "" = "Hyprland";
            };
            "separate-outputs" = true;
          };
          "hyprland/language" = {
            "format" = "{}";
            "format-en" = "Lang: EN";
            "format-de" = "Lang: DE";
          };
          "hyprland/workspaces" = {
            "format" = "{icon}";
            "on-click" = "activate";
            "format-icons" = {
              "active" = " ";
            };
            "sort-by-number" = true;
            "persistent-workspaces" = {
              "*" = 4; # 5 workspaces by default on every monitor
              "HDMI-A-1" = 3; # but only three on HDMI-A-1
            };
          };
          "clock" = {
            "tooltip-format" = "<big>{=%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
            "format-alt" = "{:%Y-%m-%d}";
          };
          "cpu" = {
            "format" = "  {usage}%";
            "tooltip" = false;
          };
          "memory" = {
            "format" = "{}%  ";
          };
          "temperature" = {
            "critical-threshold" = 80;
            "format" = "{icon} {temperatureC}°C";
            "format-icons" = [
              ""
              ""
              ""
            ];
          };
          "battery" = {
            "states" = {
              "warning" = 30;
              "critical" = 15;
            };
            "format" = "{icon}  {capacity}%";
            "format-full" = "{icon}  {capacity}%";
            "format-charging" = "  {capacity}%";
            "format-plugged" = "  {capacity}%";
            "format-alt" = "{time} {icon}";
            "format-icons" = [
              ""
              ""
              ""
              ""
              ""
            ];
          };
          "network" = {
            "format-wifi" = "  {signalStrength}%";
            "format-ethernet" = "{cidr} ";
            "tooltip-format" = "{ifname} via {gwaddr} ";
            "format-linked" = "{ifname} (No IP) ";
            "format-disconnected" = " ⚠ ";
            "format-alt" = "{ifname}: {ipaddr}/{cidr}";
          };
          "pulseaudio" = {
            "format" = "{icon}  {volume}%";
            "format-bluetooth" = "{volume}% {icon} {format_source}";
            "format-bluetooth-muted" = " {icon} {format_source}";
            "format-muted" = " {format_source}";
            "format-icons" = {
              "headphone" = "";
              "hands-free" = "";
              "headset" = "";
              "phone" = "";
              "portable" = "";
              "car" = "";
              "default" = [
                ""
                ""
                ""
              ];
            };
            "on-click" = "pavucontrol";
          };
          "bluetooth" = {
            "format" = " {status}";
            "format-off" = "󰂲 off";
            "format-connected" = " con";
            "on-click" = "kitty -e bluetuith";
          };
        };
      };
    };
}
