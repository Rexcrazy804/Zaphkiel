# you may leverage the following command to build systems using this
# sudo nixos-rebuild --no-reexec --file ./default.nix -A <hostName> <boot|test|switch|...>
let
  inherit (builtins) mapAttrs;
  sources = import ./npins;
  pkgs = import sources.nixpkgs {};
  lazysources = mapAttrs (k: v: v {inherit pkgs;}) sources;
  nixosConfig = import (sources.nixpkgs + "/nixos/lib/eval-config.nix");
  overlays = builtins.attrValues {
    internal = import ./pkgs/overlays/internal.nix {inherit sources;};
    lix = import ./pkgs/overlays/lix.nix {lix = null;};
    # temporary
    npins = import ./pkgs/overlays/npins.nix;
  };
in {
  Persephone = nixosConfig {
    system = null;
    specialArgs = {
      sources = lazysources;
      users = ["rexies"];
    };

    modules = [
      {nixpkgs.overlays = overlays;}
      ./hosts/Persephone/configuration.nix
      ./nixosModules
      ./users
    ];
  };

  Seraphine = nixosConfig {
    specialArgs = {
      sources = lazysources;
      users = ["rexies"];
    };
    modules = [
      {nixpkgs.overlays = overlays;}
      ./hosts/Seraphine/configuration.nix
      ./nixosModules
      ./users
    ];
  };

  Aphrodite = nixosConfig {
    specialArgs = {
      sources = lazysources;
      users = ["rexies" "sivanis"];
    };
    modules = [
      {nixpkgs.overlays = overlays;}
      ./hosts/Aphrodite/configuration.nix
      ./users
      ./nixosModules/server-default.nix
    ];
  };
}
