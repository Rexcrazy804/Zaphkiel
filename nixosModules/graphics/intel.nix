{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf getExe mkPackageOption;
  cfg = config.zaphkiel.graphics.intel;
in {
  options.zaphkiel.graphics.intel = {
    enable = mkEnableOption "intel graphics";
    qsvDriver = mkPackageOption pkgs "intel QSV driver" {
      default = pkgs.intel-media-sdk;
      example = pkgs.vpl-gpu-rt;
    };
  };
  config = mkIf (cfg.enable && config.zaphkiel.graphics.enable) {
    # TODO remove this once media sdk is updated
    # required for intel-media-sdk,
    # due to
    nixpkgs.config.permittedInsecurePackages = ["intel-media-sdk-23.2.2"];

    boot.kernelParams = ["i915.enable_fbc=1"];

    hardware.graphics.extraPackages = [
      # base for hardware acceleration
      pkgs.intel-media-driver
      pkgs.libvdpau-va-gl
      # supporting run times
      pkgs.intel-compute-runtime
      pkgs.intel-ocl
      cfg.qsvDriver
    ];

    security.wrappers.btop = {
      owner = "root";
      group = "root";
      source = getExe pkgs.btop;
      capabilities = "cap_perfmon+ep";
    };

    environment.sessionVariables = {
      # not supported yet
      # ANV_VIDEO_DECODE = 1;
      LIBVA_DRIVER_NAME = "iHD";
    };
  };
}
