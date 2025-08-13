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
}: let
  inherit (lib) licenses makeBinPath sourceByRegex;
  inherit (craneLib) buildDepsOnly buildPackage;

  src = sourceByRegex npinsSRC [
    "^src$"
    "^src/.+$"
    "^Cargo.lock$"
    "^Cargo.toml$"
  ];

  commonArgs = {
    inherit src;
    strictDeps = true;
    cargoExtraArgs = "--features clap,crossterm,env_logger";
    buildInputs = lib.optional stdenv.isDarwin (darwin.apple_sdk.frameworks.Security);
    nativeBuildInputs = [makeWrapper];
  };

  cargoArtifacts = buildDepsOnly commonArgs;
  runtimePath = makeBinPath [lix nix-prefetch-git git];
in
  buildPackage (
    commonArgs
    // {
      inherit cargoArtifacts;
      doCheck = false;
      cargoExtraArgs = "--bin npins ${commonArgs.cargoExtraArgs}";
      postFixup = ''
        wrapProgram $out/bin/npins --prefix PATH : "${runtimePath}"
      '';
      meta.license = licenses.gpl3;
    }
  )
