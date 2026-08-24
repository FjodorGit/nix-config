{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs =
    { self, nixpkgs }:
    let
      system = "x86_64-linux";
      mkVM =
        de:
        nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./base.nix
            de
          ];
        };
    in
    {
      nixosConfigurations = {
        gnome = mkVM ./gnome.nix;
        kde = mkVM ./kde.nix;
        xfce = mkVM ./xfce.nix;
      };
    };
}
