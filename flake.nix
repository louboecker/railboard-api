{
  description = "API for german public transport data and backend for github.com/StckOverflw/railboard";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    inputs@{
      flake-parts,
      nixpkgs,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
      };
    in
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];
      perSystem =
        {
          config,
          self',
          inputs',
          pkgs,
          system,
          ...
        }:
        {
          packages.default = pkgs.callPackage ./nix/package.nix { };
          devShells.default =
            with pkgs;
            mkShell rec {
              nativeBuildInputs = [
                pkg-config
                rustc
                cargo
                rustfmt
                clippy
                rust-analyzer
              ];
              buildInputs = [
              ];
              RUST_SRC_PATH = "${rustPlatform.rustLibSrc}";
            };
        };
      flake = { };
    };
}
