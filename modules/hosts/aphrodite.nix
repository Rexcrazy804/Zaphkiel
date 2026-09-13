{
  config,
  lib,
  inputs,
  ...
}: let
  inherit (config.nixpkgs.hostPlatform) system;
  inherit (inputs.self.legacyPackages.${system}) images;
  inherit (inputs.self) paths;
in {
  imports = [
    ../users/rexies.nix
    ../dots/rexies-cli.nix

    ../profiles/default.nix

    ../hardware/qemu-guest.nix
    ../services/tinyproxy.nix
    ../services/fail2ban.nix
    ../services/radicle.nix
  ];

  # info
  networking.hostName = "Aphrodite";
  networking.domain = "divinity.org";
  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "23.11";
  time.timeZone = "Asia/Kolkata";

  zaphkiel = {
    data.wallpaper = images.corvus;
    secrets.tailAuth.file = paths.secrets + /secret8.age;
    services.tailscale = {
      exitNode.enable = true;
      exitNode.networkDevice = "ens18";
      authFile = config.age.secrets.tailAuth.path;
    };
    programs.shpool.users = ["rexies"];
  };

  # network stuff
  services.openssh = {
    startWhenNeeded = lib.mkForce false;
    openFirewall = lib.mkForce false;
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

  # radicle
  services.radicle = {
    publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHhkSRUQLV7JpjtPdbFR8vXnJhLhSfbh3vL+j9v/5Bv/";
    privateKey = "/etc/ssh/ssh_host_ed25519_key";
    settings.node = {
      alias = "radicle.aphrodite.ts.net";
      externalAddresses = ["aphrodite.fell-rigel.ts.net:8776" "aphrodite.fell-rigel.ts.net:10000"];
    };
  };

  # hardware
  boot.tmp.cleanOnBoot = true;
  boot.loader.grub.device = "/dev/sda";
  boot.initrd.availableKernelModules = ["ata_piix" "uhci_hcd" "xen_blkfront" "vmw_pvscsi"];
  boot.initrd.kernelModules = ["nvme"];
  fileSystems."/" = {
    device = "/dev/sda1";
    fsType = "ext4";
  };
}
