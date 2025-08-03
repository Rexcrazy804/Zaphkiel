{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./user-configuration.nix
  ];

  networking.hostName = "Seraphine";
  time.timeZone = "Asia/Dubai";

  zaphkiel = {
    programs = {
      obs-studio.enable = false;
      steam.enable = false;
      hyprland.enable = true;
      keyd.enable = true;
    };
    graphics = {
      enable = true;
      intel.enable = true;
    };
    services = {
      enable = true;
      tailscale = {
        enable = true;
        exitNode.enable = true;
        exitNode.networkDevice = "wlp1s0";
      };
      openssh.enable = true;
      jellyfin.enable = true;
      # minecraft.enable = false;
    };
  };

  services.greetd = {
    enable = true;
    settings = let
      initial_session = let
        inherit (lib) pipe filter hasPrefix removePrefix readFile head;
        inherit (lib.filesystem) listFilesRecursive;
        inherit (lib.strings) splitString;
        inherit (config.services.displayManager.sessionData) desktops;

        command = pipe desktops [
          listFilesRecursive
          head
          readFile
          (splitString "\n")
          (filter (x: hasPrefix "Exec=" x))
          head
          (removePrefix "Exec=")
        ];
      in {
        inherit command;
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
  services.dnscrypt-proxy2.settings = {
    listen_addresses = [
      "100.112.116.17:53"
      "[fd7a:115c:a1e0::eb01:7412]:53"
      "127.0.0.1:53"
      "[::1]:53"
    ];
  };

  # tailscale
  age.secrets.tailAuth.file = ../../secrets/secret5.age;
  services.tailscale.authKeyFile = config.age.secrets.tailAuth.path;

  # generic
  programs = {
    kdeconnect = {
      enable = true;
      package = pkgs.kdePackages.kdeconnect-kde;
    };
  };
  programs.adb.enable = true;
  users.users.rexies.extraGroups = ["adbusers" "kvm"];
  services.fstrim.enable = true;

  # disabled autosuspend
  services.logind.lidSwitchExternalPower = "ignore";

  # minecraft server
  # services.minecraft-servers.servers.hollyj.serverProperties.max-players = lib.mkForce 8;

  # Resolves wifi connectivity issues on Seraphine
  boot.extraModprobeConfig = lib.concatStringsSep "\n" [
    "options iwlwifi 11n_disable=1"
  ];

  system.stateVersion = "24.05";

  # maybe move this into its own module idk
  environment.systemPackages = [pkgs.firefoxpwa];
  programs.firefox = {
    enable = true;
    nativeMessagingHosts.packages = [
      pkgs.firefoxpwa
    ];
  };

  # temporarily setting it for Seraphine only
  networking.networkmanager.wifi.backend = "iwd";

  services.flatpak.enable = true;
  systemd.services.flatpak-repo = {
    wantedBy = ["multi-user.target"];
    path = [pkgs.flatpak];
    script = ''
      flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    '';
  };
}
