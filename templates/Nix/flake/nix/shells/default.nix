{
  self,
  pkgs,
  ...
}: {
  default = pkgs.mkShellNoCC {
    packages = [self.packages.${pkgs.system}.default];
    shellHook = ''
      echo "Kokomi! <><"
    '';
  };
}
