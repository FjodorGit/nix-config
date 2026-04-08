{ pkgs, inputs, ... }:
{
  home.packages = with pkgs; [
    unzip
    git-crypt
    tlrc
    devenv
    rclone
    croc
    wakeonlan

    inputs.agenix.packages.${pkgs.stdenv.hostPlatform.system}.default
    inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.pi
    inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.claude-code
  ];

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.eza.enable = true;
  programs.fd.enable = true;
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

  programs.pandoc.enable = true;
  programs.gh.enable = true;
  programs.gpg.enable = true;

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks."*".addKeysToAgent = "yes";
  };

  services.gpg-agent = {
    enable = true;
    enableZshIntegration = true;
    enableSshSupport = true;
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
}
