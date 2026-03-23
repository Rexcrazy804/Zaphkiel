{
  lib,
  stdenv,
  zlib,
  libpng,
  pokeemerald,
}:
stdenv.mkDerivation {
  inherit (pokeemerald) src;
  pname = "pokeemerald-tools";
  version = "unstable";

  buildInputs = [
    zlib
    libpng
  ];

  buildPhase = ''
    make tools -j$(nproc)
  '';

  env.TOOLNAMES = lib.concatStringsSep " " [
    "bin2c"
    "gbafix"
    "gbagfx"
    "jsonproc"
    "mapjson"
    "mid2agb"
    "preproc"
    "ramscrgen"
    "rsfont"
    "scaninc"
    "wav2agb"
  ];

  installPhase = ''
    mkdir -p $out/share/pokeemerald-tools
    cp -R tools $out/share/pokeemerald-tools

    mkdir -p $out/bin
    for tool in $TOOLNAMES; do
      ln -sf $out/share/pokeemerald-tools/tools/$tool/$tool $out/bin/$tool
    done;
  '';
}
