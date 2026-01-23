{
  lib,
  stdenv,
  python3,
  WiiUDownloader,
}:
stdenv.mkDerivation {
  inherit (WiiUDownloader) src version;
  pname = "WiiuDownloader-db.go";

  buildPhase = ''
    ${lib.getExe python3} grabTitles.py
    cp db.go $out
  '';

  outputHash = "sha256-T9yRkr8kpvgo4hMioboIUDfyjyzfzf3ZL3hqPwIw6T0=";
  outputHashAlgo = "sha256";
  outputHashMode = "recursive";

  meta = {
    description = "db.go file containing titles for WiiUDownloader";
    license = lib.licenses.gpl3;
    maintainers = [lib.maintainers.rexies];
    platforms = lib.platforms.all;
  };
}
