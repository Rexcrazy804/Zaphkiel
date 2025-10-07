{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf getExe mkOption;
  inherit (lib.types) enum;
  cfg = config.zaphkiel.graphics.intel;

  intel-media-driver = [
    pkgs.intel-media-driver
    pkgs.libvdpau-va-gl
    pkgs.vpl-gpu-rt
  ];

  runtimes = [
    pkgs.intel-compute-runtime
    pkgs.intel-ocl
  ];
in {
  options.zaphkiel.graphics.intel = {
    enable = mkEnableOption "intel graphics";
    hwAccelDriver = mkOption {
      type = enum ["media-driver" "vaapi-driver"];
      default = "media-driver";
      description = "Hardware acceleration driver to use";
      apply = x:
        if x == "media-driver"
        then intel-media-driver
        else [pkgs.intel-vaapi-driver];
    };
  };

  config = mkIf (cfg.enable && config.zaphkiel.graphics.enable) {
    hardware.graphics.extraPackages = runtimes ++ cfg.hwAccelDriver;

    # enables frame buffer compression
    boot.kernelParams = ["i915.enable_fbc=1"];

    # enables gpu usage statistic in btop
    security.wrappers.btop = {
      owner = "root";
      group = "root";
      source = getExe pkgs.btop;
      capabilities = "cap_perfmon+ep";
    };

    environment.sessionVariables = {
      # not supported yet
      # ANV_VIDEO_DECODE = 1;
      LIBVA_DRIVER_NAME = mkIf (cfg.hwAccelDriver == intel-media-driver) "iHD";
    };
  };
}
