{ pkgs, ... }:
{
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    trusted-users = [
      "root"
      "fjk"
    ];
    download-buffer-size = 524288000;
  };

  nix.package = pkgs.nixVersions.latest;
  nixpkgs.config.allowUnfree = true;
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  documentation.dev.enable = true;
}
