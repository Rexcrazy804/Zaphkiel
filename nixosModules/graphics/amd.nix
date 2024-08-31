{
  pkgs,
  config,
  lib,
  ...
}: {
  options = {
    graphicsModule = {
      amd.enable = lib.mkEnableOption "Enable amd graphics card";
    };
  };
  # Enable OpenGL
  config = lib.mkIf config.graphicsModule.amd.enable {
    environment.systemPackages = [pkgs.radeontop];
    hardware.graphics = {
      extraPackages = with pkgs; [
        amdvlk
        rocm-opencl-icd
        rocm-opencl-runtime
        vaapiVdpau
        libvdpau-va-gl
      ];

      extraPackages32 = with pkgs; [driversi686Linux.amdvlk];
    };

    services.xserver.videoDrivers = ["amdgpu"];

    # amd hip workaround
    systemd.tmpfiles.rules = [
      "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
    ];
  };
}
