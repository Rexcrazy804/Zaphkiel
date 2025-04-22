{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./user-configuration.nix
    ./extras/privoxy.nix
  ];

  system.stateVersion = "24.11"; # Did you read the comment?
  networking.hostName = "Persephone"; # Define your hostname.
  time.timeZone = "Asia/Dubai";

  graphicsModule = {
    intel.enable = true;
  };

  servModule = {
    enable = true;
    tailscale = {
      enable = true;
      exitNode.enable = true;
      exitNode.networkDevice = "wlp0s20f3";
    };
    openssh.enable = true;
    jellyfin.enable = false;
    minecraft.enable = false;
  };

  # tailscale
  age.secrets.tailAuth.file = ../../secrets/secret9.age;
  services.tailscale = {
    authKeyFile = config.age.secrets.tailAuth.path;
    # don't use Persephone as exit node
    extraSetFlags = lib.mkForce [
      "--webclient"
      "--accept-dns=false"
    ];
  };

  progModule = {
    sddm-custom-theme = {
      enable = true;
      wallpaper = config.age.secrets.wallpaper.path;
    };
    direnv.enable = true;
    obs-studio.enable = false;
    steam.enable = true;
    hyprland.enable = true;
    keyd.enable = true;
  };

  # forward dns onto the tailnet
  networking.firewall.allowedTCPPorts = [53];
  networking.firewall.allowedUDPPorts = [53];
  services.dnscrypt-proxy2.settings = {
    listen_addresses = [
      "100.110.70.18:53"
      "[fd7a:115c:a1e0::6a01:4614]:53"
      "127.0.0.1:53"
      "[::1]:53"
    ];
  };


  # sddm
  age.secrets.wallpaper = {
    file = ../../secrets/media_robin.age;
    name = "wallpaper.jpg";
    mode = "644";
  };

  # generic
  programs = {
    kdeconnect = {
      enable = true;
      package = pkgs.kdePackages.kdeconnect-kde;
    };
  };

  services.fstrim.enable = true;

  # maybe move this into its own module idk
  environment.systemPackages = [pkgs.firefoxpwa];
  programs.firefox = {
    enable = true;
    nativeMessagingHosts.packages = [
      pkgs.firefoxpwa
    ];
  };

  services.flatpak.enable = true;
  hardware.bluetooth.powerOnBoot = lib.mkForce false;

  # finger print
  systemd.services.fprintd = {
    wantedBy = ["multi-user.target"];
    serviceConfig.Type = "simple";
  };
  services.fprintd = {
    enable = true;
    tod.enable = true;
    tod.driver = pkgs.libfprint-2-tod1-elan;
  };
}
