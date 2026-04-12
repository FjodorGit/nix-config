{
  config,
  pkgs,
  inputs,
  self,
  ...
}:
let
  dotfilesDir = "${config.home.homeDirectory}/.dotfiles";
in
{
  home.packages = with pkgs; [
    kitty
    qt6.qtwayland
    xdg-desktop-portal-gtk
    wl-clipboard

    # communication
    telegram-desktop
    wasistlos
    slack
    dissent
    zoom-us
    teams-for-linux

    # productivity
    obsidian
    bluetuith
    pdfpc

    # sound control
    pavucontrol
    pamixer

    # browsers
    tor-browser
    inputs.firefoxNightly.packages.${pkgs.stdenv.hostPlatform.system}.firefox-nightly-bin
    inputs.chromeBeta.packages.${pkgs.stdenv.hostPlatform.system}.google-chrome-beta
    google-chrome
    vivaldi
    inputs.helium.packages.${pkgs.stdenv.hostPlatform.system}.helium
    eduvpn-client

    # utilities
    sage
    nvitop

    # brightness control
    ddcutil
    brightnessctl
  ];

  home.file = {
    ".config/kitty" = {
      source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/kitty";
    };
    ".config/bluetuith/bluetuith.conf" = {
      source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/bluetuith/bluetuith.conf";
    };
    ".config/rofi" = {
      source = "${self}/theme/rofi";
      recursive = true;
    };
  };

  home.shellAliases = {
    kittyconfig = "nvim ~/.dotfiles/kitty/kitty.conf";
    hyprconfig = "nvim ~/.dotfiles/modules/home/desktop/hyprland.nix";
    niriconfig = "nvim ~/.dotfiles/modules/home/desktop/niri.nix";
    sups = "wakeonlan -p 51821 -i 77.24.121.5 3C:EC:EF:90:A4:42";
    tordownloads = "cd /home/fjk/.local/share/torbrowser/tbb/x86_64/tor-browser_en-US/Browser/Downloads/";
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "application/pdf" = [ "sioyek.desktop" ];
      "inode/directory" = [ "yazi.desktop" ];
      "text/markdown" = [ "nvim" ];
      "application/xhtml+xml" = [ "helium.desktop" ];
      "text/html" = [ "helium.desktop" ];
      "text/xml" = [ "helium.desktop" ];
      "x-scheme-handler/ftp" = [ "helium.desktop" ];
      "x-scheme-handler/http" = [ "helium.desktop" ];
      "x-scheme-handler/https" = [ "helium.desktop" ];
      "x-scheme-handler/tg" = [ "org.telegram.desktop.desktop" ];
      "x-scheme-handler/tonsite" = [ "org.telegram.desktop.desktop" ];
    };
    associations.removed = {
      "inode/directory" = [
        "kitty-open.desktop"
      ];
    };
  };

  programs.rofi = {
    enable = true;
    terminal = "kitty";
    theme = "style.rasi";
    extraConfig = {
      run-shell-command = "kitty --hold {cmd}";
    };
    plugins = [
      pkgs.rofi-calc
    ];
  };

  programs.mpv = {
    enable = true;
    config = {
      keep-open = true;
      profile = "gpu-hq";
    };
    bindings = {
      "r" = "seek 0 absolute";
    };
    scripts = with pkgs.mpvScripts; [
      reload
    ];
  };

  programs.sioyek = {
    enable = true;
    config = {
      "should_launch_new_window" = "1";
      "default_dark_mode" = "1";
    };
    bindings = {
      "goto_bookmark" = "B";
      "next_state" = "<c-i>";
      "prev_state" = "<c-o>";
      "goto_mark" = "'";
      "goto_toc" = "e";
      "next_chapter" = "<c-d>";
      "prev_chapter" = "<c-u>";
      "goto_definition" = "gd";
    };
  };

  programs.element-desktop.enable = true;
}
