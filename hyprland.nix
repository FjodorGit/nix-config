{
  config,
  pkgs,
  inputs,
  ...
}:
{
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      "$terminal" = "kitty";
      "$browser" = "floorp";
      "$mainMod" = "ALT";
      exec-once = [
        "$terminal"
        "$browser"
      ];
      env = [
        "HYPRCURSOR_THEME, XCursor-Pro-Dark-Hyprcursor"
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
        "HDMI-A-1,1920x1080,0x0,1"
        "DP-4,1920x1080,0x0,1"
        "DP-1,1920x1080,0x0,1"
        "eDP-1,1920x1080,0x1080,1"
      ];
      windowrulev2 = [
        "monitor 0, class:$terminal"
        "monitor 1, class:$browser"
        "monitor 1, title:^(.*)(\.pdf)$"
        "workspace 1, class:$terminal"
        "workspace 2, class:$browser"
        "workspace 3, title:^(.*)(\.pdf)$"
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
      ];
      binde = [
        ",code:122 , exec, pamixer -d 5"
        ",code:123 , exec, pamixer -i 5"
        ",code:232 , exec, ddcutil setvcp 10 - 10 && brightnessctl set 10%-"
        ",code:233 , exec, ddcutil setvcp 10 + 10 && brightnessctl set +10%"
      ];
      animation = [
        "workspaces, 0"
        "global, 0"
      ];
    };

    extraConfig = ''
      bind = $mainMod ,W ,exec, waybar
      bind = $mainMod ,W ,submap, waybar
      submap = waybar
      bind = ,B , exec, kitty -e bluetuith
      bind = ,B , exec, pkill waybar
      bind = ,B , submap, reset
      bind = ,N , exec, kitty -e sudo nmtui
      bind = ,N , exec, pkill waybar
      bind = ,N , submap, reset
      bind = $mainMod ,W ,exec, pkill waybar
      bind = $mainMod ,W ,submap, reset
      submap = reset
    '';
  };

  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        disable_loading_bar = true;
        grace = 2;
        hide_cursor = true;
        no_fade_in = false;
        ignore_emptry_input = true;
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
      preload = [ "~/.dotfiles/theme/wallpaper.png" ];
      wallpaper = [ ",~/.dotfiles/theme/wallpaper.png" ];
    };
  };

  services.hypridle = {
    enable = true;
    settings = {
      general = {
        after_sleep_cmd = "hyprctl dispatch dpms on";
        ignore_dbus_inhibit = false;
        before_sleep_cmd = "loginctl lock-session";
        lock_cmd = "pidof hyprlock || hyprlock";
      };

      listener = [
        {
          timeout = 300;
          on-timeout = "pidof hyprlock || hyprlock"; # command to run when timeout has passed.
        }
        {
          timeout = 1000;
          on-timeout = "systemctl hybrid-sleep";
        }
      ];
    };
  };
}
