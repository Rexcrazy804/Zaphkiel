{
  lib,
  rembg,
  librebarcode,
  symlinkJoin,
  makeWrapper,
  quickshell,
  kdePackages,
  material-symbols,
  makeFontsConf,
  nerd-fonts,
}: let
  qsConfig = ../users/dots/quickshell/kurukurubar;
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
      librebarcode
    ];
  };
in
  symlinkJoin {
    pname = "kurukurubar";
    version = quickshell.version;

    paths = [quickshell rembg];
    buildInputs = [makeWrapper];

    postBuild = ''
      makeWrapper $out/bin/quickshell $out/bin/kurukurubar \
        --set FONTCONFIG_FILE "${fontconfig}" \
        --set QML2_IMPORT_PATH "${qmlPath}" \
        --add-flags '-p ${qsConfig}' \
        --prefix PATH ":" "${rembg}/bin/rembg"
    '';

    meta.mainProgram = "kurukurubar";
  }
