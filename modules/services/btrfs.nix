{self, ...}: {
  dandelion.modules.btrfs = {
    imports = [self.dandelion.modules.btrfs-snapshots];
    services.btrfs.autoScrub = {
      enable = true;
      interval = "monthly";
      fileSystems = ["/"];
    };
  };
}
