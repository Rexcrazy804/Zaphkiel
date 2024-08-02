{...}: {
  imports = [./hardware-configuration.nix];

  networking.hostName = "Zaphkiel";

  graphicsModule = {
    amd.enable = true;
    nvidia = {
      enable = true;

      hybrid = {
        enable = true;
        igpu = {
          vendor = "amd";
          port = "PCI:6:0:0";
        };
        dgpu.port = "PCI:1:0:0";
      };
    };
  };

  progModule = {
    anime-games = {
      enable = true;
      cache.enable = true;
      impact.enable = false;
      rail.enable = true;
      zone.enable = true;
    };
    steam.enable = true;
    sddm-custom-theme.enable = true;
  };

  time.timeZone = "Asia/Kolkata";

  system.stateVersion = "23.11";
}
