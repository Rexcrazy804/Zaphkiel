{
  stdenv,
  fetchFromGitHub,
  agbcc,
  pokefirered-tools,
  gcc-arm-embedded,
}:
stdenv.mkDerivation {
  pname = "pokefirered";
  version = "unstable";

  src = fetchFromGitHub {
    owner = "pret";
    repo = "pokefirered";
    rev = "7e3f822652ecce0c99b626d74f455c3b93660377";
    hash = "sha256-WYHHKJOlxdWwpEecdgREt95KNBhfWYmvnhGRCt8ynKI=";
  };

  nativeBuildInputs = [
    agbcc
    gcc-arm-embedded
  ];

  buildInputs = [
    agbcc
  ];

  postPatch = ''
    rm -rf tools
    cp -r ${pokefirered-tools}/share/pokefirered-tools/tools .
    chmod u+rwx tools
    cp -r ${agbcc} ./tools/agbcc
  '';

  buildPhase = ''
    make -j$(nproc)
  '';

  installPhase = ''
    install -Dm445 pokefirered.gba $out/share/roms/gba/pokefirered.gba
  '';
}
