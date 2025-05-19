{stdenv}:
stdenv.mkDerivation {
  name = "kokomiIcon";
  src = builtins.fetchTarball {
    url = "https://ocs-dl.fra1.cdn.digitaloceanspaces.com/data/files/1719068798/Kokomi.tar.gz?response-content-disposition=attachment%3B%2520Kokomi.tar.gz&X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=RWJAQUNCHT7V2NCLZ2AL%2F20250519%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20250519T165709Z&X-Amz-SignedHeaders=host&X-Amz-Expires=3600&X-Amz-Signature=42cc7277477d7762ddb5956744984d2bbeae7d9a7513dde2a164d7cb6f9f2869";
    sha256 = "0cb2v94n14i245p97m2r3r09p293wja5rypkhh87pzhnanam5sa4";
  };

  installPhase = ''
    mkdir -p $out/share/icons/Kokomi_Cursor
    cp -r ./* $out/share/icons/Kokomi_Cursor
  '';
}
