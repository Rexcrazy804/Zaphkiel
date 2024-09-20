{
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  networking.hostName = "Raphael"; # Define your hostname.
  time.timeZone = "Asia/Kolkata";

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.desktopManager.xfce.enable = true;

  # flatpak
  services.flatpak.enable = true;
  xdg.portal.enable = true;

  # should improve how this work on the module level
  progModule = {
    sddm-custom-theme.enable = false;
  };
  services.displayManager.sddm.enable = lib.mkForce false;

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
