# WARN
# https://github.com/mpv-player/mpv/discussions/13909
# AMD gpu's require RADV_PERFTEST=video_decode to be set
# and intel requires ANV_VIDEO_DECODE=1
# for vulkan my modules set these values so note to myself
# the values are set .w. trust me bro .w.
{
  symlinkJoin,
  callPackage,
  lib,
  linkFarm,
  anime ? false,
  mpv,
  makeWrapper,
}: let
  shadderConfig = callPackage ./bindings.nix {};
  mpvconf = linkFarm "mpvConfDir" (
    [
      {
        name = "mpv.conf";
        path = ./mpv.conf;
      }
    ]
    ++ (lib.optional anime {
      name = "input.conf";
      path = shadderConfig;
    })
  );
in
  symlinkJoin {
    name = "mpv-wrapped";
    paths = [mpv];

    buildInputs = [makeWrapper];

    postBuild = ''
      wrapProgram $out/bin/mpv \
        --add-flags '--config-dir=${mpvconf}'
    '';

    meta.description = "A wrapped mpv package with support for anime 4k shadders";
  }
