{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:
stdenvNoCC.mkDerivation (final: {
  pname = "librebarcode";
  version = "1.008";
  src = fetchFromGitHub {
    owner = "graphicore";
    repo = "librebarcode";
    tag = "v${final.version}";
    hash = "sha256-QDEas/Mwa2hkXjLWaIl/ugO9n1YNKQdaAHQq3HWTVH8=";
  };

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/share/fonts/truetype
    cp fonts/*.ttf $out/share/fonts/truetype
  '';

  meta = {
    description = "barcode fonts for various barcode standards";
    homepage = "https://graphicore.github.io/librebarcode/";
    platforms = lib.platforms.all;
    license = lib.licenses.ofl;
  };
})
