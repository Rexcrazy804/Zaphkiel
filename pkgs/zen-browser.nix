{
  stdenv,
  lib,
  fetchzip,
  makeDesktopItem,
  autoPatchelfHook,
  wrapGAppsHook3,
  copyDesktopItems,
  gtk3,
  alsa-lib,
  dbus-glib,
  xorg,
  pciutils,
  libva,
  pipewire,
  libglvnd,
  ffmpeg,
}: let
  desktopItem = makeDesktopItem {
    name = "zen-browser";
    desktopName = "Zen Browser";
    genericName = "Web Browser";
    categories = ["Network" "WebBrowser"];
    keywords = [
      "internet"
      "www"
      "browser"
      "web"
      "explorer"
    ];
    exec = "zen %u";
    icon = "zen";
    mimeTypes = [
      "text/html"
      "text/xml"
      "application/xhtml+xml"
      "application/vnd.mozilla.xul+xml"
      "x-scheme-handler/http"
      "x-scheme-handler/https"
    ];
    startupNotify = true;
    startupWMClass = "zen-alpha";
    terminal = false;
    actions = {
      new-window = {
        name = "New Window";
        exec = "zen --new-window %u";
      };
      new-private-window = {
        name = "New Private Window";
        exec = "zen --private-window %u";
      };
      profile-manager-window = {
        name = "Profile Manager";
        exec = "zen --ProfileManager %u";
      };
    };
  };
in
  stdenv.mkDerivation rec {
    pname = "zen-browser-bin";
    version = "1.0.0-a.34";

    src = fetchzip {
      url = "https://github.com/zen-browser/desktop/releases/download/${version}/zen.linux-specific.tar.bz2";
      hash = "sha256-1dBOu18PePBNF6bwR9pqogQr/o6sh0UNcDtga3MgxP8=";
    };

    desktopItems = [
      desktopItem
    ];

    nativeBuildInputs = [
      autoPatchelfHook
      wrapGAppsHook3
      copyDesktopItems
    ];

    buildInputs = [
      gtk3
      alsa-lib
      dbus-glib
      xorg.libXtst
    ];

    installPhase = ''
      runHook preInstall

      mkdir -p $out/lib
      cp -r $src $out/lib/zen/

      mkdir -p $out/bin
      ln -s $out/lib/zen/zen $out/bin/zen

      for n in {16,32,48,64,128}; do
        size=$n"x"$n
        mkdir -p $out/share/icons/hicolor/$size/apps
        file="default"$n".png"
        cp $out/lib/zen/browser/chrome/icons/default/$file $out/share/icons/hicolor/$size/apps/zen.png
      done

      runHook postInstall
    '';

    preFixup =
      /*
      bash
      */
      ''
        gappsWrapperArgs+=(
          --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [
          pciutils
          pipewire
          libva
          libglvnd
          ffmpeg
        ]}"
        )
        gappsWrapperArgs+=(--set MOZ_LEGACY_PROFILES 1)
        wrapGApp $out/lib/zen/zen
      '';

    meta = with lib; {
      license = licenses.mpl20;
      maintainers = with maintainers; [mordrag];
      description = "Experience tranquillity while browsing the web without people tracking you! ";
      platforms = platforms.linux;
      mainProgram = "zen";
    };
  }
