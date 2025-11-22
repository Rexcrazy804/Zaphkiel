{hjem, ...}: {
  dandelion.modules.hjem = {
    pkgs,
    lib,
    ...
  }: {
    imports = [hjem.nixosModules.default];
    hjem.linker = lib.mkForce pkgs.smfh;
  };
}
