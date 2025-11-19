{
  dandelion.modules.tailscale = {
    pkgs,
    lib,
    config,
    ...
  }: let
    inherit (lib) mkEnableOption mkOption mkIf mkAliasOptionModule mkForce;
    inherit (lib) optional getExe;
    inherit (lib.types) str enum nullOr;
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
      operator = mkOption {
        type = nullOr (enum config.zaphkiel.data.users);
        default = null;
        description = "User set as tailscale operator, helps with taildrop stuff";
      };
      exitNode = {
        enable = mkEnableOption "Enable use as exit node";
        networkDevice = mkOption {
          default = "eth0";
          type = str;
          description = ''
            the name of the network device to be used for exitNode Optimization script
          '';
        };
      };
    };

    config = {
      services.tailscale = {
        enable = true;
        openFirewall = true;
        useRoutingFeatures = "both";
        extraSetFlags =
          [
            "--webclient"
            "--accept-dns=false"
          ]
          ++ optional cfg.exitNode.enable "--advertise-exit-node"
          ++ optional (cfg.operator != null) "--operator=${cfg.operator}";
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
  };
}
