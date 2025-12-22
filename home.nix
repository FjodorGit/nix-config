{
  config,
  pkgs,
  inputs,
  username,
  hostname,
  gitUsername,
  gitEmail,
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
    rust-analyzer
    tinymist
    ruff
  ];
  neovimExtraPackages = with pkgs; [
    zig
    nodejs_22
    python3
    stylua
    nixfmt-rfc-style
    # Formatters
    rustfmt
    jq
    prettierd
    go
    lsof
  ];
  opencode-latest = pkgs.opencode.overrideAttrs (finalAttrs: {
    version = "1.0.68"; # Whatever newer version is out

    src = pkgs.fetchFromGitHub {
      owner = "sst";
      repo = "opencode";
      tag = "v${finalAttrs.version}";
      hash = "sha256-dzhthgkAPjvPOxWBnf67OkTwbZ3Htdl68+UDlz45xwI=";
    };
  });
  # texSetup = (
  #   pkgs.texliveFull.withPackages (
  #     ps: with ps; [
  #       latexmk
  #       moresize
  #       enumitem
  #       raleway
  #       fontawesome
  #       lipsum
  #       adjustbox
  #       collection-fontsextra
  #       latexindent
  #       xcharter
  #       xstring
  #       # tum
  #       pgfopts
  #       silence
  #       lastpage
  #       tex-gyre
  #       tex-gyre-math
  #       esint
  #       tcolorbox
  #       tikzfill
  #       pdfcol
  #       lualatex-math
  #     ]
  #   )
  # );
in
{
  imports = [ ];
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = username;
  home.homeDirectory = "/home/${username}";

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
    # texSetup
    zoom-us
    teams-for-linux

    # sound control
    pavucontrol
    pamixer

    # browsers
    tor-browser
    inputs.zen-browser.packages.x86_64-linux.default
    chromium
    google-chrome
    firefox
    vivaldi
    mitmproxy
    eduvpn-client

    beeper
    croc

    # brightness control
    ddcutil
    brightnessctl
    wakeonlan
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
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/nvim";
      recursive = true;
    };
    ".config/zsh/custom.zsh".source = ./zsh/.zshrc;
    ".local/state/syncthing" = {
      source = ./syncthing;
      recursive = true;
    };
    ".ssh/id_ed25519".source = ./ssh/id_ed25519;
    ".ssh/id_ed25519.pub".source = ./ssh/id_ed25519.pub;
    ".config/bluetuith/bluetuith.conf".source = ./bluetuith/bluetuith.conf;
    ".config/bacon/prefs.toml".source = ./bacon/prefs.toml;
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
    userName = gitUsername;
    userEmail = gitEmail;
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

  programs.zsh = {
    enable = true;
    dotDir = config.xdg.configHome + "/zsh";
    enableCompletion = true;
    setOptions = [
      "INC_APPEND_HISTORY"
      "HIST_IGNORE_DUPS"
      "SHARE_HISTORY"
      "HIST_FCNTL_LOCK"
    ];
    history = {
      size = 500000;
      save = 500000;
      path = "${config.xdg.stateHome}/zsh/history";
    };

    sessionVariables = {
      XDG_DATA_HOME = "$HOME/.local/share";
      XDG_CONFIG_HOME = "$HOME/.config";
      XDG_STATE_HOME = "$HOME/.local/state";
      XDG_CACHE_HOME = "$HOME/.cache";

      ZVM_KEYTIMEOUT = 0.1;

      MANPAGER = "nvim +Man!";
      SUDO_EDITOR = "nvim";
      VISUAL = "nvim";
      EDITOR = "nvim";

      HISTORY_IGNORE = "(f)";

      ZVM_INIT_MODE = "sourcing";
    };

    shellAliases = {
      refresh = "home-manager switch --flake ~/.dotfiles";
      rebuild = "sudo nixos-rebuild switch --flake ~/.dotfiles";
      zshconfig = "nvim ~/.dotfiles/zsh/.zshrc";
      kittyconfig = "nvim ~/.dotfiles/kitty/kitty.conf";
      homeconfig = "cd ~/.dotfiles && nvim ~/.dotfiles/home.nix && -";
      cat = "bat";
      ohmyzsh = "nvim ~/.oh-my-zsh";
      qn = "cd ~/Documents/notes && nvim Dump.md && -";
      notes = "cd ~/Documents/notes && nvim Dump.md";
      nvimconfig = "cd ~/.dotfiles/nvim && nvim init.lua";
      ls = "eza -1 -l --icons -a";
      sups = "wakeonlan -p 51821 -i 77.24.121.5 3C:EC:EF:90:A4:42";
      tordownloads = "cd ${config.home.homeDirectory}/.local/share/torbrowser/tbb/x86_64/tor-browser_en-US/Browser/Downloads/";
      f = "yy";
    };

    initContent = ''
      # Source your custom file
      [[ -f ~/.config/zsh/custom.zsh ]] && source ~/.config/zsh/custom.zsh
    '';
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "direnv"
      ];
      theme = "robbyrussell";
    };
    plugins = [
      {
        name = "vi-mode";
        src = pkgs.zsh-vi-mode;
        file = "share/zsh-vi-mode/zsh-vi-mode.plugin.zsh";
      }
    ];
  };

  programs.kitty = {
    enable = true;
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true; # see note on other shells below
    nix-direnv.enable = true;
  };

  programs.zoxide = {
    enableZshIntegration = true;
    enable = true;
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.eza.enable = true;
  programs.fd.enable = true;

  programs.sioyek = {
    enable = true;
    config = {
      "should_launch_new_window" = "1";
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
      mgr = {
        show_hidden = false;
        sort_by = "natural";
        sort_dir_first = true;
      };
    };
    keymap = { };
  };

  programs.pandoc = {
    enable = true;
  };

  programs.gh = {
    enable = true;
  };

  programs.opencode = {
    enable = true;
    package = opencode-latest;
  };

  programs.element-desktop = {
    enable = true;
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
    matchBlocks."*".addKeysToAgent = "yes";
  };

  services.gpg-agent = {
    enable = true;
    enableZshIntegration = true;
    enableSshSupport = true;
    pinentry.package = pkgs.pinentry-gtk2;
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
}
