{self, ...}: {
  dandelion.hosts.Persephone = {
    lib,
    pkgs,
    config,
    ...
  }: {
    imports = [
      self.dandelion.users.rexies
      self.dandelion.dots.rexies-cli
      self.dandelion.dots.rexies-gui
      self.dandelion.dots.rexies-mango

      self.dandelion.profiles.default
      self.dandelion.profiles.mangowc
      self.dandelion.profiles.workstation
      self.dandelion.profiles.gaming

      self.dandelion.modules.fingerprint
      self.dandelion.modules.btrfs
      self.dandelion.modules.tpm
      self.dandelion.modules.intel

      self.dandelion.modules.printing
      self.dandelion.modules.getty-autostart
      self.dandelion.modules.winboat
      self.dandelion.modules.booru-hs
      self.dandelion.modules.legendary
    ];

    # info
    networking.hostName = "Persephone";
    nixpkgs.hostPlatform = "x86_64-linux";
    system.stateVersion = "25.05";
    time.timeZone = "Asia/Dubai";

    # zaphkiel opts
    zaphkiel = {
      graphics.intel.hwAccelDriver = "media-driver";
      data.wallpaper = self.packages.${pkgs.stdenv.hostPlatform.system}.images.evernight;
      programs = {
        shpool.users = ["rexies"];
        privoxy.forwards = [
          # I shouldn't be exposing myself like this
          {domains = ["www.privoxy.org" ".donmai.us" "rule34.xxx" ".yande.re" "www.zerochan.net" ".kemono.su" "hanime.tv" "1337x.to"];}
        ];
      };

      secrets.tailAuth.file = self.paths.secrets + /secret9.age;
      services. tailscale = {
        operator = "rexies";
        exitNode.enable = false;
        authFile = config.age.secrets.tailAuth.path;
      };

      utils.btrfs-snapshots.rexies = [
        {
          subvolume = "Documents";
          calendar = "daily";
          expiry = "1d";
        }
        {
          subvolume = "Music";
          calendar = "weekly";
          expiry = "3w";
        }
        {
          subvolume = "Pictures";
          calendar = "weekly";
          expiry = "3w";
        }
      ];
    };

    # user space
    users.users."rexies".packages = [
      self.packages.${pkgs.stdenv.hostPlatform.system}.equibop
      pkgs.cemu
    ];

    hjem.users.rexies = {
      files.".face.icon".source = self.packages.${pkgs.stdenv.hostPlatform.system}.images.voyager-profile;
      # matugen.scheme = "scheme-fidelity";
      games = {
        enable = true;
        entries = [
          {
            name = "Reverse 1999";
            umu.game_id = "rev199";
            umu.exe = "/home/rexies/Games/Reverse1999en/reverse1999.exe";
          }
          {
            name = "FataMorgana";
            umu.game_id = "fatamorgana";
            umu.exe = "/home/rexies/Games/FataMorgana/FataMorgana.exe";
          }
          {
            name = "GTA Vice City";
            umu.game_id = "gtavc";
            umu.exe = "/home/rexies/Games/GTAVC/gta-vc.exe";
          }
          {
            name = "NFS Most Wanted";
            umu.game_id = "nfsmw";
            umu.exe = "/home/rexies/Games/Need for Speed(TM) Most Wanted/NFS13.exe";
          }
          {
            name = "NFS Rivals";
            umu.game_id = "nfsr";
            umu.exe = "/home/rexies/Games/NFSRIVALS/NFS14.exe";
          }
        ];
      };
    };

    # hardware
    boot.kernelParams = ["i915.enable_guc=3" "nmi_watchdog=0"];
    boot.initrd.availableKernelModules = ["xhci_pci" "thunderbolt" "ahci" "nvme" "usb_storage" "sd_mod" "sdhci_pci"];
    hardware.bluetooth.powerOnBoot = lib.mkForce false;
    systemd.services.NetworkManager-wait-online.enable = false;
    zramSwap.enable = true;

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
    swapDevices = [{device = "/dev/disk/by-uuid/d329feee-a8a6-48f4-afb2-3375adff50a3";}];
  };
}
