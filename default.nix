{
  sources' ? {},
  sources'' ? (import ./npins) // sources',
  system ? builtins.currentSystem,
  nixpkgs ? sources''.nixpkgs,
  pkgs ? import nixpkgs {inherit system;},
  quickshell ? null,
}: let
  inherit (pkgs.lib) fix mapAttrs attrValues makeScope;
  inherit (pkgs) newScope;

  # WARNING
  # assuming sources' is npins v6 >.<
  # https://github.com/andir/npins?tab=readme-ov-file#using-the-nixpkgs-fetchers
  sources = mapAttrs (k: v: v {inherit pkgs;}) sources'';

  # check this out if you wanna see everything exported
  exportedPackages = import ./pkgs/overlays/exported.nix;
in
  fix (self: {
    overlays = {
      kurukurubar = final: prev: {inherit (self.packages) kurukurubar kurukurubar-unstable;};
    };

    packages = makeScope newScope (exportedPackages {
      inherit quickshell pkgs sources;
    });

    nixosModules = {
      kurukuruDM = {
        imports = [./nixosModules/exported/kurukuruDM.nix];
        nixpkgs.overlays = [self.overlays.kurukurubar];
      };
      lanzaboote = {
        imports = [(sources.lanzaboote + "/nix/modules/lanzaboote.nix")];
        boot.lanzaboote.package = self.packages.lanzaboote.tool;
      };
    };

    nixosConfigurations = let
      nixosSystem = import (nixpkgs + "/nixos/lib/eval-config.nix");
      overlays = attrValues {
        lix = import ./pkgs/overlays/lix.nix {lix = null;};
        internal = import ./pkgs/overlays/internal.nix;

        # for the people of the future,
        # if you don't understand why this was done,
        # just know I am a eval time racer
        # this saves 1.1 seconds of eval time
        internal' = final: prev:
          (exportedPackages {
            inherit sources;
            pkgs = prev;
          })
          final;
      };
      nixosHost = hostName:
        nixosSystem {
          system = null;
          specialArgs = {inherit sources;};
          modules = [
            {nixpkgs.overlays = overlays;}
            ./hosts/${hostName}/configuration.nix
            ./users/rexies.nix
            ./nixosModules
          ];
        };
    in {
      Persephone = nixosHost "Persephone";
      Seraphine = nixosHost "Seraphine";
      Aphrodite = nixosHost "Aphrodite";
    };
  })
