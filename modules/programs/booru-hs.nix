{booru-hs, ...}: {
  dandelion.modules.booru-hs = {pkgs, ...}: {
    environment.systemPackages = [
      booru-hs.packages.${pkgs.system}.default
    ];
  };
}
