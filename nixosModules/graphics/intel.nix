{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf getExe;
  cfg = config.zaphkiel.graphics.intel;
in {
  options.zaphkiel.graphics.intel = {
    enable = mkEnableOption "intel graphics";
  };
  config = mkIf (cfg.enable && config.zaphkiel.graphics.enable) {
    hardware.graphics.extraPackages = [
      pkgs.intel-media-driver
      pkgs.vpl-gpu-rt
      pkgs.intel-vaapi-driver
      pkgs.libvdpau-va-gl
      pkgs.intel-ocl
    ];

    security.wrappers.btop = {
      owner = "root";
      group = "root";
      source = getExe pkgs.btop;
      capabilities = "cap_perfmon+ep";
    };

    environment.sessionVariables.ANV_VIDEO_DECODE = 1;
  };
}
