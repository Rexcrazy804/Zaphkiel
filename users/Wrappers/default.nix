{
  pkgs,
  lib,
  ...
}: let
  pkgsoverlay = final: _prev: {
    wrappedPkgs = let
      nvim = import ./nvim {inherit pkgs lib;};
    in
      {
        alacritty = final.callPackage ./alacritty {};
        nushell = final.callPackage ./nushell {};
        git = final.callPackage ./git {};
        mpv = final.callPackage ./mpv {};
        fuzzel = final.callPackage ./fuzzel {};

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
