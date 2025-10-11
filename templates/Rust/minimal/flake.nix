{
  description = "A minimal rust Flake template";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    rust-overlay,
    ...
  }: let
    overlays = [rust-overlay.overlays.default];
    systems = ["x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin"];
    forAllSystems = f:
      nixpkgs.lib.genAttrs systems (
        system:
          f (import nixpkgs {inherit system overlays;})
      );
  in {
    packages = forAllSystems (pkgs: let
      toml = pkgs.lib.importTOML ./Cargo.toml;
      rust-package = pkgs.rustPlatform.buildRustPackage {
        pname = toml.package.name;
        version = toml.package.version;

        src = pkgs.lib.cleanSource ./.;
        # FIX THIS HASH
        cargoHash = "sha256-uCSmflKcxKTm62Gcp8mTIJctDivnp2qtO6chIck1BmU=";
        useFetchCargoVendor = true;
      };
    in {
      default = rust-package;
    });

    devShells = forAllSystems (pkgs: {
      default =
        pkgs.mkShell.override (old: {
          # Using mold for faster successive compiles
          stdenv = pkgs.stdenvAdapters.useMoldLinker old.stdenv;
        }) {
          buildInputs = [
            (pkgs.rust-bin.stable.latest.default.override {
              # required by rust_analyzer
              extensions = ["rust-src"];
            })
          ];
        };
    });
  };
}
