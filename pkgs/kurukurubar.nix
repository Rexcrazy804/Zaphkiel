# Required Zaphkiel Revison for kurkurubar (stable):
# cc6d5cf12ae824e6945cc2599a2650d5fe054ffe
{
  lib,
  scripts,
  rembg,
  librebarcode,
  symlinkJoin,
  makeWrapper,
  quickshell,
  kdePackages,
  material-symbols,
  makeFontsConf,
  nerd-fonts,
  configPath ? ../users/dots/quickshell/kurukurubar,
}: let
  inherit (lib) makeSearchPath;
  qmlPath = makeSearchPath "lib/qt-6/qml" [
    kdePackages.qtbase
    kdePackages.qtdeclarative
    kdePackages.qtmultimedia
  ];

  # requried when nix running directly
  fontconfig = makeFontsConf {
    fontDirectories = [
      material-symbols
      nerd-fonts.caskaydia-mono
      librebarcode
    ];
  };

  qsConfig = let
    inherit (lib.fileset) unions toSource;
    root = configPath;
  in
    toSource {
      inherit root;
      fileset = unions [
        (root + /Assets)
        (root + /Containers)
        (root + /Data)
        (root + /Generics)
        (root + /Layers)
        (root + /scripts)
        (root + /Widgets)
        (root + /shell.qml)
        (root + /greeter.qml)
      ];
    };
in
  symlinkJoin {
    pname = "kurukurubar";
    version = quickshell.version;

    paths = [quickshell rembg scripts.gpurecording];
    nativeBuildInputs = [makeWrapper];

    postBuild = ''
      makeWrapper $out/bin/quickshell $out/bin/kurukurubar \
        --set FONTCONFIG_FILE "${fontconfig}" \
        --set QML2_IMPORT_PATH "${qmlPath}" \
        --add-flags '-p ${qsConfig}' \
        --prefix PATH : "$out/bin"
    '';

    meta.mainProgram = "kurukurubar";
    passthru.config = qsConfig;
  }
