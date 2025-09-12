{
  self,
  pkgs,
  system,
  ...
}: {
  default = pkgs.mkShellNoCC {
    packages = [self.packages.${system}.default];
    shellHook = ''
      echo "Kokomi! <><"
    '';
  };
}
