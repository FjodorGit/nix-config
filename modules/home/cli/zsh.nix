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
  };
}
