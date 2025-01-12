{
  inputs,
  config,
  pkgs,
  lib,
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
      enable = true;
      exitNode.enable = true;
      exitNode.networkDevice = "wlp1s0";
    };
    openssh.enable = true;
    jellyfin.enable = true;
    minecraft.enable = false;
  };

  progModule = {
    sddm-custom-theme = {
      enable = true;
      wallpaper = config.age.secrets.wallpaper.path;
    };
    # anime-games.enable = true;
  };

  # tailscale
  age.secrets.tailAuth.file = ../../secrets/secret5.age;
  services.tailscale.authKeyFile = config.age.secrets.tailAuth.path;
  # sddm
  age.secrets.wallpaper = {
    file = ../../secrets/media_robin.age;
    name = "wallpaper.jpg";
    mode = "644";
  };

  # generic
  programs = {
    partition-manager.enable = true;
    kdeconnect.enable = true;
  };

  # KDE
  services.desktopManager.plasma6.enable = true;
  services.fstrim.enable = true;

  # disabled autosuspend
  services.logind.lidSwitchExternalPower = "ignore";

  # minecraft server
  services.minecraft-servers.servers.hollyj.serverProperties.max-players = lib.mkForce 8;

  # Resolves wifi connectivity issues on Seraphine
  boot.extraModprobeConfig = lib.concatStringsSep "\n" [
    "options iwlwifi 11n_disable=1"
  ];

  system.stateVersion = "24.05";
}
