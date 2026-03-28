{
  config,
  pkgs,
  ...
}:
{
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      "$terminal" = "kitty";
      "$browser" = "vivaldi-stable";
      "$mainMod" = "ALT";
      exec-once = [
        "systemctl --user start hyprpolkitagent"
        "hyprpaper"
        "[workspace 1] $terminal"
        "[workspace 2] $browser"
      ];
      env = [
        "HYPRCURSOR_THEME,XCursor-Pro-Dark-Hyprcursor"
        # NVIDIA Wayland support
        # "LIBVA_DRIVER_NAME,nvidia"
        # "GBM_BACKEND,nvidia-drm"
        "__GLX_VENDOR_LIBRARY_NAME,nvidia"
        "AQ_NO_MODIFIERS,1"
        "ELECTRON_OZONE_PLATFORM_HINT,auto"
      ];
      general = {
        gaps_out = 10;
        gaps_in = 5;
      };
      input = {
        kb_layout = "us,de";
        kb_options = "grp:alt_space_toggle";
      };
      monitor = [
        "desc:LG Electronics LG ULTRAWIDE 504NTCZA5667, 3440x1440, auto-center-up, 1"
        "desc:LG Electronics LG ULTRAWIDE 502NTVS1C199, 3440x1440@100.00Hz, auto-center-up, 1"
        "desc:LG Electronics LG ULTRAGEAR 106NTJJ27596, 2560x1440@59.95Hz,auto-center-up,1"
        "desc:LG Electronics LG ULTRAGEAR+ 411NTDV8F650, 3440x1440@100.00Hz, auto-center-up, 1"
        "desc:LG Electronics LG ULTRAWIDE 505NTMXDV643, 3440x1440@100.00Hz,auto-center-up,1"
        "desc:HP Inc. HP E243 CNK905038R,highres,auto-center-up,1"
        "desc:Hisense Electric Co. Ltd. HISENSE 0x00000001,3840x2160@60,auto-center-up,2"
        "DP-4,1920x1080,0x0,1"
        "DP-3,1920x1080,0x0,1"
        "eDP-1,preferred,auto-center-down,1"
        ",preferred,auto,1" # Catch-all for unrecognized displays (prevents safe mode on hotplug)
      ];
      windowrule = [
        "match:class $browser, workspace 2"
        "match:class $terminal, workspace 1"
        "match:title ^(.*)(\\.pdf)$, workspace 3"
        "match:class obsidian, workspace 4"
      ];
      workspace = [
        "2, monitor:eDP-1, default:true"
        "1, monitor:HDMI-A-1, default:true"
        "1, monitor:DP-1, default:true"
        "3, monitor:HDMI-A-1"
        "3, monitor:DP-1"
        "4, monitor:eDP-1"
      ];
      bind = [
        "$mainMod, T, exec, $terminal"
        "$mainMod, B, exec, $browser"
        "$mainMod, H, movefocus, l"
        "$mainMod, J, movefocus, d"
        "$mainMod, K, movefocus, u"
        "$mainMod, L, movefocus, r"
        "$mainMod, TAB, focuscurrentorlast, "
        "$mainMod, C, killactive, "
        "$mainMod, 1, workspace, 1"
        "$mainMod, 2, workspace, 2"
        "$mainMod, 3, workspace, 3"
        "$mainMod, 4, workspace, 4"
        "$mainMod, F, fullscreen, 1"
        "$mainMod, R, exec, rofi -show run"
        "$mainMod, O, exec, rofi -show drun"
      ];
      binde = [
        ",code:122 , exec, pamixer -d 5"
        ",code:123 , exec, pamixer -i 5"
        ",code:232 , exec, brightnessctl -d intel_backlight set 10%- && ddcutil setvcp 10 - 10"
        ",code:233 , exec, brightnessctl -d intel_backlight set +10% && ddcutil setvcp 10 + 10"
      ];
      animation = [
        "workspaces, 0"
        "global, 0"
      ];
      decoration = {
        rounding = 5;
      };
    };

    extraConfig = ''
      bind = $mainMod ,W ,exec, pkill -SIGUSR1 waybar
      bind = $mainMod ,W ,submap, waybar
      submap = waybar
      bind = ,B , exec, kitty -e bluetuith
      bind = ,B , exec, pkill -SIGUSR1 waybar
      bind = ,B , submap, reset
      bind = ,N , exec, kitty -e sudo nmtui
      bind = ,N , exec, pkill -SIGUSR1 waybar
      bind = ,N , submap, reset
      bind = ,C , exec, rofi -show calc -modi calc -no-show-match -no-sort
      bind = ,C , exec, pkill -SIGUSR1 waybar
      bind = ,C , submap, reset
      bind = $mainMod ,W ,exec, pkill -SIGUSR1 waybar
      bind = $mainMod ,W ,submap, reset
      submap = reset
      bind = $mainMod ,M ,submap, movewindow
      submap = movewindow
      bind = ,1, movetoworkspace, 1
      bind = ,2, movetoworkspace, 2
      bind = ,3, movetoworkspace, 3
      bind = ,4, movetoworkspace, 4
      bind = $mainMod, D, movecurrentworkspacetomonitor, d
      bind = $mainMod, U, movecurrentworkspacetomonitor, u 
      bind = $mainMod ,M ,submap, reset
      submap = reset
    '';
  };

  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        hide_cursor = true;
        ignore_empty_input = true;
      };

      background = [
        {
          path = "~/.dotfiles/theme/lockscreen-paper.png";
          blur_passes = 0;
        }
      ];

      input-field = [
        {
          size = "200, 50";
          position = "0, -150";
          halign = "center";
          valign = "center";
          monitor = "";
          dots_center = true;
          fade_on_empty = false;
          font_color = "rgb(205, 214, 244)";
          inner_color = "rgb(20, 20, 20)";
          outer_color = "rgb(205, 214, 244)";
          outline_thickness = 2;
          placeholder_text = "<i><span foreground=\"##cdd6f4\">Password</span></i>";
          shadow_passes = 2;
        }
      ];
    };
  };

  services.hyprpaper = {
    enable = true;
    settings = {
      wallpaper = [
        {
          monitor = ""; # empty = fallback for all monitors
          path = "~/.dotfiles/theme/wallpaper.png";
          fit_mode = "cover";
        }
      ];
    };
  };

  services.hypridle = {
    enable = true;
    settings = {
      general = {
        after_sleep_cmd = "hyprctl dispatch dpms on && sleep 1 && (pidof hyprlock || hyprlock)";
        ignore_dbus_inhibit = false;
        before_sleep_cmd = "loginctl lock-session";
        lock_cmd = "pidof hyprlock || hyprlock --grace 2";
      };

      listener = [
        {
          timeout = 300;
          on-timeout = "pidof hyprlock || hyprlock"; # command to run when timeout has passed.
        }
        {
          timeout = 1000;
          on-timeout = "systemctl suspend";
        }
      ];
    };
  };
}
