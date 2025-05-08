{
  config,
  pkgs,
  inputs,
  ...
}:

let
  neovimLanguageServers = with pkgs; [
    clang-tools
    basedpyright
    typescript-language-server
    tailwindcss-language-server
    vscode-langservers-extracted
    lua-language-server
    sqls
    yaml-language-server
    zls
    texlab
  ];
  neovimExtraPackages = with pkgs; [
    zig
    nodejs_22
    python3
    stylua
    nixfmt-rfc-style
    jq
  ];
  texSetup = (
    pkgs.texliveSmall.withPackages (
      ps: with ps; [
        latexmk
        moresize
        enumitem
        raleway
        fontawesome
        lipsum
        adjustbox
        collection-fontsextra
        latexindent
      ]
    )
  );
in
{
  imports = [
    inputs.xremap-flake.homeManagerModules.default
    ./hyprland.nix
    ./waybar.nix
  ];
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "fjk";
  home.homeDirectory = "/home/fjk";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')

    # adding this package to have a home-manager executable in the shell and
    # garbage-collection collects old home-manager generations

    #
    qt6.qtwayland

    # clis
    unzip
    xdg-ninja
    git-crypt
    tlrc
    devenv
    wl-clipboard
    rclone

    # programms
    telegram-desktop
    whatsapp-for-linux
    obsidian
    bluetuith
    texSetup
    zoom-us
    teams-for-linux

    # sound control
    pavucontrol
    pamixer

    # browsers
    tor-browser
    floorp
    inputs.zen-browser.packages.x86_64-linux.default
    chromium
    google-chrome
    firefox
    vivaldi
    mitmproxy
    eduvpn-client

    # brightness control
    ddcutil
    brightnessctl
  ];

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "application/pdf" = [ "sioyek.desktop" ];
      "inode/directory" = [ "yazi.desktop" ];
      "text/markdown" = [ "nvim" ];
      "application/xhtml+xml" = [ "vivaldi-stable.desktop" ];
      "text/html" = [ "vivaldi-stable.desktop" ];
      "text/xml" = [ "vivaldi-stable.desktop" ];
      "x-scheme-handler/ftp" = [ "vivaldi-stable.desktop" ];
      "x-scheme-handler/http" = [ "vivaldi-stable.desktop" ];
      "x-scheme-handler/https" = [ "vivaldi-stable.desktop" ];
      "x-scheme-handler/tg" = [ "org.telegram.desktop.desktop" ];
      "x-scheme-handler/tonsite" = [ "org.telegram.desktop.desktop" ];
    };
    associations.removed = {
      "inode/directory" = [
        "kitty-open.desktop"
        "org.gnome.baobab.desktop"
      ];
    };
  };

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    ".config/kitty" = {
      source = ./kitty;
      recursive = true;
    };
    ".config/nvim" = {
      source = ./nvim;
      recursive = true;
    };
    ".config/zsh/.zshrc".source = ./zsh/.zshrc;
    ".local/state/syncthing" = {
      source = ./syncthing;
      recursive = true;
    };
    ".ssh/id_ed25519".source = ./ssh/id_ed25519;
    ".ssh/id_ed25519.pub".source = ./ssh/id_ed25519.pub;
    ".local/share/icons/XCursor-Pro-Dark-Hyprcursor" = {
      source = ./theme/XCursor-Pro-Dark-Hyprcursor;
      recursive = true;
    };
    ".config/waybar/style.css".source = ./theme/waybar_style.css;
    ".config/bluetuith/bluetuith.conf".source = ./bluetuith/bluetuith.conf;
    ".config/rofi" = {
      source = ./theme/rofi;
      recursive = true;
    };

    ".config/mutt/muttrc".source = ./mutt/muttrc;

    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/fjk/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {

  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.git = {
    enable = true;
    userName = "FjodorGit";
    userEmail = "f.kholodkov@gmail.com";
    extraConfig.init.defaultBranch = "main";
    extraConfig.core.editor = "nvim";
    extraConfig.pull.rebase = false;
    extraConfig.pull.merge = true;
  };

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    defaultEditor = true;
    withNodeJs = true;
    withPython3 = true;
    extraPackages = neovimExtraPackages ++ neovimLanguageServers;
    extraPython3Packages =
      ps: with ps; [
        pynvim
        jupyter-client
        pyperclip
      ];
  };

  # most of the options are set in the .zshrc file.
  # for history to work make sure that all folders of the path of the history file exist
  programs.zsh = {
    enable = true;
    dotDir = ".config/zsh";
    # sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc
    # to install the oh-my-zsh script
    oh-my-zsh = {
      enable = true;
    };
  };

  programs.kitty = {
    enable = true;
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true; # see note on other shells below
    nix-direnv.enable = true;
  };

  programs.zoxide.enable = true;
  programs.starship.enable = true;
  programs.eza.enable = true;
  programs.fd.enable = true;
  programs.sioyek = {
    enable = true;
    config = {
      "should_launch_new_window" = "1";
    };
  };
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      opener.edit = [
        {
          run = "nvim \"$@\"";
          block = true;
          for = "unix";
        }
      ];
      manager = {
        show_hidden = false;
        sort_by = "alphabetical";
        sort_dir_first = true;
      };
    };
    keymap = { };
  };

  programs.pandoc = {
    enable = true;
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

  programs.bat.enable = true;
  programs.btop = {
    enable = true;
    settings.vim_keys = true;
  };
  programs.ripgrep.enable = true;
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };
  programs.gpg.enable = true;
  programs.ssh = {
    enable = true;
  };
  programs.ssh.addKeysToAgent = "yes";

  services.gpg-agent = {
    enable = true;
    enableZshIntegration = true;
    enableSshSupport = true;
    pinentryPackage = pkgs.pinentry-gtk2;
  };
  services.syncthing.enable = true;
  services.kdeconnect.enable = true;
  services.kdeconnect.indicator = true;

  systemd.user.services.ssh-agent = {
    Unit = {
      Description = "SSH Agent";
    };
    Service = {
      Type = "forking";
      ExecStartPre = "${pkgs.coreutils}/bin/rm -f /tmp/ssh-agent";
      ExecStart = "${pkgs.openssh}/bin/ssh-agent -a /tmp/ssh-agent";
    };
  };

  services.xremap = {
    withWlroots = true;
    config.modmap = [
      {
        name = "Global";
        remap = {
          "CapsLock" = "Ctrl_L";
          "Ctrl_L" = "CapsLock";
        };
      }
    ];
  };
}
