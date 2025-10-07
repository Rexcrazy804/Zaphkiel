{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf getExe mkOption;
  inherit (lib.types) enum listOf package;

  cfg = config.zaphkiel.graphics.intel;
in {
  options.zaphkiel.graphics.intel = {
    enable = mkEnableOption "intel graphics";
    hwAccelDriver = mkOption {
      type = enum ["media-driver" "vaapi-driver"];
      default = "media-driver";
      description = "Hardware acceleration driver to use";
    };
    driverPackages = mkOption {
      readOnly = true;
      default =
        if cfg.hwAccelDriver == "media-driver"
        then [
          pkgs.intel-media-driver
          pkgs.libvdpau-va-gl
          pkgs.vpl-gpu-rt
        ]
        else [pkgs.intel-vaapi-driver];
      description = "readonly list of packages for selected driver";
    };
    runtimePackages = mkOption {
      type = listOf package;
      default = [
        pkgs.intel-compute-runtime
        pkgs.intel-ocl
      ];
      description = "list of runtime packages";
    };
  };

  config = mkIf (cfg.enable && config.zaphkiel.graphics.enable) {
    hardware.graphics.extraPackages = cfg.runtimePackages ++ cfg.driverPackages;

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
      LIBVA_DRIVER_NAME = mkIf (cfg.hwAccelDriver == "media-driver") "iHD";
    };
  };
}
