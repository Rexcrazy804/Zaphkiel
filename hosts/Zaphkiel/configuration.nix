{inputs, ...}: {
  imports = [
    ./hardware-configuration.nix
    inputs.aagl.nixosModules.default
  ];

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
    steam.enable = true;
    sddm-custom-theme.enable = true;
  };

  # aagl stuff
  nix.settings = inputs.aagl.nixConfig;
  programs = {
    anime-game-launcher.enable = true;
    honkers-railway-launcher.enable = true;
    sleepy-launcher.enable = true;
  };

  time.timeZone = "Asia/Kolkata";

  system.stateVersion = "23.11";
}
