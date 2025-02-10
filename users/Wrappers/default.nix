{...}: let
  pkgsoverlay = final: _prev: {
    wrappedPkgs = {
      alacritty = final.callPackage ./alacritty {};
      nushell = final.callPackage ./nushell {};
    };
  };
in {
  nixpkgs.overlays = [pkgsoverlay];
}
