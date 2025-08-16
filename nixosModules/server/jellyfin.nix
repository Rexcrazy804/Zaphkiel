{
  pkgs,
  lib,
  config,
  ...
}: let
  multimediaDir = "/home/multimedia";
  caddyCfg = config.zaphkiel.services.caddy;
in {
  options.zaphkiel.services.jellyfin.enable = lib.mkEnableOption "jellyfin service";

  config = lib.mkIf (config.zaphkiel.services.jellyfin.enable && config.zaphkiel.services.enable) {
    services.jellyfin = {
      enable = true;
      openFirewall = false;
    };

    services.caddy.virtualHosts."https://jellyfin.fell-rigel.ts.net" = lib.mkIf caddyCfg.tsplugin.enable {
      extraConfig = ''
        bind tailscale/jellyfin
        reverse_proxy localhost:8096
      '';
    };

    services.transmission = {
      enable = true;
      package = pkgs.transmission_4;
      group = "multimedia";

      openRPCPort = false;
      openPeerPorts = false;
      openFirewall = false;
      downloadDirPermissions = "770";
      webHome = null;

      settings = {
        umask = "007";
        rpc-bind-address = "127.0.0.1";
        anti-brute-force-enabled = true;
        rpc-authentication-required = true;
        # rpc-port = 8090:
        watch-dir-enabled = false;
        peer-port-random-low = 60000;
        peer-port-random-on-start = true;
        incomplete-dir-enabled = false;

        download-dir = multimediaDir + "/Downloads";
        peer-limit-global = 2000;
        peer-limit-per-torrent = 300;

        ratio-limit = 2.0;
        ratio-limit-enabled = false;

        alt-speed-time-enabled = true;
        alt-speed-time-begin = 420;
        alt-speed-time-end = 0;
        alt-speed-up = 200;
        alt-speed-down = 100000;
        upload-slots-per-torrent = 10;
      };
      credentialsFile = config.age.secrets.transJson.path;
    };

    services.sonarr = {
      enable = true;
      openFirewall = false;
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
      ++ config.zaphkiel.data.users;

    # Transmission configuration
    age.secrets.transJson = {
      file = ../../secrets/secret6.age;
      name = "settings.json";
      owner = "transmission";
      group = "users";
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
