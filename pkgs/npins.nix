{
  lib,
  stdenv,
  darwin,
  makeWrapper,
  craneLib,
  npinsSRC,
  lix,
  nix-prefetch-git,
  git,
  kokoLib,
}: let
  inherit (lib) licenses makeBinPath sourceByRegex;
  inherit (craneLib) buildDepsOnly buildPackage;
  inherit (kokoLib) mkBakaSrc;

  src = sourceByRegex npinsSRC [
    "^src$"
    "^src/.+$"
    "^Cargo.lock$"
    "^Cargo.toml$"
  ];

  commonArgs = {
    strictDeps = true;
    cargoExtraArgs = "--features clap,crossterm,env_logger";
    buildInputs = lib.optional stdenv.isDarwin (darwin.apple_sdk.frameworks.Security);
    nativeBuildInputs = [makeWrapper];
  };

  cargoArtifacts = buildDepsOnly {
    inherit (commonArgs) strictDeps cargoExtraArgs buildInputs nativeBuildInputs;
    name = "${self.pname}-deps";
    dummySrc = mkBakaSrc {inherit self craneLib;};
  };

  self = buildPackage {
    inherit (commonArgs) strictDeps buildInputs nativeBuildInputs;
    inherit src cargoArtifacts;
    doCheck = false;
    cargoExtraArgs = "--bin npins ${commonArgs.cargoExtraArgs}";
    postFixup = ''
      wrapProgram $out/bin/npins --prefix PATH : "${makeBinPath [lix nix-prefetch-git git]}"
    '';
    meta.license = licenses.gpl3;
  };
in
  self
