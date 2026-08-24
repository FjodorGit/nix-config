{
  description = "A Nix-flake-based C/C++ development environment";

  inputs = {
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0"; # stable Nixpkgs
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
      ];

      perSystem =
        { pkgs, config, ... }:
        {
          devShells.default =
            pkgs.mkShell.override
              {
                # stdenv = pkgs.clangStdenv;
              }
              {
                packages = with pkgs; [
                  clang-tools
                  cmake
                  config.formatter
                ];
              };

          formatter = pkgs.nixfmt;
        };
    };
}
