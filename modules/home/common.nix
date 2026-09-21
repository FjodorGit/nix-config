{ config, ... }:
{
  # Trees symlinked out of the store, so edits apply without a rebuild.
  _module.args.dotfilesDir = "${config.home.homeDirectory}/.dotfiles";
}
