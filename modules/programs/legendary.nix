{self, ...}: {
  dandelion.modules.legendary = {pkgs, ...}: {
    environment.systemPackages = [
      pkgs.heroic-unwrapped.legendary
      self.packages.${pkgs.stdenv.hostPlatform.system}.scripts.legumulaunch
    ];
  };
}
