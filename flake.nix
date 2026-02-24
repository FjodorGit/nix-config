{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    hyprland.url = "github:hyprwm/Hyprland";
    catppuccin.url = "github:catppuccin/nix";
    homeManager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    opencode.url = "github:anomalyco/opencode/dev";
    xremap.url = "github:xremap/nix-flake";

    chromeBeta = {
      url = "github:nix-community/browser-previews";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    firefoxNightly = {
      url = "github:nix-community/flake-firefox-nightly";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      hyprland,
      catppuccin,
      homeManager,
      opencode,
      xremap,
      firefoxNightly,
      chromeBeta,
      ...
    }:
    let
      system = "x86_64-linux";
      inputs = {
        inherit
          self
          nixpkgs
          hyprland
          catppuccin
          homeManager
          opencode
          xremap
          firefoxNightly
          chromeBeta
          ;
      };
      homeModules = [
        ./home.nix
        catppuccin.homeModules.catppuccin
      ];
    in
    {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs; };
        modules = [
          ./configuration.nix
          homeManager.nixosModules.default
          catppuccin.nixosModules.catppuccin
          {
            home-manager = {
              extraSpecialArgs = { inherit inputs; };
              users."fjk".imports = homeModules;
            };
          }
        ];
      };

      homeConfigurations."fjk@nixos" = homeManager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${system};
        extraSpecialArgs = { inherit inputs; };
        modules = homeModules;
      };
    };
}
