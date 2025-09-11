{
  pkgs,
  lib,
  self,
  ...
}:
lib.fix (self': {
  general = pkgs.callPackage ./general.nix {
    inherit (self.packages.${pkgs.system}) irminsul;
  };
  default = self'.general;
})
