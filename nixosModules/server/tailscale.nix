{
  lib,
  config,
  ...
}: {
  options = {
    servModule.tailscale = {
      enable = lib.mkEnableOption "Enable Tailscale Service";
    };
  };

  config = lib.mkIf (config.servModule.tailscale.enable && config.servModule.enable) {
    services.tailscale = {
      enable = true;
      openFirewall = true;
      useRoutingFeatures = "both";
      extraSetFlags = [ 
        "--advertise-exit-node" 
        "--accept-dns"
        "--webclient"
      ];
    };

    services.resolved.enable = true;
  };
}
