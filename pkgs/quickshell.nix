{
  symlinkJoin,
  makeWrapper,
  quickshell,
  kdePackages,
  material-symbols,
  makeFontsConf,
  nerd-fonts,
  lib,
}: let
  qsConfig = ../users/Configs/quickshell/kurukurubar;
  qs = quickshell.override {
    withJemalloc = true;
    withQtSvg = true;
    withWayland = true;
    withX11 = false;
    withPipewire = true;
    withPam = true;
    withHyprland = true;
    withI3 = false;
  };
in
  symlinkJoin rec {
    name = "qs-wrapper";
    paths = [qs];
    buildInputs = [makeWrapper];
    qtDeps = [
      kdePackages.qtbase
      kdePackages.qtdeclarative
      kdePackages.qtmultimedia
    ];

    qmlPath = lib.pipe qtDeps [
      (builtins.map (lib: "${lib}/lib/qt-6/qml"))
      (builtins.concatStringsSep ":")
    ];

    # requried when nix running directly
    fontconfig = makeFontsConf {
      fontDirectories = [
        material-symbols
        nerd-fonts.caskaydia-mono
      ];
    };

    postBuild = ''
      wrapProgram $out/bin/quickshell \
        --set FONTCONFIG_FILE "${fontconfig}" \
        --set QML2_IMPORT_PATH "${qmlPath}" \
        --add-flags '-p ${qsConfig}'
    '';

    meta.mainProgram = "quickshell";
  }
