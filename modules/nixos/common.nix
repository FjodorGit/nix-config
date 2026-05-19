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

    extra-substituters = [
      "https://walker.cachix.org"
      "https://walker-git.cachix.org"
    ];
    extra-trusted-public-keys = [
      "walker.cachix.org-1:fG8q+uAaMqhsMxWjwvk0IMb4mFPFLqHjuvfwQxE4oJM="
      "walker-git.cachix.org-1:vmC0ocfPWh0S/vRAQGtChuiZBTAe4wiKDeyyXM0/7pM="
    ];

    download-buffer-size = 524288000;
  };

  nix.package = pkgs.nixVersions.latest;
  nixpkgs.config.allowUnfree = true;
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  documentation.dev.enable = true;
}
