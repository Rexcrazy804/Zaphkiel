{
  pkgs,
  config,
  lib,
  inputs,
  ...
}: let
  inherit (inputs.self) paths;
in {
  imports = [
    ../utils/zaphkiel-data.nix
    ../users/rexies.nix
    ../dots/rexies-cli.nix

    ../system/locales.nix

    ../programs/age.nix
    ../programs/hjem.nix
    ../programs/hjem-impure.nix
    ../programs/nix.nix
    ../programs/fish.nix
    ../programs/direnv.nix

    ../services/dnscrypt.nix
    ../services/tailscale.nix
    ../services/openssh.nix
    ../services/tinyproxy.nix
    ../services/fail2ban.nix

    ../hardware/qemu-guest.nix
  ];

  # info
  networking.hostName = "Aphrodite";
  networking.domain = "divinity.org";
  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "23.11";
  time.timeZone = "Asia/Kolkata";

  zaphkiel = {
    secrets.tailAuth.file = paths.secrets + /secret8.age;
    services.tailscale = {
      exitNode.enable = true;
      exitNode.networkDevice = "ens18";
      authFile = config.age.secrets.tailAuth.path;
    };
  };

  # network stuff
  services.openssh = {
    startWhenNeeded = lib.mkForce false;
    # TODO
    # openFirewall = lib.mkForce false;
  };

  networking = {
    interfaces = {
      ens18.ipv4.addresses = [
        {
          address = "103.160.145.75";
          prefixLength = 24;
        }
      ];
    };

    defaultGateway = {
      address = "103.160.144.1";
      interface = "ens18";
    };
  };

  networking = {
    nftables.enable = true;
    firewall.interfaces."tailscale0".allowedTCPPorts =
      config.services.openssh.ports
      # radicle internal and exposed ports
      ++ [config.services.radicle.node.listenPort 10000];
  };

  environment.systemPackages = with pkgs; [
    git
    jujutsu
  ];

  # hardware

  boot = {
    loader.grub.enable = true;
    loader.grub.device = "/dev/sda"; # or "nodev" for efi only
    tmp.cleanOnBoot = true;
    initrd.availableKernelModules = ["ata_piix" "uhci_hcd" "virtio_pci" "virtio_scsi" "sd_mod" "sr_mod"];
    initrd.kernelModules = [];
    kernelModules = [];
    extraModulePackages = [];
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/0f3acd6d-7bcf-4ca6-b34d-c9103faeea6a";
      fsType = "btrfs";
      options = ["subvol=root" "compress=zstd"];
    };

    "/home" = {
      device = "/dev/disk/by-uuid/0f3acd6d-7bcf-4ca6-b34d-c9103faeea6a";
      fsType = "btrfs";
      options = ["subvol=home" "compress=zstd"];
    };

    "/nix" = {
      device = "/dev/disk/by-uuid/0f3acd6d-7bcf-4ca6-b34d-c9103faeea6a";
      fsType = "btrfs";
      options = ["subvol=nix" "compress=zstd" "noatime"];
    };

    "/swap" = {
      device = "/dev/disk/by-uuid/0f3acd6d-7bcf-4ca6-b34d-c9103faeea6a";
      fsType = "btrfs";
      options = ["subvol=swap" "noatime"];
    };
  };

  swapDevices = [
    {
      device = "/swap/swapfile";
      size = 4 * 1024;
    }
  ];
}
