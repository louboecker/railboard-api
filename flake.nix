{
  description = "API for german public transport data and backend for github.com/StckOverflw/railboard";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ flake-parts, rust-overlay, nixpkgs, ... }:
    let
      system = "x86_64-linux";
      overlays = [ (import rust-overlay) ];
      pkgs = import nixpkgs {
        inherit system overlays;
      };
    in
    {
      flake-parts.lib.mkFlake = { inherit inputs; } {
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
          };
        flake = { };
      };
      devShells.x86_64-linux.default =
        with pkgs;
        mkShell rec {
          nativeBuildInputs = [
            pkg-config
            rust-bin.stable.latest.default
            libiconv
            cargo
            rustfmt
            clippy
            rust-analyzer
          ];
          buildInputs = [
          ];
          RUST_SRC_PATH = "${rustPlatform.rustLibSrc}";
          LD_LIBRARY_PATH = lib.makeLibraryPath (buildInputs ++ nativeBuildInputs);
        };
    };
}
