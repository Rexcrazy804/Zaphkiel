{
  pkgs,
  lib,
  self,
  system,
  ...
}:
lib.fix (self': {
  general = pkgs.callPackage ./general.nix {
    inherit (self.packages.${system}) irminsul;
  };
  default = self'.general;
})
