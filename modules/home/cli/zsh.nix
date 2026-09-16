{ config, ... }:
let
  dotfilesDir = "${config.home.homeDirectory}/.dotfiles";
in
{
  home.file.".config/zsh/custom.zsh" = {
    source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/zsh/.zshrc";
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

      MANPAGER = "nvim +Man!";
      SUDO_EDITOR = "nvim";
      VISUAL = "nvim";
      EDITOR = "nvim";

      HISTORY_IGNORE = "(f)";
    };

    shellAliases = {
      rebuild = "sudo nixos-rebuild switch --flake ~/.dotfiles";
      zshconfig = "nvim ~/.dotfiles/zsh/.zshrc";
      homeconfig = "cd ~/.dotfiles && nvim ~/.dotfiles/modules/home && -";
      ohmyzsh = "nvim ~/.oh-my-zsh";
      cat = "bat";
      qn = "cd ~/Documents/notes && nvim Dump.md && -";
      notes = "cd ~/Documents/notes && nvim Dump.md";
      nvimconfig = "cd ~/.dotfiles/nvim && nvim init.lua";
      ssh = "kitten ssh";
      ls = "eza -1 -l --icons -a";
      logoff = ''loginctl terminate-user "$USER"'';
    };

    initContent = ''
      # Source your custom file
      [[ -f ~/.config/zsh/custom.zsh ]] && source ~/.config/zsh/custom.zsh

      # Edit the command line in nvim: q cancels, <CR> accepts and runs.
      # nvim signals "accept" by creating $TERM_NVIM_ACCEPT.
      autoload -Uz edit-command-line
      zle -N edit-command-line

      edit-command-line-run() {
        local marker="''${XDG_RUNTIME_DIR:-/tmp}/zsh-edit-command-line.$$"
        command rm -f "$marker"
        local -x NVIM_APPNAME=term-nvim TERM_NVIM_MODE=cmdline TERM_NVIM_ACCEPT="$marker"
        zle edit-command-line
        if [[ -e "$marker" ]]; then
          command rm -f "$marker"
          zle accept-line
        fi
      }
      zle -N edit-command-line-run
      bindkey '^X^E' edit-command-line-run
    '';
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "direnv"
      ];
      theme = "robbyrussell";
    };
  };
}
