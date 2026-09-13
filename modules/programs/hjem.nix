{
  pkgs,
  lib,
  inputs,
  ...
}: {
  imports = [inputs.hjem.nixosModules.default];
  hjem.linker = lib.mkForce pkgs.smfh;
  hjem.specialArgs = {inherit inputs;};
}
