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
      # bindl = ["switch:on:Lid Switch, "];
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
          path = "~/.dotfiles/theme/lehman-brothers.png";
          blur_passes = 1;
          blur_size = 8;
        }
      ];

      input-field = [
        {
          size = "200, 50";
          position = "0, 100";
          monitor = "";
          dots_center = true;
          fade_on_empty = false;
          font_color = "rgb(202, 211, 245)";
          inner_color = "rgb(91, 96, 120)";
          outer_color = "rgb(24, 25, 38)";
          outline_thickness = 5;
          placeholder_text = "\"<span foreground=\"##cad3f5\">Password...</span>\"";
          shadow_passes = 2;
        }
      ];
    };
  };
}
