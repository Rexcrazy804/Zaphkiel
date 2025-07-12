{
  pkgs,
  lib,
  config,
  ...
}: {
  options.zaphkiel.graphics.intel.enable = lib.mkEnableOption "intel graphics";
  config = lib.mkIf (config.zaphkiel.graphics.intel.enable && config.zaphkiel.graphics.enable) {
    # WARN too lazy to futher modularize this maybe re use nixos-hardware's module
    hardware.graphics.extraPackages = with pkgs; [
      intel-media-driver
      vpl-gpu-rt
      intel-vaapi-driver
      libvdpau-va-gl
      intel-ocl
    ];
    # environment.sessionVariables = {LIBVA_DRIVER_NAME = "iHD";}; # Force intel-media-driver
    # environment.sessionVariables = {LIBVA_DRIVER_NAME = "i965";}; # Force intel-vaapi-driver
  };
}
