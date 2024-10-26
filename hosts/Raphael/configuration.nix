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

  graphicsModule.intel.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Sway
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    extraSessionCommands = /*bash*/ ''
      # SDL:
      export SDL_VIDEODRIVER=wayland
      # QT (needs qt5.qtwayland in systemPackages):
      export QT_QPA_PLATFORM=wayland-egl
      export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
      # Fix for some Java AWT applications (e.g. Android Studio),
      # use this if they aren't displayed properly:
      export _JAVA_AWT_WM_NONREPARENTING=1
      # SCREEN SHARING
      export MOZ_ENABLE_WAYLAND=1
    '';
  };
  security.polkit.enable = true;
  xdg.portal = {
    # enable = true; enabled by flat pack
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

  # should improve how this work on the module level
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
