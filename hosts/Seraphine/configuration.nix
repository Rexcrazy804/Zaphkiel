{
  config,
  pkgs,
  lib,
  ...
}: {
  _module.args.users = ["rexies"];
  imports = [
    ./hardware-configuration.nix
    ./user-configuration.nix
    ../../nixosModules
    ../../users/rexies.nix
  ];

  networking.hostName = "Seraphine";
  time.timeZone = "Asia/Dubai";

  graphicsModule = {
    intel.enable = true;
  };

  servModule = {
    enable = true;
    tailscale = {
      enable = true;
      exitNode.enable = true;
      exitNode.networkDevice = "wlp1s0";
    };
    openssh.enable = true;
    jellyfin.enable = true;
    minecraft.enable = false;
  };

  progModule = {
    sddm-custom-theme.enable = true;
    direnv.enable = true;
    obs-studio.enable = false;
    steam.enable = true;
    hyprland.enable = true;
    keyd.enable = true;
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
  services.displayManager.autoLogin.user = "rexies";
  services.displayManager.defaultSession = "hyprland-uwsm";
  services.fstrim.enable = true;

  # disabled autosuspend
  services.logind.lidSwitchExternalPower = "ignore";

  # minecraft server
  services.minecraft-servers.servers.hollyj.serverProperties.max-players = lib.mkForce 8;

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
