{
  dandelion.modules.boot = {pkgs, ...}: {
    boot = {
      kernelPackages = pkgs.linuxPackages_latest;
      loader.systemd-boot.enable = true;
      loader.efi.canTouchEfiVariables = true;
      supportedFilesystems = ["ntfs"];
      loader.timeout = 0;
    };
  };
}
