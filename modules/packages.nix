{
  self,
  nixpkgs,
  ...
}: let
  inherit (nixpkgs.lib) filesystem callPackageWith;
in {
  packages = self.lib.eachSystem ({
    pkgs,
    system,
  }:
    filesystem.packagesFromDirectoryRecursive {
      inherit (pkgs) newScope;
      callPackage = callPackageWith (pkgs // self.packages.${system});
      directory = self.paths.pkgs;
    });
}
