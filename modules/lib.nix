{
  self,
  nixpkgs,
  systems,
  ...
}: let
  inherit (nixpkgs.lib) getAttrs mapAttrs;
in {
  lib = {
    pkgsFor = getAttrs (import systems) nixpkgs.legacyPackages;
    eachSystem = fn: mapAttrs (system: pkgs: fn {inherit system pkgs;}) self.lib.pkgsFor;
  };
}
