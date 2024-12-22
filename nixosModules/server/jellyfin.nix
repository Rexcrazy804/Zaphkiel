{
  pkgs,
  users,
  lib,
  config,
  ...
}: let
  multimediaDir = "/home/multimedia";
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
      openFirewall = true;

      settings = {
        anti-brute-force-enabled = true;
        rpc-authentication-required = true;
        watch-dir-enabled = false;
        peer-port-random-on-start = true;
        incomplete-dir-enabled = false;

        download-dir = multimediaDir + "/Downloads";
        peer-limit-global = 400;
        peer-limit-per-torrent = 200;
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
  };
}
