{
  description = "NixOS config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    niri.url = "git+https://github.com/epireyn/niri-flake.git";
    catppuccin.url = "github:catppuccin/nix";
    llm-agents.url = "github:numtide/llm-agents.nix";
    omp.url = "github:can1357/oh-my-pi";
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
    elephant.url = "github:abenz1267/elephant";
    walker = {
      url = "github:abenz1267/walker";
      inputs.elephant.follows = "elephant";
    };
    gws = {
      url = "github:googleworkspace/cli";
      inputs.elephant.follows = "elephant";
    };
    helium.url = "path:./helium-patches";
    nmrs = {
      url = "github:networkmanager-rs/nmrs-gui";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
        agent-rules = import ./modules/home/cli/agent-rules.nix;
        omp = import ./modules/home/cli/omp.nix;
        niri-config = import ./modules/home/desktop/niri.nix;
        apps = import ./modules/home/desktop/apps.nix;
        kitty = import ./modules/home/desktop/kitty.nix;
        walker = import ./modules/home/desktop/walker.nix;
        services = import ./modules/home/desktop/services.nix;
      };

      # ── Reusable bundles ────────────────────────────────────
      cliBundle = with homeModules; [
        core
        zsh
        neovim
        git
        shell-tools
        agent-rules
        omp
        zellij
      ];

      desktopBundle =
        cliBundle
        ++ (with homeModules; [
          niri-config
          apps
          kitty
          walker
          services
        ])
        ++ [
          catppuccin.homeModules.catppuccin
          inputs.walker.homeManagerModules.default
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
            (
              { pkgs, ... }:
              {
                programs.niri.package = pkgs.niri-unstable;
              }
            )
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
