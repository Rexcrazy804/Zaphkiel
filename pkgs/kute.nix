{
  lib,
  appimageTools,
  fetchurl,
}:
appimageTools.wrapType2 (final: {
  pname = "kute";
  version = "1.3.0";

  src = fetchurl {
    url = "https://github.com/NullDev/Kute/releases/download/${final.version}/kute-x86_64.AppImage";
    hash = "sha256-d3471uNzxn75qBWx2a6T1lOwTjGyG+6DL5Jda6RwXE0=";
  };

  appId = "lol.kute.Kute";

  appimageContents = appimageTools.extract {
    inherit (final) pname version src;
  };

  extraInstallCommands = ''
    mkdir -p $out/share/{applications,pixmaps}
    install -Dm644 ${final.appimageContents}/${final.appId}.desktop -t $out/share/applications
    install -Dm644 ${final.appimageContents}/kute.png -t $out/share/pixmaps
  '';

  meta = {
    mainProgram = "kute";
    description = "Client for Krunker.io";
    homepage = "https://github.com/NullDev/Kute";
    license = lib.licenses.gpl3;
    sourceProvenance = [lib.sourceTypes.binaryNativeCode];
    maintainers = [lib.maintainers.rexies];
    platforms = ["x86_64-linux"];
  };
})
