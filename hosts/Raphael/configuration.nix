{
  lib,
  pkgs,
  config,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  networking.hostName = "Raphael"; # Define your hostname.
  time.timeZone = "Asia/Kolkata";

  graphicsModule.intel.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Sway
  programs.sway.enable = true;
  security.polkit.enable = true;
  xdg.portal = {
    # enable = true; enabled by flatpak
    wlr.enable = true;
    xdgOpenUsePortal = true;
  };

  # flatpak
  services.flatpak.enable = true;
  xdg.portal.enable = true;

  #mysql
  services.mysql = {
    enable = false;
    package = pkgs.mariadb;
  };

  servModule = {
    enable = true;
    tailscale = {
      enable = true;
      exitNode.enable = true;
      exitNode.networkDevice = "wlp1s0";
    };
    immich.enable = false;
    openssh.enable = true;
  };

  # tailscale
  age.secrets.tailAuth.file = ../../secrets/secret3.age;
  services.tailscale.authKeyFile = config.age.secrets.tailAuth.path;

  programs.firefox.enable = true;
  programs.kdeconnect = {
    enable = true;
    package = pkgs.gnomeExtensions.gsconnect;
  };

  environment.systemPackages = with pkgs; [
    gnome-tweaks
  ];

  system.stateVersion = "24.05"; # Did you read the comment?
}
