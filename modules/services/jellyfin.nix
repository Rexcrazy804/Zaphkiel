# TODO modularize this further
{self, ...}: {
  dandelion.modules.jellyfin = {
    pkgs,
    lib,
    config,
    ...
  }: let
    multimediaDir = "/home/multimedia";
    caddyCfg = config.zaphkiel.services.caddy;

    inherit (lib) mkIf mkEnableOption;
    inherit (builtins) toString;
  in {
    options.zaphkiel.services.jellyfin.enable = mkEnableOption "jellyfin service";

    config = mkIf (config.zaphkiel.services.jellyfin.enable && config.zaphkiel.services.enable) {
      services.jellyfin = {
        enable = true;
        openFirewall = true;
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

      # caddy configuration
      services.caddy.virtualHosts = mkIf caddyCfg.tsplugin.enable {
        "https://jellyfin.fell-rigel.ts.net" = {
          extraConfig = ''
            bind tailscale/jellyfin
            reverse_proxy localhost:8096
          '';
        };
        "https://torrent.fell-rigel.ts.net" = {
          extraConfig = ''
            bind tailscale/torrent
            reverse_proxy localhost:${toString config.services.transmission.settings.rpc-port}
          '';
        };
        "https://sonarr.fell-rigel.ts.net" = {
          extraConfig = ''
            bind tailscale/sonarr
            reverse_proxy localhost:${toString config.services.sonarr.settings.server.port}
          '';
        };
      };

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
        file = self.paths.secrets + /secret6.age;
        name = "settings.json";
        owner = "transmission";
        group = "users";
      };
    };
  };
}
