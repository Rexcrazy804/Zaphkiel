{pkgs, ...}:
pkgs.symlinkJoin {
  name = "eww-wrapper";
  # pulse audio requried for the scripts .w.
  # did not waste time rewriting it in wpctl
  # only to realize that it doesn't support as
  # many features :D
  paths = [pkgs.eww pkgs.pulseaudio];

  buildInputs = [pkgs.makeWrapper];

  postBuild = let
    # confdir = "/home/rexies/nixos/users/Wrappers/eww/config";
    confdir = ./config;
  in
    /*
    bash
    */
    ''
      wrapProgram $out/bin/eww \
        --add-flags '--config ${confdir}'
    '';
}
