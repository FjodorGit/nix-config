{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    catppuccin.url = "github:catppuccin/nix";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser.url = "github:0xc000022070/zen-browser-flake";
  };

  outputs =
    {
      self,
      nixpkgs,
      catppuccin,
      home-manager,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      username = "fjk";
      hostname = "nixos";
      gitUsername = "FjodorGit";
      gitEmail = "f.kholodkov@gmail.com";
    in
    {
      nixosConfigurations.${hostname} = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit inputs username hostname gitUsername gitEmail;
        };
        modules = [
          ./configuration.nix
          inputs.home-manager.nixosModules.default
          catppuccin.nixosModules.catppuccin
        ];
      };

      homeConfigurations."${username}@${hostname}" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = {
          inherit inputs username hostname gitUsername gitEmail;
        };
        modules = [
          ./home.nix
          catppuccin.homeModules.catppuccin
        ];
      };
    };
}
