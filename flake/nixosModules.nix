{self, ...}: {
  nixosModules = {
    kurukuruDM = {pkgs, ...}: {
      imports = [(self.paths.specials + /kurukuruDM.nix)];
      nixpkgs.overlays = [
        (_: _: {
          inherit (self.packages.${pkgs.stdenv.hostPlatform.system}) kurukurubar;
        })
      ];
    };

    default = self.nixosModules.kurukuruDM;
  };
}
