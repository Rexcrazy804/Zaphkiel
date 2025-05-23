{stdenv}:
stdenv.mkDerivation {
  name = "kokomiIcon";
  src = builtins.fetchTarball {
    url = let 
      proto = "https";
      domain = ["chibisafe" "crispy-caesus" "eu"];
      file = "WUfAKD3Ct2y3";
      filetype = "gz";
    in 
      proto + "://" + (builtins.concatStringsSep "." domain) + "/" + file + "." + filetype;

    sha256 = "0cb2v94n14i245p97m2r3r09p293wja5rypkhh87pzhnanam5sa4";
  };

  installPhase = ''
    mkdir -p $out/share/icons/Kokomi_Cursor
    cp -r ./* $out/share/icons/Kokomi_Cursor
  '';
}
