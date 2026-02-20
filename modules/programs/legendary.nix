{self, ...}: {
  dandelion.modules.legendary = {pkgs, ...}: {
    environment.systemPackages = [
      pkgs.heroic-unwrapped.legendary
      (self.lib.mkPkgx' pkgs).scripts.legumulaunch
    ];
  };
}
