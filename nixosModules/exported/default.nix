{
  self,
  lib,
  ...
}:
lib.fix (self': {
  kurukuruDM = {pkgs, ...}: {
    imports = [./kurukuruDM.nix];
    nixpkgs.overlays = [
      (_: _: {
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
