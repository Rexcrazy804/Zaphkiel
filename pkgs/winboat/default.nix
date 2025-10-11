{
  lib,
  fetchFromGitHub,
  electron,
  nodejs_24,
  buildNpmPackage,
  makeWrapper,
  makeDesktopItem,
  copyDesktopItems,
  usbutils,
  udev,
  winboat-guest-server,
  zip,
}:
buildNpmPackage (final: {
  pname = "winboat";
  version = "0.8.7";

  src = fetchFromGitHub {
    owner = "TibixDev";
    repo = "winboat";
    tag = "v${final.version}";
    hash = "sha256-30WzvdY8Zn4CAj76bbC0bevuTeOSfDo40FPWof/39Es=";
  };

  postPatch = ''
    substituteInPlace package.json \
      --replace-fail "main/main.js" "src/main/main.ts"

    substituteInPlace electron-builder.json \
      --replace-fail '["appimage", "deb", "rpm", "tar.gz"]' '["tar.gz"]'
  '';

  nativeBuildInputs = [
    makeWrapper
    copyDesktopItems
    zip
  ];

  buildInputs = [udev];

  env.ELECTRON_SKIP_BINARY_DOWNLOAD = 1;
  npmDepsHash = "sha256-nW+cGX4Y0Ndn1ubo4U3n8ZrjM5NkxIt4epB0AghPrNQ=";
  nodejs = nodejs_24;
  makeCacheWritable = true;

  buildPhase = ''
    node scripts/build.ts

    npm exec electron-builder --linux -- \
      --dir \
      -c.electronDist=${electron.dist} \
      -c.electronVersion=${electron.version} \
      -c.npmRebuild=false
  '';

  installPhase = ''
    runHook preInstall

    # install built artifacts
    mkdir -p $out/bin $out/share/winboat
    cp -r dist/linux-unpacked/* $out/share/winboat

    # install the icon
    mkdir -p $out/share/icons/hicolor/256x256/apps
    cp icons/icon.png $out/share/icons/hicolor/256x256/apps/winboat.png

    # copy the the winboat-guest-server executable and zip it
    cp -r ${winboat-guest-server}/* $out/share/winboat/resources/guest_server/
    (cd $out/share/winboat/resources/guest_server/ && zip -r winboat_guest_server.zip .)

    # needed for some reason
    cp -r dist/linux-unpacked/resources/data $out/share/winboat/data
    cp -r $out/share/winboat/resources/guest_server $out/share/winboat/guest_server

    # wrap wrap wrap
    makeWrapper ${electron}/bin/electron $out/bin/winboat \
      --add-flag "$out/share/winboat/resources/app.asar" \
      --suffix PATH : "${usbutils}/bin" \
      ''${gappsWrapperArgs[@]}

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "winboat";
      desktopName = "WinBoat";
      type = "Application";
      exec = "winboat %U";
      terminal = false;
      icon = "winboat";
      categories = ["Utility"];
    })
  ];

  meta = {
    mainProgram = "winboat";
    description = "Run Windows apps on Linux with seamless integration";
    license = lib.licenses.mit;
    platforms = ["x86_64-linux"];
  };
})
