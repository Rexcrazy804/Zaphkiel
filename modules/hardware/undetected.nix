{
  dandelion.modules.undetected = {modulesPath, ...}: {
    imports = [(modulesPath + "/installer/scan/not-detected.nix")];
  };
}
