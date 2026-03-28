{ config, ... }:
let
  dotfilesDir = "${config.home.homeDirectory}/.dotfiles";
in
{
  programs.home-manager.enable = true;
  home.sessionPath = [ "$HOME/.local/bin" ];

  home.file.".local/bin/newproj" = {
    source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/templates/new-project.sh";
  };
}
