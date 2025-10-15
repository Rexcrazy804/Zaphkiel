{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [(modulesPath + "/installer/scan/not-detected.nix")];

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = ["i915.enable_guc=3" "nmi_watchdog=0"];
    initrd.availableKernelModules = ["xhci_pci" "thunderbolt" "ahci" "nvme" "usb_storage" "sd_mod" "sdhci_pci"];
    kernelModules = ["kvm-intel"];
    extraModulePackages = [];
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/492f31cf-5db4-4965-95f7-e4d590aa0c29";
      fsType = "btrfs";
      options = ["subvol=root" "compress=zstd"];
    };

    "/home" = {
      device = "/dev/disk/by-uuid/492f31cf-5db4-4965-95f7-e4d590aa0c29";
      fsType = "btrfs";
      options = ["subvol=home" "compress=zstd"];
    };

    "/nix" = {
      device = "/dev/disk/by-uuid/492f31cf-5db4-4965-95f7-e4d590aa0c29";
      fsType = "btrfs";
      options = ["subvol=nix" "compress=zstd" "noatime"];
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/7DFC-B6FB";
      fsType = "vfat";
      options = ["fmask=0077" "dmask=0077"];
    };

    "/run/media/rexies/Aphrodite" = {
      device = "rexies@aphrodite.fell-rigel.ts.net:/home/rexies";
      fsType = "sshfs";
      options = [
        "allow_other"
        "_netdev"
        "x-systemd.automount"
        "reconnect"
        "ServerAliveInterval=15"
        "IdentityFile=${config.users.users.rexies.home}/.ssh/id_ed25519"
      ];
    };

    "/run/media/rexies/Seraphine" = {
      device = "rexies@seraphine.fell-rigel.ts.net:/home/rexies";
      fsType = "sshfs";
      options = [
        "allow_other"
        "_netdev"
        "x-systemd.automount"
        "reconnect"
        "ServerAliveInterval=15"
        "IdentityFile=${config.users.users.rexies.home}/.ssh/id_ed25519"
      ];
    };
  };

  swapDevices = [
    {device = "/dev/disk/by-uuid/d329feee-a8a6-48f4-afb2-3375adff50a3";}
  ];

  zramSwap.enable = true;

  networking.useDHCP = lib.mkDefault true;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
