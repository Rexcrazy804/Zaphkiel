{...}: {
  imports = [
    ../../modules/nixos
    ./hardware-configuration.nix
    ../../users/rexies
  ];

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

  system.stateVersion = "23.11";
}
