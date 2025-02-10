{...}: let
  pkgsoverlay = final: _prev: {
    wrappedPkgs = {
      alacritty = final.callPackage ./alacritty {};
    };
  };
in {
  nixpkgs.overlays = [pkgsoverlay];
}
