{
  pkgs,
  lib,
  ...
}: let
  pkgsoverlay = final: _prev: {
    wrappedPkgs = {git = final.callPackage ./git {};};
  };
in {
  nixpkgs.overlays = [pkgsoverlay];
}
