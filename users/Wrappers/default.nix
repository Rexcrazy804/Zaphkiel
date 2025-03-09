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
        nushell = final.callPackage ./nushell {};
        git = final.callPackage ./git {};
        mpv = final.callPackage ./mpv {};
        fuzzel = final.callPackage ./fuzzel {};
        hyprland = final.callPackage ./hyprland {};
        hyprlock = final.callPackage ./hyprland/hyprlock.nix {};
        hypridle = final.callPackage ./hyprland/hypridle.nix {};
        eww = final.callPackage ./eww {};
        swaync = final.callPackage ./swaync {};
        yazi = final.callPackage ./yazi {};

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
