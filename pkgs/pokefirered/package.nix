{
  callPackage,
  lib,
  stdenv,
  fetchFromGitHub,
  agbcc,
  gcc-arm-embedded,
  edition ? "firered", # one of ["firered" "leafgreen" "firered_rev1" "leafgreen_rev1"]
  useDevKitARMC ? true,
}:
stdenv.mkDerivation (final: let
  editionText = edition + lib.optionalString useDevKitARMC "_modern";
in {
  __structuredAttrs = true; # who the fuck turned this off?

  pname = "pokefirered";
  version = "unstable";

  src = fetchFromGitHub {
    owner = "pret";
    repo = "pokefirered";
    rev = "7e3f822652ecce0c99b626d74f455c3b93660377";
    hash = "sha256-WYHHKJOlxdWwpEecdgREt95KNBhfWYmvnhGRCt8ynKI=";
  };

  vendored.tools = callPackage ./tools.nix {};

  nativeBuildInputs = [
    agbcc
    gcc-arm-embedded
  ];

  buildInputs = [
    agbcc
  ];

  postPatch = ''
    rm -rf tools
    cp -r ${final.vendored.tools}/share/pokefirered-tools/tools .
    chmod u+rwx tools
    cp -r ${agbcc} ./tools/agbcc
  '';

  buildPhase = ''
    make -j$(nproc) ${editionText}
  '';

  installPhase = ''
    install -Dm444 poke${editionText}.gba $out/share/roms/gba/poke${edition}.gba
  '';

  passthru.tools = final.vendored.tools;
})
