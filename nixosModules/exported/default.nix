{
  self,
  lib,
  ...
}:
lib.fix (self': {
  kurukuruDM = attrs: {
    imports = [./kurukuruDM.nix];
    nixpkgs.overlays = [
      (final: prev: {
        inherit
          (self.packages.${attrs.pkgs.system})
          kurukurubar
          kurukurubar-unstable
          ;
      })
    ];
  };

  default = self'.kurukuruDM;
})
