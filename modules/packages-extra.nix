{
  nixpkgs,
  self,
  mnw,
  stash,
  ...
}: {
  packages = self.lib.eachSystem ({
    pkgs,
    system,
  }: let
    self' = self.packages.${system};
  in {
    xvim = pkgs.callPackage ../specials/xvim {
      mnw = mnw.lib;
      inherit (self') sources;
    };
    kurukurubar-unstable = nixpkgs.lib.warn "kurukurubar-unstable depricated, use kurukurubar" self'.kurukurubar;
    stash = stash.packages.${system}.default;
  });
}
