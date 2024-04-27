{
  config,
  pkgs,
  ...
}: {
  # Enable OpenGL
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;

    # setting for amd
    extraPackages = with pkgs; [
      amdvlk
      rocm-opencl-icd
      rocm-opencl-runtime
      vaapiVdpau
      libvdpau-va-gl
    ];
    extraPackages32 = with pkgs; [driversi686Linux.amdvlk];
  };

  services.xserver.videoDrivers = ["nvidia" "amdgpu"];

  hardware.nvidia = {
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead
    powerManagement.enable = false;

    # Fine-grained power management. Turns off GPU when not in use.
    powerManagement.finegrained = true;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    open = false;

    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;

    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
      amdgpuBusId = "PCI:6:0:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };
}
