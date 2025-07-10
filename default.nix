let
  inherit (builtins) mapAttrs;
  sources = import ./npins;
  lazysources = mapAttrs (k: v: v {inherit pkgs;}) sources;
  nixosConfig = import (sources.nixpkgs + "/nixos/lib/eval-config.nix");
  pkgs = import sources.nixpkgs {
    overlays = builtins.attrValues {
      internal = import ./pkgs/overlays/internal.nix {inherit sources;};
      lix = import ./pkgs/overlays/lix.nix {lix = null;};
      npins = import ./pkgs/overlays/npins.nix;
    };
    config.allowUnfree = true;
  };
in {
  Persephone = nixosConfig {
    inherit pkgs;
    system = null;
    specialArgs = {
      sources = lazysources;
      users = ["rexies"];
    };

    modules = [
      ./hosts/Persephone/configuration.nix
      ./nixosModules
      ./users
    ];
  };
}
