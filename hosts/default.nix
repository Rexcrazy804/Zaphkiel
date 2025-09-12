{
  self,
  sources,
  inputs,
  lib,
  ...
}: let
  inherit (lib) genAttrs nixosSystem;
  mkHost = hostName:
    nixosSystem {
      specialArgs = {
        inherit inputs sources;
        mein = self.packages;
      };
      modules = [
        ./${hostName}/configuration.nix
        ../nixosModules
        ../users/rexies.nix
        self.nixosModules.default
      ];
    };

  hosts = ["Persephone" "Seraphine" "Aphrodite"];
in
  genAttrs hosts mkHost
