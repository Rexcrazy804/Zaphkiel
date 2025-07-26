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
      ../../../../nixosModules/exported/kurukuruDM.nix

      # I can't be arsed to use shitty bash
      # just steal my config and be happy :D
      ../../../../nixosModules/programs/fish.nix
      ({pkgs, ...}: {environment.systemPackages = [pkgs.git];})
    ];
  }
