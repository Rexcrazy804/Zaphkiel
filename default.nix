# you may leverage the following command to build systems using this
# sudo nixos-rebuild --no-reexec --file ./default.nix -A <hostName> <boot|test|switch|...>
# why am I mentioning this? well, others before me didn't and I spent weeks
# tryna fucking do this. Thanks to Quinz for all the npins repos he shared
let
  inherit (builtins) mapAttrs attrValues;
  inherit (pkgs.lib) makeOverridable makeExtensible lists;

  # https://github.com/andir/npins?tab=readme-ov-file#using-the-nixpkgs-fetchers
  src = import ./npins;
  pkgs = import src.nixpkgs {};
  sources = mapAttrs (k: v: v {inherit pkgs;}) src;

  overlays = attrValues {
    internal = import ./pkgs/overlays/internal.nix {sources = src;};
    lix = import ./pkgs/overlays/lix.nix {lix = null;};
    npins = import ./pkgs/overlays/npins.nix; # temporary
  };

  # here to remind me of the meaningless of the universe
  # and why I should play Nier:Automata again
  # modulesPath = src.nixpkgs + "/nixos/modules";
  # baseModules = builtins.map (path: modulesPath + "/" + path) (import ./baseModules.nix);

  evalConfig = import (src.nixpkgs + "/nixos/lib/eval-config.nix");
  nixosConfig = hostName:
    makeOverridable evalConfig {
      system = null;
      specialArgs = makeExtensible (final: {
        inherit sources;
        users = ["rexies"];
      });
      modules = [
        {nixpkgs.overlays = overlays;}
        ./hosts/${hostName}/configuration.nix
        ./users
        ./nixosModules
      ];
    };
in {
  Persephone = nixosConfig "Persephone";
  Seraphine = nixosConfig "Seraphine";

  Aphrodite = (nixosConfig "Aphrodite").override (old: {
    specialArgs = old.specialArgs.extend (_final: prev: {
      users = prev.users ++ ["sivanis"];
    });
    modules = (lists.remove ./nixosModules old.modules) ++ [./nixosModules/server-default.nix];
  });
}
