{
  description = "Develop Python on Nix with uv";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
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
        { pkgs, lib, ... }:
        {
          devShells.default = pkgs.mkShell {
            packages = [
              pkgs.python3
              pkgs.uv
            ];

            env = lib.optionalAttrs pkgs.stdenv.isLinux {
              LD_LIBRARY_PATH = lib.makeLibraryPath pkgs.pythonManylinuxPackages.manylinux1;
            };

            shellHook = ''
              unset PYTHONPATH
              uv sync
              . .venv/bin/activate
            '';
          };

          formatter = pkgs.nixfmt;
        };
    };
}
