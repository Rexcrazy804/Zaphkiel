{self, ...}: {
  dandelion.hosts.Seraphine = {
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

      self.dandelion.modules.intel
      self.dandelion.modules.cups
      self.dandelion.modules.caddy
      self.dandelion.modules.jellyfin
      self.dandelion.modules.getty-autostart
    ];

    # info
    system.stateVersion = "24.05";
    networking.hostName = "Seraphine";
    time.timeZone = "Asia/Dubai";
    nixpkgs.hostPlatform = "x86_64-linux";

    # zaphkiel opts
    zaphkiel = {
      data.wallpaper = self.packages.${pkgs.system}.images.corvus;
      secrets = {
        tailAuth.file = self.paths.secrets + /secret5.age;
        caddyEnv.file = self.paths.secrets + /secret10.age;
      };
      programs = {
        privoxy.forwards = [{domains = [".donmai.us" ".yande.re" "www.zerochan.net"];}];
        shpool.users = ["rexies"];
      };
      graphics.intel.hwAccelDriver = "media-driver";
      services = {
        caddy = {
          secretsFile = config.age.secrets.caddyEnv.path;
          tsplugin.enable = true;
        };
        tailscale = {
          operator = "rexies";
          authFile = config.age.secrets.tailAuth.path;
        };
      };
    };

    # user stuff
    users.users."rexies".packages = [self.packages.${pkgs.system}.mpv-wrapped];

    # hardware
    boot.kernelParams = ["i915.enable_guc=2"];
    boot.initrd.availableKernelModules = ["xhci_pci" "ahci" "usb_storage" "sd_mod" "rtsx_pci_sdmmc"];

    # probably not required, but leaving it in for now
    services.fstrim.enable = true;
    # disabled autosuspend
    services.logind.settings.Login.HandleLidSwitchExternalPower = "ignore";
    # temporarily setting it for Seraphine only
    networking.networkmanager.wifi.backend = "iwd";
    # Resolves wifi connectivity issues on Seraphine
    boot.extraModprobeConfig = "options iwlwifi 11n_disable=1";

    fileSystems = {
      "/" = {
        device = "/dev/disk/by-uuid/cd29f1f1-5adc-41dd-b13a-2ec03704fb9f";
        fsType = "ext4";
        options = ["discard"];
      };
      "/boot" = {
        device = "/dev/disk/by-uuid/9972-2440";
        fsType = "vfat";
        options = ["fmask=0077" "dmask=0077"];
      };
    };

    swapDevices = [
      {device = "/dev/disk/by-uuid/abf01339-e9eb-4179-b5ef-91ef6f35af24";}
    ];
  };
}
