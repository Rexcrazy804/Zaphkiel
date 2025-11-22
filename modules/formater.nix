{self, ...}: {
  formatter = self.lib.eachSystem ({system, ...}: self.packages.${system}.irminsul);
}
