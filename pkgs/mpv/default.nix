# WARN
# https://github.com/mpv-player/mpv/discussions/13909
# AMD gpu's require RADV_PERFTEST=video_decode to be set
# and intel requires ANV_VIDEO_DECODE=1
# for vulkan my modules set these values so note to myself
# the values are set .w. trust me bro .w.
{
  pkgs,
  lib,
  # enable anime 4k shadders
  anime ? false,
}: let
  shadderConfig = pkgs.callPackage ./bindings.nix {};
  mpvconf = pkgs.linkFarm "mpvConfDir" (
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
  pkgs.symlinkJoin {
    name = "mpv";
    paths = [pkgs.mpv];

    buildInputs = [pkgs.makeWrapper];

    postBuild = ''
      wrapProgram $out/bin/mpv \
        --add-flags '--config-dir=${mpvconf}'
    '';

    meta.description = "A wrapped mpv package with support for anime 4k shadders";
  }
