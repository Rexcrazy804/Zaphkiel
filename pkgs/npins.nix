{
  lib,
  stdenv,
  darwin,
  makeWrapper,
  craneLib,
  sources,
  lix,
  nix-prefetch-git,
  git,
  kokoLib,
  symlinkJoin,
}: let
  inherit (lib) licenses makeBinPath sourceByRegex;
  inherit (craneLib) buildDepsOnly buildPackage;
  inherit (kokoLib) mkBakaSrc;

  src = sourceByRegex (sources.npins) [
    "^src$"
    "^src/.+$"
    "^Cargo.lock$"
    "^Cargo.toml$"
  ];

  commonArgs = {
    strictDeps = true;
    cargoExtraArgs = "--features clap,crossterm,env_logger";
    buildInputs = lib.optional stdenv.isDarwin (darwin.apple_sdk.frameworks.Security);
  };

  cargoArtifacts = buildDepsOnly {
    inherit (commonArgs) strictDeps cargoExtraArgs buildInputs;
    name = "${self.pname}-deps";
    dummySrc = mkBakaSrc {inherit self craneLib;};
  };

  self = buildPackage {
    inherit (commonArgs) strictDeps buildInputs;
    inherit src cargoArtifacts;
    doCheck = false;
    cargoExtraArgs = "--bin npins ${commonArgs.cargoExtraArgs}";
    meta.license = licenses.gpl3;
  };
in
  symlinkJoin {
    inherit (self) pname version;
    paths = [self];
    nativeBuildInputs = [makeWrapper];

    postBuild = ''
      wrapProgram $out/bin/npins --prefix PATH : "${makeBinPath [lix nix-prefetch-git git]}"
    '';
  }
