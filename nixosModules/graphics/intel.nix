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
      # LIBVA_DRIVER_NAME=iHD
      intel-media-driver 
      # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
      (intel-vaapi-driver.override {
        enableHybridCodec = true;
      }) 
      libvdpau-va-gl
      intel-ocl
    ];
    environment.sessionVariables = {LIBVA_DRIVER_NAME = "iHD";}; # Force intel-media-driver
    # environment.sessionVariables = {LIBVA_DRIVER_NAME = "i965";}; # Force intel-vaapi-driver
  };
}
