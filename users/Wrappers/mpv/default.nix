{
  pkgs,
  lib,
  anime ? false,
}: let
  mpvconf = let
    conf = pkgs.writeText "mpv.conf" ''
      geometry=75%x75%
      gpu-context=wayland
      hwdec=auto-safe
      profile=gpu-hq
      screenshot-template='%F - [%P] (%#01n)'
      vo=gpu
    '';
    shadder = pkgs.writeText "input.conf" (import ./bindings.nix);
  in
    pkgs.linkFarm "mods" ([
      {
        name = "mpv.conf";
        path = conf;
      }
    ] ++ (lib.optionals anime {
        name = "input.conf";
        path = shadder;
    }));
in
  pkgs.symlinkJoin {
    name = "mpv";
    paths = [
      pkgs.mpv
    ];

    buildInputs = [
      pkgs.makeWrapper
    ];

    postBuild = ''
      wrapProgram $out/bin/mpv \
        --add-flags '--config-dir=${mpvconf}'
    '';
  }
