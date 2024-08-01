{pkgs, config, lib, ...}: {
  # Enable OpenGL
  config = lib.mkIf config.graphics.amd.enable {
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
