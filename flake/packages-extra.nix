{
  self,
  mnw,
  stash,
  hjem,
  ...
}: {
  packages = self.lib.eachSystem ({
    pkgs,
    system,
    pkgx,
  }: {
    xvim = pkgs.callPackage (self.paths.specials + /xvim) {
      inherit (pkgx) sources;
      mnw = mnw.lib;
    };
    hjem-cli = hjem.packages.${system}.hjem;
    stash = let
      stp = stash.packages.${system}.default;
    in
      pkgs.symlinkJoin {
        inherit (stp) meta version pname;
        paths = [stp];
        postBuild = ''
          rm $out/bin/wl-copy
          rm $out/bin/wl-paste
        '';
      };
  });
}
