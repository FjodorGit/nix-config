{ config, pkgs, lib, ... }:
let
  dotfilesDir = "${config.home.homeDirectory}/.dotfiles";
  neovimLanguageServers = with pkgs; [
    clang-tools
    basedpyright
    typescript-language-server
    tailwindcss-language-server
    vscode-langservers-extracted
    lua-language-server
    sqls
    yaml-language-server
    texlab
    cargo
    rust-analyzer
    tinymist
    ruff
    nixd
  ];
  neovimExtraPackages = with pkgs; [
    zig
    nodejs_22
    python3
    stylua
    nixfmt
    rustfmt
    jq
    prettierd
    go
    lsof
    tree-sitter
    gcc
  ];
in
{
  xdg.configFile."nvim/init.lua".enable = lib.mkForce false;

  home.file = {
    ".config/nvim" = {
      source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/nvim";
    };
    ".config/ksb-nvim" = {
      source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/ksb-nvim";
    };
    ".config/bacon/prefs.toml" = {
      source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/bacon/prefs.toml";
    };
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
}
