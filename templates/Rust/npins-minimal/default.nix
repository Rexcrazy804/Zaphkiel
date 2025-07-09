{
  sources ? import ./npins,
  pkgs ? import sources.nixpkgs {},
}: let
  toml = pkgs.lib.importTOML ./Cargo.toml;
in
  pkgs.rustPlatform.buildRustPackage {
    # TODO
    # improve builds with crane
    pname = toml.package.name;
    version = toml.package.version;

    src = pkgs.lib.cleanSource ./.;

    # FIXME
    # change the hash as required
    cargoHash = "sha256-uCSmflKcxKTm62Gcp8mTIJctDivnp2qtO6chIck1BmU=";
    useFetchCargoVendor = true;
  }
