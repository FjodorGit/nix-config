{
  description = "NixOS config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland.url = "github:hyprwm/Hyprland";
    niri.url = "github:sodiboo/niri-flake";
    catppuccin.url = "github:catppuccin/nix";
    llm-agents.url = "github:numtide/llm-agents.nix";
    xremap.url = "github:xremap/nix-flake";
    chromeBeta = {
      url = "github:nix-community/browser-previews";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    firefoxNightly = {
      url = "github:nix-community/flake-firefox-nightly";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix.url = "github:ryantm/agenix";
    helium.url = "path:./helium-patches";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      catppuccin,
      niri,
      disko,
      agenix,
      ...
    }@inputs:
    let
      # ── Named home-manager module sets ──────────────────────
      homeModules = {
        core = import ./modules/home/cli/core.nix;
        zsh = import ./modules/home/cli/zsh.nix;
        zellij = import ./modules/home/cli/zellij.nix;
        neovim = import ./modules/home/cli/neovim.nix;
        git = import ./modules/home/cli/git.nix;
        shell-tools = import ./modules/home/cli/shell-tools.nix;
        hyprland = import ./modules/home/desktop/hyprland.nix;
        niri-config = import ./modules/home/desktop/niri.nix;
        waybar = import ./modules/home/desktop/waybar.nix;
        apps = import ./modules/home/desktop/apps.nix;
        kitty = import ./modules/home/desktop/kitty.nix;
        services = import ./modules/home/desktop/services.nix;
      };

      # ── Reusable bundles ────────────────────────────────────
      cliBundle = with homeModules; [
        core
        zsh
        neovim
        git
        shell-tools
        zellij
      ];

      desktopBundle =
        cliBundle
        ++ (with homeModules; [
          niri-config
          apps
          kitty
          services
        ])
        ++ [
          catppuccin.homeModules.catppuccin
        ];

      # ── Host builder ────────────────────────────────────────
      mkHost =
        {
          system,
          nixosModules,
          homeImports,
          username ? "fjk",
        }:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [
            ./modules/nixos/common.nix
          ]
          ++ nixosModules
          ++ [
            home-manager.nixosModules.default
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = { inherit inputs self; };
                users.${username} = {
                  imports = homeImports;
                  home = {
                    inherit username;
                    homeDirectory = "/home/${username}";
                    stateVersion = "24.05";
                  };
                };
              };
            }
          ];
        };
    in
    {
      nixosConfigurations = {
        desktop = mkHost {
          system = "x86_64-linux";
          nixosModules = [
            ./hosts/desktop
            catppuccin.nixosModules.catppuccin
            agenix.nixosModules.default
            niri.nixosModules.niri
            { nixpkgs.overlays = [ niri.overlays.niri ]; }
          ];
          homeImports = desktopBundle;
        };

        server = mkHost {
          system = "x86_64-linux";
          nixosModules = [
            disko.nixosModules.disko
            agenix.nixosModules.default
            ./hosts/server
          ];
          homeImports = cliBundle;
        };
      };
    };
}
