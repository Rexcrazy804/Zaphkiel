{...}: let
  pkgsoverlay = final: _prev: {
    wrappedPkgs = {
      alacritty = final.callPackage ./alacritty {};
      nushell = final.callPackage ./nushell {};
      git = final.callPackage ./git {};
    };
  };
in {
  nixpkgs.overlays = [pkgsoverlay];
}
