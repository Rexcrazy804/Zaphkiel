{
  callPackage,
  stdenv,
  fetchFromGitHub,
  agbcc,
  gcc-arm-embedded,
}:
stdenv.mkDerivation (final: {
  __structuredAttrs = true; # who the fuck turned this off?

  pname = "pokeemerald";
  version = "unstable";

  src = fetchFromGitHub {
    owner = "pret";
    repo = "pokeemerald";
    rev = "efc15141285c74c2569a1ef22c48126aaf93c3ee";
    hash = "sha256-KSB/HdD68rnvIFloOXj59qtVfmtEFrngxymVijZh+nw=";
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
    cp -r ${final.vendored.tools}/share/pokeemerald-tools/tools .
    chmod u+rwx tools
    cp -r ${agbcc} ./tools/agbcc
  '';

  buildPhase = ''
    make -j$(nproc)
  '';

  installPhase = ''
    install -Dm444 pokeemerald.gba $out/share/roms/gba/pokeemerald.gba
  '';

  passthru.tools = final.vendored.tools;
})
