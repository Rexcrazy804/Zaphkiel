{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    graphicsModule = {
      intel.enable = lib.mkEnableOption "Enable intel graphics card";
    };
  };

  config = lib.mkIf config.graphicsModule.intel.enable {
    # WARN too lazy to futher modularize this maybe re use nixos-hardware's module
    hardware.graphics.extraPackages = with pkgs; [
      # intel-media-driver # LIBVA_DRIVER_NAME=iHD
      intel-vaapi-driver # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
      libvdpau-va-gl
      intel-ocl
    ];
    # do I really need this?
    # hardware.graphics.extraPackages32 = with pkgs; [
    #   # intel-media-driver-32 # LIBVA_DRIVER_NAME=iHD
    #   driversi686Linux.intel-vaapi-driver # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
    # ];
    environment.sessionVariables = {LIBVA_DRIVER_NAME = "iHD";}; # Force intel-media-driver
  };
}
