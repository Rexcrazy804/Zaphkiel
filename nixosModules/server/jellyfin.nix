{
  pkgs,
  users,
  lib,
  config,
  ...
}: let
  multimediaDir = "/home/multimedia";
  stateDirectory = "/var/lib/tailscale/tailscaled-jellyfin";
in {
  options = {
    servModule.jellyfin = {
      enable = lib.mkEnableOption "Enable Jellyfin and related Services";
    };
  };

  config = lib.mkIf (config.servModule.jellyfin.enable && config.servModule.enable) {
    services.jellyfin = {
      enable = true;
      openFirewall = true;
    };

    services.transmission = {
      enable = true;
      package = pkgs.transmission_4;

      openRPCPort = true;
      openPeerPorts = true;
      openFirewall = true;

      settings = {
        rpc-bind-address = "0.0.0.0";
        anti-brute-force-enabled = true;
        rpc-authentication-required = true;
        # rpc-port = 8090:
        watch-dir-enabled = false;
        peer-port-random-on-start = true;
        incomplete-dir-enabled = false;

        download-dir = multimediaDir + "/Downloads";
        peer-limit-global = 200;
        peer-limit-per-torrent = 100;
        ratio-limit = 2.0;
        ratio-limit-enabled = true;
      };
      credentialsFile = config.age.secrets.transJson.path;
    };

    services.sonarr = {
      enable = true;
      openFirewall = true;
    };

    # TODO remove this once sonarr is updated
    # required for sonarr
    nixpkgs.config.permittedInsecurePackages = [
      "dotnet-sdk-6.0.428"
      "aspnetcore-runtime-6.0.36"
    ];

    users.groups."multimedia".members =
      [
        "root"
        "jellyfin"
        "transmission"
        "sonarr"
      ]
      ++ users;

    # Transmission configuration
    age.secrets.transJson = {
      file = ../../secrets/secret6.age;
      name = "settings.json";
      owner = "transmission";
      group = "transmission";
    };

    # age.secrets.servarrAuth = {
    #   file = ../../secrets/secret7.age;
    # };

    # Figure out if I really need this :]
    # systemd.services.tailscale-jellyfin = {
    #   after = ["tailscaled.service"];
    #   wants = ["tailscaled.service"];
    #   wantedBy = [ "multi-user.target" ];
    #   serviceConfig = {
    #     Type = "simple";
    #   };
    #   script = ''
    #     ${pkgs.tailscale}/bin/tailscaled --statedir=${stateDirectory} --socket=${stateDirectory}/tailscaled.sock --port=0 --tun=user
    #   '';
    # };
    #
    # systemd.services.tailscale-jellyfin-up = {
    #   after = ["tailscale-jellyfin-up.service"];
    #   wants = ["tailscaled.service"];
    #   wantedBy = [ "multi-user.target" ];
    #   serviceConfig = {
    #     Type = "oneshot";
    #   };
    #   script = ''
    #     ${pkgs.tailscale}/bin/tailscale --socket=${stateDirectory}/tailscaled.sock up --auth-key=$(cat ${config.age.secrets.servarrAuth.path}) --hostname=jellyfin --reset
    #     ${pkgs.tailscale}/bin/tailscale --socket=${stateDirectory}/tailscaled.sock serve --bg localhost:8096
    #   '';
    # };
  };
}
