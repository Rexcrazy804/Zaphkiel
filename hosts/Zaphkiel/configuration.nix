{...}: {
  imports = [./hardware-configuration.nix];

  networking.hostName = "Zaphkiel";

  graphicsModule = {
    amd.enable = true;
    nvidia.enable = true;
  };

  progModule = {
    anime-games.enable = true;
    steam.enable = true;
    sddm-custom-theme.enable = true;
  };

  time.timeZone = "Asia/Kolkata";

  system.stateVersion = "23.11";
}
