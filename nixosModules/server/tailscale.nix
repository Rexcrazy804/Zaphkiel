{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkOption types mkIf optional mkForce getExe;
  cfg = config.zaphkiel.services.tailscale;
in {
  options.zaphkiel.services.tailscale = {
    enable = mkEnableOption "Enable Tailscale Service";
    exitNode = {
      enable = mkEnableOption "Enable use as exit node";
      networkDevice = mkOption {
        default = "eth0";
        type = types.str;
        description = ''
          the name of the network device to be used for exitNode Optimization script
        '';
      };
    };
  };

  config = mkIf (cfg.enable && config.zaphkiel.services.enable) {
    services.tailscale = {
      enable = true;
      openFirewall = true;
      useRoutingFeatures = "both";
      extraSetFlags =
        [
          "--webclient"
          "--accept-dns=false"
        ]
        ++ optional cfg.exitNode.enable "--advertise-exit-node";
    };

    # services.resolved.enable = true;

    # optimization for tailscale exitnode
    services = {
      networkd-dispatcher = mkIf cfg.exitNode.enable {
        enable = true;
        rules."50-tailscale" = {
          onState = ["routable"];
          script = ''
            ${getExe pkgs.ethtool} -K ${cfg.exitNode.networkDevice} rx-udp-gro-forwarding on rx-gro-list off
          '';
        };
      };
    };

    # don't wait for this stupid thing to be done executing
    # i.e. when no wifi, system doesn't hang 3 minutes for this crap
    systemd.services.tailscaled-autoconnect.serviceConfig.Type = mkForce "exec";
  };
}
