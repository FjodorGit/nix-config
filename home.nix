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
    xsel
    stylua
    nixfmt-rfc-style
  ];
in
{
  imports = [
    inputs.xremap-flake.homeManagerModules.default
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
    fastfetch
    unzip
    xdg-ninja
    git-crypt

    floorp
    telegram-desktop
  ];

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
    ".ssh" = {
      source = ./ssh;
      recursive = true;
    };
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
    extraConfig.pull.rebase = true;
  };

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    defaultEditor = true;
    withNodeJs = true;
    withPython3 = true;
    extraPackages = neovimExtraPackages ++ neovimLanguageServers;
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

  programs = {
    direnv = {
      enable = true;
      enableZshIntegration = true; # see note on other shells below
      nix-direnv.enable = true;
    };
  };

  programs.zoxide.enable = true;
  programs.starship.enable = true;
  programs.eza.enable = true;
  programs.yazi.enable = true;
  programs.bat.enable = true;
  programs.ripgrep.enable = true;
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };
  programs.gpg.enable = true;
  programs.ssh.enable = true;
  programs.ssh.addKeysToAgent = "yes";

  services.gpg-agent = {
    enable = true;
    enableZshIntegration = true;
    enableSshSupport = true;
    pinentryPackage = pkgs.pinentry-gtk2;
  };
  services.syncthing.enable = true;

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
    withGnome = true;
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
