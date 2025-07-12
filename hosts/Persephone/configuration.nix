{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./user-configuration.nix
    ./extras/privoxy.nix
    ./extras/lanzaboote.nix
    ../../users/rexies.nix
    ../../nixosModules
  ];

  system.stateVersion = "24.11";
  networking.hostName = "Persephone";
  time.timeZone = "Asia/Dubai";

  graphicsModule = {
    intel.enable = true;
  };

  servModule = {
    enable = true;
    tailscale = {
      enable = true;
      exitNode.enable = true;
      exitNode.networkDevice = "wlp0s20f3";
    };
    openssh.enable = true;
    jellyfin.enable = false;
    minecraft.enable = false;
  };

  # tailscale
  age.secrets.tailAuth.file = ../../secrets/secret9.age;
  services.tailscale = {
    authKeyFile = config.age.secrets.tailAuth.path;
    # don't use Persephone as exit node
    extraSetFlags = lib.mkForce [
      "--webclient"
      "--accept-dns=false"
    ];
  };

  progModule = {
    sddm-custom-theme.enable = true;
    direnv.enable = true;
    obs-studio.enable = false;
    steam.enable = false;
    hyprland.enable = true;
    keyd.enable = true;
    firefox.enable = true;
  };

  # forward dns onto the tailnet
  networking.firewall.allowedTCPPorts = [53];
  networking.firewall.allowedUDPPorts = [53];
  services.dnscrypt-proxy2.settings = {
    listen_addresses = [
      "100.110.70.18:53"
      "[fd7a:115c:a1e0::6a01:4614]:53"
      "127.0.0.1:53"
      "[::1]:53"
    ];
  };

  # generic
  programs = {
    kdeconnect = {
      enable = true;
      package = pkgs.kdePackages.kdeconnect-kde;
    };
  };

  hardware.bluetooth.powerOnBoot = lib.mkForce false;

  # finger print
  systemd.services.fprintd = {
    wantedBy = ["multi-user.target"];
    serviceConfig.Type = "simple";
  };
  services.fprintd = {
    enable = true;
    tod.enable = true;
    tod.driver = pkgs.libfprint-2-tod1-elan;
  };

  virtualisation.podman = {
    enable = true;
    defaultNetwork.settings.dns_enabled = true;
  };
  users.users.rexies.extraGroups = ["podman"];

  # disable network manager wait online service (+6 seconds to boot time!!!!)
  systemd.services.NetworkManager-wait-online.enable = false;

  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true;
    openFirewall = true;
  };
}
