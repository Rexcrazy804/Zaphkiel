{...}: let
  pkgsoverlay = final: _prev: {
    wrappedPkgs = {
      alacritty = final.callPackage ./alacritty {};
      nushell = final.callPackage ./nushell {};
      git = final.callPackage ./git {};
      mpv = final.callPackage ./mpv {};

      # TODO
      # mangohud
      # sway
      # obs
      # mpv
    };
  };
in {
  nixpkgs.overlays = [pkgsoverlay];
}
