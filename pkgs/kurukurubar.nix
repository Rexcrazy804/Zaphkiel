# Required Zaphkiel Revison for kurkurubar (stable):
# cc6d5cf12ae824e6945cc2599a2650d5fe054ffe
{
  lib,
  gpurecording,
  rembg,
  librebarcode,
  symlinkJoin,
  makeWrapper,
  runCommandLocal,
  quickshell,
  kdePackages,
  material-symbols,
  makeFontsConf,
  nerd-fonts,
  configPath,
  asGreeter ? false,
}: let
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

  greeterConf = runCommandLocal "quick" {} ''
    mkdir $out
    cd $out
    cp -rp ${configPath}/* .
    chmod u+w *.qml
    rm shell.qml
    mv greeter.qml shell.qml
  '';

  qsConfig =
    if asGreeter
    then greeterConf
    else qmlPath;
in
  symlinkJoin {
    pname = "kurukurubar";
    version = quickshell.version;

    paths = [quickshell rembg gpurecording];
    nativeBuildInputs = [makeWrapper];

    postBuild = ''
      makeWrapper $out/bin/quickshell $out/bin/kurukurubar \
        --set FONTCONFIG_FILE "${fontconfig}" \
        --set QML2_IMPORT_PATH "${qmlPath}" \
        --add-flags '-p ${qsConfig}' \
        --prefix PATH : "$out/bin"
    '';

    meta.mainProgram = "kurukurubar";
  }
