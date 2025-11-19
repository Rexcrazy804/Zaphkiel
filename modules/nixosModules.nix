{self, ...}: {
  nixosModules = {
    kurukuruDM = {pkgs, ...}: {
      imports = [../specials/kurukuruDM.nix];
      nixpkgs.overlays = [
        (_: _: {
          inherit (self.packages.${pkgs.system}) kurukurubar;
        })
      ];
    };

    default = self.nixosModules.kurukuruDM;
  };
}
