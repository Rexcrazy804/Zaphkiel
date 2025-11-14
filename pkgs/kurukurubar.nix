# Required Zaphkiel Revison for kurkurubar (stable):
# cc6d5cf12ae824e6945cc2599a2650d5fe054ffe
{
  lib,
  stdenvNoCC,
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
  configPath ? ../dots/quickshell/kurukurubar,
  asGreeter ? false,
  # a json file
  customColors ? null,
}: let
  inherit (lib) makeSearchPath optionalString any optionals;

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

  qsConfig' = let
    inherit (lib.fileset) unions toSource fileFilter;
    root = configPath;
    qmlFileFilter = fileFilter (file: any file.hasExt ["qml"]);
  in
    toSource {
      inherit root;
      fileset = unions [
        (qmlFileFilter root)
        (root + /Assets)
        (root + /scripts)
      ];
    };

  qsConfig = stdenvNoCC.mkDerivation {
    name = "kuruconf";
    src = qsConfig';

    installPhase = ''
      runHook preInstall

      mkdir -p $out
      cp -r ./. $out
    '';

    preInstall = optionalString asGreeter ''
      rm shell.qml
      mv greeter.qml shell.qml
    '';
  };
in
  symlinkJoin {
    pname = "kurukurubar";
    version = quickshell.version;
    paths =
      [quickshell]
      # ensures that rembg and gpurecording is not added in the greeter derivation
      ++ (optionals (! asGreeter) [rembg scripts.gpurecording]);
    nativeBuildInputs = [makeWrapper];

    postBuild = ''
      makeWrapper $out/bin/quickshell $out/bin/kurukurubar \
        --set FONTCONFIG_FILE "${fontconfig}" \
        --set QML2_IMPORT_PATH "${qmlPath}" \
        --set KURU_COLORS "${optionalString (customColors != null) "${customColors}"}" \
        --add-flags '-p ${qsConfig}' \
        --prefix PATH : "$out/bin"
    '';

    meta.mainProgram = "kurukurubar";
    passthru.config = qsConfig;
  }
