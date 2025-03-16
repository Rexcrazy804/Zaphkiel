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
        wezterm = final.callPackage ./wezterm {};
        alacritty = final.callPackage ./alacritty {};
        git = final.callPackage ./git {};
        mpv = final.callPackage ./mpv {};
        eww = final.callPackage ./eww {};
        swaync = final.callPackage ./swaync {};
        fzf = final.callPackage ./fzf {};
      }
      // nvim;
  };
in {
  nixpkgs.overlays = [pkgsoverlay];
}
