{
  dandelion.modules.nvidia = {
    pkgs,
    config,
    lib,
    ...
  }: {
    options.zaphkiel.graphics.nvidia = {
      hybrid = {
        enable = lib.mkEnableOption "optimus prime";
        igpu = {
          vendor = lib.mkOption {
            type = lib.types.enum ["amd" "intel"];
            default = "amd";
          };
          port = lib.mkOption {
            default = "";
            description = "Bus Port of igpu";
          };
        };
        dgpu.port = lib.mkOption {
          default = "";
          description = "Bus Port of dgpu";
        };
      };
    };

    config = let
      cfg = config.zaphkiel.graphics.nvidia;
    in {
      nix.settings = {
        extra-substituters = [
          "https://cuda-maintainers.cachix.org"
          "https://aseipp-nix-cache.global.ssl.fastly.net"
        ];
        extra-trusted-public-keys = [
          "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
        ];
      };
      services.xserver.videoDrivers = ["nvidia"];
      environment.systemPackages = [pkgs.zenith-nvidia];

      hardware.nvidia = {
        modesetting.enable = true;
        dynamicBoost.enable = true;

        powerManagement = {
          enable = true;
          finegrained = cfg.hybrid.enable;
        };

        # Use the NVidia open source kernel module (not to be confused with the
        # independent third-party "nouveau" open source driver).
        open = true;

        nvidiaSettings = true;
        package = config.boot.kernelPackages.nvidiaPackages.latest;

        prime = lib.mkIf cfg.hybrid.enable {
          offload = {
            enable = true;
            enableOffloadCmd = true;
          };

          amdgpuBusId = lib.mkIf (cfg.hybrid.igpu.vendor == "amd") cfg.hybrid.igpu.port;
          intelBusId = lib.mkIf (cfg.hybrid.igpu.vendor == "intel") cfg.hybrid.igpu.port;
          nvidiaBusId = cfg.hybrid.dgpu.port;
        };
      };
    };
  };
}
