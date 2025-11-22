{self, ...}: {
  dandelion.hosts.Aphrodite = {
    pkgs,
    config,
    lib,
    ...
  }: {
    imports = [
      self.dandelion.users.rexies
      self.dandelion.profiles.default
      self.dandelion.modules.tinyproxy
      self.dandelion.modules.fail2ban
    ];

    # info
    networking.hostName = "Aphrodite";
    networking.domain = "divinity.org";
    nixpkgs.hostPlatform = "x86_64-linux";
    system.stateVersion = "23.11";
    time.timeZone = "Asia/Kolkata";

    zaphkiel = {
      data.wallpaper = self.packages.${pkgs.system}.images.corvus;
      secrets.tailAuth.file = self.paths.secrets + /secret8.age;
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
    # forward dns onto the tailnet
    networking = {
      nftables.enable = true;
      firewall.interfaces."tailscale0" = {
        allowedTCPPorts = config.services.openssh.ports;
        allowedUDPPorts = [53];
      };
    };
    services.dnscrypt-proxy.settings = {
      listen_addresses = [
        "100.121.86.4:53"
        "[fd7a:115c:a1e0::6e01:5604]:53"
        "127.0.0.1:53"
        "[::1]:53"
      ];
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
  };
}
