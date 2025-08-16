{
  sources,
  lib,
}: let
  overlays = lib.attrValues {
    sources = final: prev: {inherit sources;};
    lix = import ../pkgs/overlays/lix.nix {lix = null;};
    internal = import ../pkgs/overlays/internal.nix;
  };
  nixosSystem = import (sources.nixpkgs + "/nixos/lib/eval-config.nix");
  nixosHost = hostName:
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
in {
  Persephone = nixosHost "Persephone";
  Seraphine = nixosHost "Seraphine";
  Aphrodite = nixosHost "Aphrodite";
}
