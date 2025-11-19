{
  self,
  mnw,
  stash,
  ...
}: {
  packages = self.lib.eachSystem ({
    pkgs,
    system,
  }: {
    xvim = pkgs.callPackage ../specials/xvim {
      inherit (self.packages.${system}) sources;
      mnw = mnw.lib;
    };
    stash = stash.packages.${system}.default;
  });
}
