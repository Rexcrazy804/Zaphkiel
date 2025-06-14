{
  pkgs,
  lib,
  ...
}: let
  pkgsoverlay = final: _prev: {
    wrappedPkgs = {
      git = final.callPackage ./git {};
      mpv = final.callPackage ./mpv {};
    };
  };
in {
  nixpkgs.overlays = [pkgsoverlay];
}
