{
  pkgs,
  lib,
  extra-config ? {},
}: let
  config = lib.recursiveUpdate (import ./config.nix) extra-config;
  config_file = pkgs.writers.writeTOML "alacritty.toml" config;
in
  pkgs.symlinkJoin {
    name = "alacritty";
    paths = [
      pkgs.alacritty
    ];

    buildInputs = [
      pkgs.makeWrapper
    ];

    postBuild = ''
      wrapProgram $out/bin/alacritty \
      --add-flags '--config-file ${config_file}'
    '';
  }
