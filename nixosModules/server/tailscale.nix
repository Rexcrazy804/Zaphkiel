{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkOption types mkIf optional mkForce getExe mkAliasOptionModule;
  cfg = config.zaphkiel.services.tailscale;
  # adapted from https://github.com/piyoki/nixos-config/blob/master/system/networking/udp-gro-forwarding.nix
  udp-grp-script = pkgs.writeShellScript "udp-gro-forwarding" ''
    set -eux
    ${getExe pkgs.ethtool} -K ${cfg.exitNode.networkDevice} rx-udp-gro-forwarding on rx-gro-list off;
  '';
in {
  imports = [
    (mkAliasOptionModule ["zaphkiel" "services" "tailscale" "authFile"] ["services" "tailscale" "authKeyFile"])
  ];
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
    systemd.services."udp-gro-forwarding" = mkIf (cfg.exitNode.enable) {
      before = ["tailscaled.service"];
      wantedBy = ["multi-user.target"];
      description = "UDP Gro Forwarding Service";
      serviceConfig = {
        ExecStart = "${udp-grp-script}";
        Type = "oneshot";
      };
    };
    systemd.services."tailscaled.service".wants = mkIf (cfg.exitNode.enable) ["udp-gro-forwarding.service"];

    # don't wait for this stupid thing to be done executing
    # i.e. when no wifi, system doesn't hang 3 minutes for this crap
    systemd.services.tailscaled-autoconnect.serviceConfig.Type = mkForce "exec";
  };
}
