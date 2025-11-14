{hjem, ...}: {
  dandelion.modules.hjem = {pkgs, ...}: {
    imports = [hjem.nixosModules.default];
    hjem.linker = pkgs.smfh;
  };
}
