{...}: let
  pkgsoverlay = final: _prev: {
    netbeans8 = final.callPackage ./netbeans.nix {};
    zenbrowser = final.callPackage ./zen-browser.nix {};
  };
in {
  nixpkgs.overlays = [pkgsoverlay];
}
