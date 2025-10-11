{
  config,
  lib,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./user-configuration.nix
    ./extras/printing.nix
  ];

  system.stateVersion = "24.05";
  networking.hostName = "Seraphine";
  time.timeZone = "Asia/Dubai";

  zaphkiel = {
    secrets = {
      tailAuth.file = ../../secrets/secret5.age;
      caddyEnv.file = ../../secrets/secret10.age;
    };
    programs = {
      obs-studio.enable = false;
      steam.enable = false;
      hyprland.enable = true;
      keyd.enable = true;
      firefox.enable = true;
      privoxy = {
        enable = true;
        forwards = [{domains = [".donmai.us" ".yande.re" "www.zerochan.net"];}];
      };
    };
    graphics = {
      enable = true;
      intel = {
        enable = true;
        hwAccelDriver = "media-driver";
      };
    };
    services = {
      enable = true;
      caddy = {
        enable = true;
        secretsFile = config.age.secrets.caddyEnv.path;
        tsplugin.enable = true;
      };
      tailscale = {
        enable = true;
        exitNode.enable = true;
        exitNode.networkDevice = "wlan0";
        authFile = config.age.secrets.tailAuth.path;
      };
      openssh.enable = true;
      jellyfin.enable = true;
      # minecraft.enable = false;
    };
  };

  # required for intel-media-sdk
  nixpkgs.config.permittedInsecurePackages = ["intel-media-sdk-23.2.2"];

  services.greetd = {
    enable = true;
    settings = let
      initial_session = {
        command = "uwsm start default";
        user = "rexies";
      };
    in {
      inherit initial_session;
      default_session = initial_session;
    };
  };

  # forward dns onto the tailnet
  networking.firewall.allowedTCPPorts = [53];
  networking.firewall.allowedUDPPorts = [53];
  services.dnscrypt-proxy.settings = {
    listen_addresses = [
      "100.112.116.17:53"
      "[fd7a:115c:a1e0::eb01:7412]:53"
      "127.0.0.1:53"
      "[::1]:53"
    ];
  };

  programs.adb.enable = true;
  users.users.rexies.extraGroups = ["adbusers" "kvm"];
  services.fstrim.enable = true;

  # disabled autosuspend
  services.logind.settings.Login.HandleLidSwitchExternalPower = "ignore";

  # minecraft server
  # services.minecraft-servers.servers.hollyj.serverProperties.max-players = lib.mkForce 8;

  # Resolves wifi connectivity issues on Seraphine
  boot.extraModprobeConfig = lib.concatStringsSep "\n" [
    "options iwlwifi 11n_disable=1"
  ];

  # temporarily setting it for Seraphine only
  networking.networkmanager.wifi.backend = "iwd";
}
