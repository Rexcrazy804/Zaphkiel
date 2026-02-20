{
  self,
  nixpkgs,
  ...
}: let
  inherit (nixpkgs.lib) filesystem callPackageWith;
in {
  packages = self.lib.eachSystem ({
    pkgs,
    pkgx,
    ...
  }:
    filesystem.packagesFromDirectoryRecursive {
      inherit (pkgs) newScope;
      callPackage = callPackageWith (pkgs // pkgx);
      directory = self.paths.pkgs;
    });
}
