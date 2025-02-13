{...}: let
  pkgsoverlay = final: _prev: {
    wrappedPkgs = let
      nvim = final.callPackage ./nvim {};
    in
      {
        alacritty = final.callPackage ./alacritty {};
        nushell = final.callPackage ./nushell {};
        git = final.callPackage ./git {};
        mpv = final.callPackage ./mpv {};

        # TODO
        # mangohud
        # sway
        # obs
      }
      // nvim;
  };
in {
  nixpkgs.overlays = [pkgsoverlay];
}
