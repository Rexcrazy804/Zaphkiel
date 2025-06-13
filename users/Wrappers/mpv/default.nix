{
  pkgs,
  lib,
  anime ? false,
}: let
  mainConf = let
    conf = pkgs.writeText "mpv.conf" ''
      geometry=75%x75%
      gpu-context=wayland
      hwdec=auto-safe
      profile=gpu-hq
      screenshot-template='%F - [%P] (%#01n)'
      vo=gpu
    '';
  in [
    {
      name = "mpv.conf";
      path = conf;
    }
  ];

  shadderConfig = let
    shadder = pkgs.writeText "input.conf" (import ./bindings.nix);
  in [
    {
      name = "input.conf";
      path = shadder;
    }
  ];

  finalConfigList = mainConf ++ (lib.optionals anime shadderConfig);
  mpvconf = pkgs.linkFarm "mpvConfDir" finalConfigList;
in
  pkgs.symlinkJoin {
    name = "mpv";
    paths = [pkgs.mpv];

    buildInputs = [pkgs.makeWrapper];

    postBuild = ''
      wrapProgram $out/bin/mpv \
        --add-flags '--config-dir=${mpvconf}'
    '';
  }
