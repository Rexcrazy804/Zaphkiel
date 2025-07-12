{
  lib,
  config,
  ...
}: {
  imports = [
    ./bluetooth.nix
    ./dnsproxy2.nix
  ];

  config = lib.mkIf (!config.zaphkiel.data.headless) {
    networking = {
      nftables.enable = true;
      networkmanager = {
        enable = true;
        wifi = {
          powersave = false;
          macAddress = "random";
        };
      };

      firewall = {
        enable = true;
        allowedTCPPortRanges = [];
        allowedUDPPortRanges = [];
      };
    };
  };
}
