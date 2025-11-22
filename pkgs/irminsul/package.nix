{
  lib,
  writers,
  gnumake,
  symlinkJoin,
  makeWrapper,
  # formatters
  alejandra,
  stylua,
  mdformat,
  qt6,
  qmlcheck,
  taplo,
  deadnix,
}: let
  interpreter = "${gnumake}/bin/make -f";
  writeMakefile = writers.makeScriptWriter {
    inherit interpreter;
    # check = interpreter;
  };
  writeMakefileBin = name: writeMakefile "/bin/${name}";
  irminsul = writeMakefileBin "irminsul" (builtins.readFile ./Makefile);

  deps = lib.makeSearchPath "bin" [
    alejandra
    stylua
    mdformat
    qt6.qtdeclarative
    qmlcheck
    taplo
    deadnix
  ];
in
  symlinkJoin {
    name = "irminsul-wrapped";
    paths = [irminsul];
    nativeBuildInputs = [makeWrapper];
    postBuild = ''
      wrapProgram $out/bin/irminsul \
        --prefix PATH : "${deps}"
    '';
    meta.mainProgram = "irminsul";
  }
