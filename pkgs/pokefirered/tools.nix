{
  lib,
  stdenv,
  zlib,
  libpng,
  pokefirered,
}:
stdenv.mkDerivation {
  inherit (pokefirered) src;
  pname = "pokefirered-tools";
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
  ];

  installPhase = ''
    mkdir -p $out/share/pokefirered-tools
    cp -R tools $out/share/pokefirered-tools

    mkdir -p $out/bin
    for tool in $TOOLNAMES; do
      ln -sf $out/share/pokefirered-tools/tools/$tool/$tool $out/bin/$tool
    done;
  '';
}
