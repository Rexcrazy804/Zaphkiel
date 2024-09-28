{pkgs, lib, config, ...}: {
  options = {
    graphicsModule = {
      intel.enable = lib.mkEnableOption "Enable intel graphics card";
    };
  };

  config = lib.mkIf config.graphicsModule.intel.enable {
    hardware.graphics.extraPackages = with pkgs; [
      intel-media-driver # LIBVA_DRIVER_NAME=iHD
      intel-vaapi-driver # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
      libvdpau-va-gl
    ];
    environment.sessionVariables = { LIBVA_DRIVER_NAME = "iHD"; }; # Force intel-media-driver
  };
}
