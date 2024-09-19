{ lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  networking.hostName = "Raphael"; # Define your hostname.
  time.timeZone = "Asia/Kolkata";

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  progModule = {
    sddm-custom-theme.enable = false;
  };
  services.displayManager.sddm.enable = lib.mkForce false;

  programs.firefox.enable = true;
  system.stateVersion = "24.05"; # Did you read the comment?
}
