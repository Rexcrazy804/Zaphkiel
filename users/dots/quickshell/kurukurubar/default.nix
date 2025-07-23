{sources ? import ../../../../npins}: let
  pkgs' = import ../../../../pkgs {inherit sources;};
  overlays = pkgs'.overlays;
in
  import (sources.nixpkgs + "/nixos/lib/eval-config.nix") {
    system = null;
    specialArgs = {inherit sources;};
    modules = [
      {nixpkgs.overlays = overlays;}
      ./configuration.nix
    ];
  }
