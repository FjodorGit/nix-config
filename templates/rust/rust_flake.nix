{
  description = "A Nix-flake-based Rust development environment";

  inputs = {
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1";
    flake-parts.url = "github:hercules-ci/flake-parts";
    fenix = {
      url = "https://flakehub.com/f/nix-community/fenix/0.1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
      ];

      perSystem =
        { pkgs, system, ... }:
        let
          rustToolchain =
            with inputs.fenix.packages.${system};
            combine (
              with stable;
              [
                clippy
                rustc
                cargo
                rustfmt
                rust-src
              ]
            );
        in
        {
          devShells.default = pkgs.mkShell {
            packages = with pkgs; [
              rustToolchain
              openssl
              pkg-config
              cargo-deny
              cargo-edit
              cargo-watch
              rust-analyzer
            ];
            env = {
              RUST_SRC_PATH = "${rustToolchain}/lib/rustlib/src/rust/library";
            };
          };

          formatter = pkgs.nixfmt;
        };
    };
}
