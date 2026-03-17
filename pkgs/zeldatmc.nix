{
  python3,
  requireFile,
  stdenv,
  fetchFromGitHub,
  gcc-arm-embedded-14,
  which,
  agbcc,
  zeldatmc-tools,
  romBuild ? "baserom.gba",
  romHash ? "sha256-vtx032J1X3BTmCc96O07xZvmEM9Vdg0LmqJ38fUDXnM=",
}:
stdenv.mkDerivation (final: {
  pname = "zeldatmc";
  version = "unstable";

  src = fetchFromGitHub {
    owner = "zeldaret";
    repo = "tmc";
    rev = "5ab63f00e522ff69c5bc987e379f0163943f2833";
    hash = "sha256-g/hOCkwv94AZFogVH/sdd5TmOOFh/u4IQPeKjW9G8lU=";
  };

  # getting sha256 HASH
  # nix hash convert --hash-algo sha256 --to sri $(nix-prefetch-url file:///path/to/file)
  # See https://github.com/zeldaret/tmc/blob/master/INSTALL.md
  baseRom = requireFile {
    url = "https://some-rom-site.cm";
    name = romBuild;
    hash = romHash;
  };

  nativeBuildInputs = [
    gcc-arm-embedded-14
    which
    (python3.withPackages (p: [p.pycparser]))
  ];

  env.AGBCC_PATH = agbcc;

  postPatch = ''
    cp ${final.baseRom} ./${romBuild}
    cp -R ${zeldatmc-tools}/* ./tools/

    patchShebangs .

    # skip cmake stuff zeldatmc-tools handles this for us
    substituteInPlace Makefile \
      --replace-fail "cmake" "# cmake"
  '';

  buildPhase = ''
    # make -f GBA.mk build GAME_VERSION=USA
    make -j$(nproc)
  '';

  installPhase = ''
    install -Dm445 tmc.gba $out/share/roms/gba/zeldatmc.gba
  '';
})
