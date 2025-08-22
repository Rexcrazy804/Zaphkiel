{
  services.tinyproxy = {
    enable = true;
    settings = {
      Port = 8888;
      Listen = "100.121.86.4";
      Timeout = 600;
      Allow = [
        "100.112.116.17" # Seraphine
        "100.65.1.15" # Persephone (New)
      ];
    };
  };

  networking.firewall.interfaces."tailscale0".allowedTCPPorts = [8888];
  systemd.services.tinyproxy.serviceConfig.RestartSec = 30;
}
