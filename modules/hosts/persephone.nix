{self, ...}: {
  dandelion.hosts.Persephone = {lib, ...}: {
    imports = [
      self.dandelion.users.rexies
      self.dandelion.hardware.persephone
      self.dandelion.modules.fingerprint
      self.dandelion.modules.btrfs
      self.dandelion.modules.sunshine
      self.dandelion.modules.tpm
      self.dandelion.modules.printing
      self.dandelion.modules.kuruDM-mango
      self.dandelion.modules.obs-studio
      self.dandelion.modules.steam
      self.dandelion.modules.winboat
      self.dandelion.modules.keyd
      self.dandelion.modules.firefox
    ];

    nixpkgs.hostPlatform = "x86_64-linux";
    system.stateVersion = "25.05";
    networking.hostName = "Persephone";
    time.timeZone = "Asia/Dubai";

    zaphkiel.utils.btrfs-snapshots.rexies = [
      {
        subvolume = "Documents";
        calendar = "daily";
        expiry = "5d";
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

    hardware.bluetooth.powerOnBoot = lib.mkForce false;
    powerManagement.powertop.enable = true;
    # multi-user.target shouldn't wait for powertop
    systemd.services.powertop.serviceConfig.Type = lib.mkForce "exec";
    # disable network manager wait online service (+6 seconds to boot time!!!!)
    systemd.services.NetworkManager-wait-online.enable = false;
  };
}
