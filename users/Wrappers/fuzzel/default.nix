{pkgs}: let
  base = builtins.readFile ./fuzzel.ini;
  colors = builtins.readFile ./colors.ini;
  config_file = pkgs.writeText "config.ini" (base + colors);
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
