{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    servModule.tailscale = {
      enable = lib.mkEnableOption "Enable Tailscale Service";
      exitNode = {
        enable = lib.mkEnableOption "Enable use as exit node";
        networkDevice = lib.mkOption {
          default = "eth0";
          type = lib.types.str;
          description = ''
            the name of the network device to be used for exitNode Optimization script
          '';
        };
      };
    };
  };

  config = let
    cfg = config.servModule.tailscale;
  in
    lib.mkIf (cfg.enable && config.servModule.enable) {
      services.tailscale = {
        enable = true;
        openFirewall = true;
        useRoutingFeatures = "both";
        extraSetFlags = [
          "--advertise-exit-node"
          "--webclient"
          "--accept-dns=false"
        ];
      };

      # services.resolved.enable = true;

      # optimization for tailscale exitnode
      services = {
        networkd-dispatcher = lib.mkIf cfg.exitNode.enable {
          enable = true;
          rules."50-tailscale" = {
            onState = ["routable"];
            script = ''
              ${lib.getExe pkgs.ethtool} -K ${cfg.exitNode.networkDevice} rx-udp-gro-forwarding on rx-gro-list off
            '';
          };
        };
      };

      # don't wait for this stupid thing to be done executing
      # i.e. when no wifi, system doesn't hang 3 minutes for this crap
      systemd.services.tailscaled-autoconnect.serviceConfig.Type = lib.mkForce "exec";
    };
}
