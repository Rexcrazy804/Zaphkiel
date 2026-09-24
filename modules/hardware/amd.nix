{pkgs, ...}: {
  environment.systemPackages = [pkgs.radeontop];
  hardware.graphics = {
    extraPackages = [
      pkgs.rocmPackages.clr.icd
      pkgs.vaapiVdpau
      pkgs.libvdpau-va-gl
    ];
  };

  services.xserver.videoDrivers = ["amdgpu"];

  # amd hip workaround
  systemd.tmpfiles.rules = [
    "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
  ];

  environment.sessionVariables.RADV_PERFTEST = "video_decode";
}
