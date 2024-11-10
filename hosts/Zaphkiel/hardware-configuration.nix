# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{
  config,
  pkgs,
  lib,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;

    initrd = {
      availableKernelModules = ["nvme" "xhci_pci" "usb_storage" "usbhid" "sd_mod" "sdhci_pci"];
      kernelModules = ["amdgpu"];
    };

    # blacklisted to prefer zenpower
    blacklistedKernelModules = ["k10temp"];
    kernelModules = ["kvm-amd" "zenpower"];
    extraModulePackages = with config.boot.kernelPackages; [lenovo-legion-module zenpower];

    kernelParams = ["amd_pstate=active"];
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/bdb9ae6f-e3e3-4e3e-80c6-b5a51be7c293";
      fsType = "ext4";
      options = ["discard"];
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/91DB-2206";
      fsType = "vfat";
      options = ["fmask=0022" "dmask=0022"];
    };

    "/run/media/rexies/subzero" = {
      device = "/dev/disk/by-uuid/c97eafca-0e24-4969-99f9-7ee03516a90f";
      fsType = "btrfs";
      options = ["compress=zstd"];
    };
  };

  swapDevices = [
    {device = "/dev/disk/by-uuid/9190de7d-02b9-4f07-8dce-d15f0c63d3d5";}
  ];

  zramSwap = {
    enable = true;
    memoryPercent = 25;
  };

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  # specialization for battery life
  specialisation = {
    integrated.configuration = {
      system.nixos.tags = ["integrated"];
      graphicsModule.nvidia.enable = lib.mkForce false;
      servModule.enable = lib.mkForce false;
      boot.extraModprobeConfig = ''
        blacklist nouveau
        options nouveau modeset=0
      '';

      services.udev.extraRules = ''
        # Remove NVIDIA USB xHCI Host Controller devices, if present
        ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x0c0330", ATTR{power/control}="auto", ATTR{remove}="1"
        # Remove NVIDIA USB Type-C UCSI devices, if present
        ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x0c8000", ATTR{power/control}="auto", ATTR{remove}="1"
        # Remove NVIDIA Audio devices, if present
        ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x040300", ATTR{power/control}="auto", ATTR{remove}="1"
        # Remove NVIDIA VGA/3D controller devices
        ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x03[0-9]*", ATTR{power/control}="auto", ATTR{remove}="1"
      '';
      boot.blacklistedKernelModules = ["nouveau" "nvidia" "nvidia_drm" "nvidia_modeset"];
      boot.kernelParams = ["acpi_backlight=native"];
    };
  };
}
