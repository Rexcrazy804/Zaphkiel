{pkgs, ...}:
pkgs.symlinkJoin {
  name = "eww-wrapper";
  paths = [pkgs.eww];
  buildInputs = [pkgs.makeWrapper];

  postBuild = let 
    # confdir = "/home/rexies/nixos/users/Wrappers/eww/config";
    confdir = ./config;
  in /*bash*/''
    wrapProgram $out/bin/eww \
    --add-flags '--config ${confdir}'
  '';
}
