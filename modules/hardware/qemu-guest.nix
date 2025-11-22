{
  dandelion.modules.qemu-guest = {modulesPath, ...}: {
    imports = [(modulesPath + "/profiles/qemu-guest.nix")];
  };
}
