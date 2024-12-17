{
  lib,
  pkgs,
  config,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  networking.hostName = "Vortex"; # Define your hostname.
  time.timeZone = "America/Regina";

  graphicsModule.intel.enable = true;

  graphicsModule = {
    amd.enable = true;
    nvidia = {
      # enable = true;

      # hybrid = {
      #   enable = true;
      #   igpu = {
      #     vendor = "amd";
      #     port = "PCI:5:0:0";
      #   };
      #   dgpu.port = "PCI:1:0:0";
      # };
    };
  };


  progModule = {
    steam.enable = true;
    sddm-custom-theme = {
      enable = true;
    };
    # anime-games.enable = true;
  };

  # generic
  programs = {
    partition-manager.enable = true;
    kdeconnect.enable = true;
    mosh.enable = true;
  };

  environment.systemPackages = with pkgs; [
    lenovo-legion
  ];

  # KDE
  services.desktopManager.plasma6.enable = true;
  services.xserver.enable = true;
  services.tailscale = {
    enable = true;
    openFirewall = true;
    useRoutingFeatures = "both";
  };

  services.resolved.enable = true;

  servModule = {
    enable = true;
    openssh.enable = true;
  };

  services.hardware.openrgb.enable = true;
  system.stateVersion = "24.11";
}
