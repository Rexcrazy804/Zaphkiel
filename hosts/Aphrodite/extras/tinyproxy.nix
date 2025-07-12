{
  services.tinyproxy = {
    enable = true;
    settings = {
      Port = 8888;
      Listen = "100.121.86.4";
      Timeout = 600;
      Allow = [
        "100.110.70.18"
        "100.112.116.17"
      ];
    };
  };

  networking.firewall.interfaces."tailscale0".allowedTCPPorts = [8888];
  systemd.services.tinyproxy.serviceConfig.RestartSec = 30;
}
