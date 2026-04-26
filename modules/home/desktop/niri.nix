{
  config,
  pkgs,
  self,
  ...
}:
let
  dotfilesDir = "${config.home.homeDirectory}/.dotfiles";
  cursorSize = 24;
  setCurrentWorkspace = pkgs.writeShellScript "set-current-workspace" ''
    niri msg action unset-workspace-name current
    niri msg action set-workspace-name current
  '';
in
{

  home.packages = with pkgs; [
    swaybg
    swayidle
    xwayland-satellite
  ];

  home.pointerCursor = {
    name = "Bibata-Modern-Ice";
    package = pkgs.linkFarm "bibata-modern-ice" {
      "share/icons/Bibata-Modern-Ice" = "${self}/theme/Bibata-Modern-Ice";
    };
    size = cursorSize;
    gtk.enable = true;
  };

  programs.swaylock = {
    enable = true;
    settings = {
      image = "${dotfilesDir}/theme/lockscreen-paper.png";
      show-failed-attempts = true;
      ignore-empty-password = true;
      font-size = 24;
      indicator-radius = 100;
      ring-color = "cdd6f4";
      key-hl-color = "89b4fa";
      inside-color = "141414";
      line-color = "00000000";
      separator-color = "00000000";
      text-color = "cdd6f4";
    };
  };

  programs.niri.settings = {
    spawn-at-startup = [
      {
        argv = [
          "swaybg"
          "-i"
          "${dotfilesDir}/theme/wallpaper.png"
          "-m"
          "fill"
        ];
      }
      {
        argv = [
          "swayidle"
          "-w"
          "timeout"
          "600"
          "swaylock -f"
          "timeout"
          "3000"
          "systemctl suspend"
          "before-sleep"
          "swaylock -f"
        ];
      }
      { argv = [ "kitty" ]; }
      { argv = [ "helium" ]; }
    ];

    environment = {
      "__GLX_VENDOR_LIBRARY_NAME" = "nvidia";
      "ELECTRON_OZONE_PLATFORM_HINT" = "auto";
    };

    cursor = {
      theme = "Bibata-Modern-Ice";
      size = cursorSize;
    };

    input = {
      keyboard.xkb = {
        layout = "us,de";
        options = "grp:alt_space_toggle";
      };
    };

    outputs = {
      "LG Electronics LG ULTRAWIDE 504NTCZA5667" = {
        mode = {
          width = 3440;
          height = 1440;
        };
      };
      "LG Electronics LG ULTRAWIDE 502NTVS1C199" = {
        mode = {
          width = 3440;
          height = 1440;
          refresh = 100.0;
        };
        position = {
          x = 0;
          y = 0;
        };
      };
      "LG Electronics LG ULTRAGEAR 106NTJJ27596" = {
        mode = {
          width = 2560;
          height = 1440;
          refresh = 59.951;
        };
      };
      "LG Electronics LG ULTRAGEAR+ 411NTDV8F650" = {
        mode = {
          width = 3440;
          height = 1440;
          refresh = 100.0;
        };
      };
      "LG Electronics LG ULTRAWIDE 505NTMXDV643" = {
        mode = {
          width = 3440;
          height = 1440;
          refresh = 100.0;
        };
      };
      "Samsung Display Corp. ATNA60HS01-0  Unknown" = {
        scale = 1.0;
        position = {
          x = 0;
          y = 1440;
        };
      };
      "HP Inc. HP E243 CNK905038R" = { };
      "Hisense Electric Co. Ltd. HISENSE 0x00000001" = {
        mode = {
          width = 3840;
          height = 2160;
          refresh = 60.0;
        };
        scale = 2.0;
      };
    };

    layout = {
      gaps = 10;
      border = {
        enable = true;
        width = 2;
        active.color = "#89b4fa";
        inactive.color = "#45475a";
      };
      focus-ring.enable = false;
    };

    animations.enable = false;

    prefer-no-csd = true;

    binds = {
      # App launchers
      "Alt+T".action.spawn = "kitty";
      "Alt+B".action.spawn = "helium";
      "Alt+R".action.spawn = [
        "rofi"
        "-show"
        "run"
      ];
      "Alt+O".action.spawn = [
        "rofi"
        "-show"
        "drun"
      ];

      # Window management
      "Alt+C".action.close-window = [ ];
      "Alt+F".action.maximize-column = [ ];

      # Focus
      "Alt+H".action.focus-column-left-or-last = [ ];
      "Alt+J".action.focus-window-or-monitor-down = [ ];
      "Alt+K".action.focus-window-or-monitor-up = [ ];
      "Alt+L".action.focus-column-right-or-first = [ ];
      "Alt+I".action.center-visible-columns = [ ];

      # Named workspaces
      "Alt+1".action.focus-workspace = "current";
      "Alt+2".action.focus-workspace = "browser";
      "Alt+3".action.focus-workspace = "pdf";
      "Alt+4".action.focus-workspace = "messaging";
      "Alt+M".action.spawn = [ "${setCurrentWorkspace}" ];

      # Workspaces
      "Alt+D".action.focus-workspace-down = [ ];
      "Alt+U".action.focus-workspace-up = [ ];
      "Alt+Ctrl+D".action.move-workspace-down = [ ];
      "Alt+Ctrl+U".action.move-workspace-up = [ ];
      "Alt+Ctrl+K".action.move-window-up-or-to-workspace-up = [ ];
      "Alt+Ctrl+J".action.move-window-down-or-to-workspace-down = [ ];

      # Move workspaces
      "Alt+Ctrl+N".action.move-workspace-to-monitor-next = [ ];
      "Alt+Shift+F".action.switch-focus-between-floating-and-tiling = [ ];
      "Alt+Ctrl+F".action.toggle-window-floating = [ ];

      # Move columns
      "Alt+BracketLeft".action.move-column-left = [ ];
      "Alt+BracketRight".action.move-column-right = [ ];

      # Resize
      "Alt+Ctrl+H".action.set-column-width = "-5%";
      "Alt+Ctrl+L".action.set-column-width = "+5%";

      # Volume
      "XF86AudioRaiseVolume".action.spawn = [
        "pamixer"
        "-i"
        "5"
      ];
      "XF86AudioLowerVolume".action.spawn = [
        "pamixer"
        "-d"
        "5"
      ];

      # Brightness
      "XF86MonBrightnessUp".action.spawn = [
        "brightnessctl"
        "-d"
        "intel_backlight"
        "set"
        "+10%"
      ];
      "XF86MonBrightnessDown".action.spawn = [
        "brightnessctl"
        "-d"
        "intel_backlight"
        "set"
        "10%-"
      ];

      # Utilities
      "Alt+Shift+B".action.spawn = [
        "kitty"
        "-e"
        "bluetuith"
      ];
      "Alt+Shift+N".action.spawn = [
        "kitty"
        "-e"
        "sudo"
        "nmtui"
      ];
      "Alt+Shift+C".action.spawn = [
        "rofi"
        "-show"
        "calc"
        "-modi"
        "calc"
        "-no-show-match"
        "-no-sort"
      ];

      # Screenshot
      "Print".action.screenshot = [ ];
      "Alt+Print".action.screenshot-window = [ ];

      # Session
      "Alt+Shift+E".action.quit = {
        skip-confirmation = true;
      };
    };

    workspaces = {
      "1-browser" = {
        name = "browser";
        open-on-output = "eDP-1";
      };
      "2-pdf" = {
        name = "pdf";
        open-on-output = "DP-1";
      };
      "3-messaging" = {
        name = "messaging";
        open-on-output = "eDP-1";
      };
      "4-current" = {
        name = "current";
        open-on-output = "DP-1";
      };
    };

  };
}
