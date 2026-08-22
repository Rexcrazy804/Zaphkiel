{
  self,
  nixpkgs,
  ...
}: let
  inherit (nixpkgs.lib) filesystem callPackageWith;
in {
  packages = self.lib.eachSystem (system: let
    pkgs = self.lib.pkgsOf.${system};
  in
    filesystem.packagesFromDirectoryRecursive {
      inherit (pkgs) newScope;
      callPackage = callPackageWith (pkgs // self.packages.${system});
      directory = self.paths.pkgs;
    });
}
