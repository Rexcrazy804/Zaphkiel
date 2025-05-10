{
  symlinkJoin,
  makeWrapper,
  quickshell,
  kdePackages,
  lib,
}: let
  qsConfig = ../Configs/newshell;
in
  symlinkJoin rec {
    name = "qs-wrapper";
    paths = [quickshell];

    buildInputs = [ makeWrapper ];

    qtDeps = [
      kdePackages.qtbase
      kdePackages.qtgraphs
      kdePackages.qtdeclarative
      kdePackages.qtmultimedia
    ];

    qmlPath = lib.pipe qtDeps [
      (builtins.map (lib: "${lib}/lib/qt-6/qml"))
      (builtins.concatStringsSep ":")
    ];

    postBuild = ''
      wrapProgram $out/bin/quickshell \
        --set QML2_IMPORT_PATH "${qmlPath}" \
        --add-flags '-p ${qsConfig}'
    '';

    meta.mainProgram = "quickshell";
  }
