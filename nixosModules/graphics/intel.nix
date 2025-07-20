{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkPackageOption getExe;
  cfg = config.zaphkiel.graphics.intel;
in {
  options.zaphkiel.graphics.intel = {
    enable = mkEnableOption "intel graphics";
    intelQSVprovider = mkPackageOption pkgs "QSV provider" {
      default = "intel-media-driver";
    };
  };
  config = mkIf (cfg.enable && config.zaphkiel.graphics.enable) {
    hardware.graphics.extraPackages = [
      cfg.intelQSVprovider
      pkgs.intel-vaapi-driver
      pkgs.libvdpau-va-gl
      pkgs.intel-ocl
    ];
    # environment.sessionVariables = {LIBVA_DRIVER_NAME = "iHD";}; # Force intel-media-driver
    # environment.sessionVariables = {LIBVA_DRIVER_NAME = "i965";}; # Force intel-vaapi-driver

    security.wrappers.btop = {
      owner = "root";
      group = "root";
      source = getExe pkgs.btop;
      capabilities = "cap_perfmon+ep";
    };
  };
}
