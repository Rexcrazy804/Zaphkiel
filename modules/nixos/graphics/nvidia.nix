{config, lib, ...}: {
  config = lib.mkIf config.graphicsModule.nvidia.enable {
    services.xserver.videoDrivers = ["nvidia"];

    hardware.nvidia = {
      modesetting.enable = true;
      dynamicBoost.enable = true;

      powerManagement = {
        enable = true;
        finegrained = true;
      };

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

        # may needa make these an option once I have more hosts
        amdgpuBusId = "PCI:6:0:0"; 
        nvidiaBusId = "PCI:1:0:0";
      };
    };
  };
}
