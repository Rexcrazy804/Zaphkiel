{
  dandelion.modules.tinyproxy = {config, ...}: let
    tsIPs = config.zaphkiel.data.tailscale;
  in {
    services.tinyproxy = {
      enable = true;
      settings = {
        Port = 8888;
        Listen = tsIPs.self.ipv4;
        Timeout = 600;
        Allow = [
          tsIPs.Seraphine.ipv4
          tsIPs.Persephone.ipv4
        ];
      };
    };

    networking.firewall.interfaces."tailscale0".allowedTCPPorts = [8888];
    systemd.services.tinyproxy.serviceConfig.RestartSec = 30;
  };
}
