{
  lib,
  stdenv,
  fetchzip,
}:
stdenv.mkDerivation {
  name = "kokomiIcon";
  src = fetchzip {
    url = let
      proto = "https";
      domain = ["chibisafe" "crispy-caesus" "eu"];
      file = "WUfAKD3Ct2y3";
      filetype = "gz";
    in
      proto + "://" + (lib.concatStringsSep "." domain) + "/" + file + "." + filetype;

    sha256 = "sha256-ROlSlVUW/nsQhPP6XJTkI4mbQB5Z1JNuISKSYEnaYjE=";
    extension = "tar";
  };

  installPhase = ''
    mkdir -p $out/share/icons/Kokomi_Cursor
    cp -r ./* $out/share/icons/Kokomi_Cursor
  '';
}
