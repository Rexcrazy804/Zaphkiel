{self, ...}: {
  formatter = self.lib.eachSystem ({pkgx, ...}: pkgx.irminsul);
}
