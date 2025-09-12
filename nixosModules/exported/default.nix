{
  self,
  lib,
  ...
}:
lib.fix (self': {
  kurukuruDM = {pkgs, ...}: {
    imports = [./kurukuruDM.nix];
    nixpkgs.overlays = [
      (final: prev: {
        inherit
          (self.packages.${pkgs.system})
          kurukurubar
          kurukurubar-unstable
          ;
      })
    ];
  };

  default = self'.kurukuruDM;
})
