{
  sources,
  lib,
}: let
  inherit (lib) attrValues genAttrs;
  overlays = attrValues {
    sources = final: prev: {inherit sources;};
    lix = import ../pkgs/overlays/lix.nix {lix = null;};
    internal = import ../pkgs/overlays/internal.nix;
  };
  nixosSystem = import (sources.nixpkgs + "/nixos/lib/eval-config.nix");
  mkHost = hostName:
    nixosSystem {
      system = null;
      specialArgs = {inherit sources;};
      modules = [
        {nixpkgs.overlays = overlays;}
        ./${hostName}/configuration.nix
        ../users/rexies.nix
        ../nixosModules
      ];
    };

  hosts = ["Persephone" "Seraphine" "Aphrodite"];
in
  genAttrs hosts mkHost
