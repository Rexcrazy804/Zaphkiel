{
  inputs,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  networking.hostName = "Seraphine";
  time.timeZone = "Asia/Kolkata";

  graphicsModule = {
    intel.enable = true;
  };

  servModule = {
    enable = true;
    tailscale = {
      enable = false;
      exitNode.enable = true;
      exitNode.networkDevice = "wlp1s0";
    };
    openssh.enable = true;
  };

  age.secrets.wallpaper = {
    file = ../../secrets/media_robin.age;
    name = "wallpaper.jpg";
    mode = "644";
  };

  progModule = {
    sddm-custom-theme = {
      enable = true;
      wallpaper = config.age.secrets.wallpaper.path;
    };
    # anime-games.enable = true;
  };

  # generic
  programs = {
    partition-manager.enable = true;
    kdeconnect.enable = true;
  };

  # KDE
  services.desktopManager.plasma6.enable = true;
  services.fstrim.enable = true;

  # tailscale
  # age.secrets.tailAuth.file = ../../secrets/secret2.age;
  # services.tailscale.authKeyFile = config.age.secrets.tailAuth.path;

  system.stateVersion = "24.05";
}
