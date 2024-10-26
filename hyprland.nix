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
      monitor = [
        "HDMI-A-1,1920x1080,0x0,1"
        "eDP-1,1920x1080,0x1080,1"
      ];
      windowrulev2 = [
        "monitor 0, class:$terminal"
        "monitor 1, class:$browser"
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
      ];
    };
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
          timeout = 600;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
        {
          timeout = 1000;
          on-timeout = "systemctl hybrid-sleep";
        }
      ];
    };
  };
}
