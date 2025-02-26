{
  pkgs,
}: let
  config_file = ./fuzzel.ini;
in
  pkgs.symlinkJoin {
    name = "fuzzel";
    paths = [
      pkgs.fuzzel
    ];

    buildInputs = [
      pkgs.makeWrapper
    ];

    postBuild = ''
      wrapProgram $out/bin/fuzzel \
      --add-flags '--config ${config_file}'
    '';
  }
