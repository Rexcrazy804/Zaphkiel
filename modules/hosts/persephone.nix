{self, ...}: {
  dandelion.hosts.Persephone = {lib, ...}: {
    imports = let
      ms = self.dandelion.modules;
      us = self.dandelion.users;
    in [
      us.rexies
      ms.fingerprint
      ms.btrfs
      ms.sunshine
      ms.tpm
      ms.printing
      ms.kuruDM-mango
    ];

    system.stateVersion = "25.05"; # Did you read the comment?
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
