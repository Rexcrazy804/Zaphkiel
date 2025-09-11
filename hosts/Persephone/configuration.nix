{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkForce optional;
in {
  imports = [
    ./hardware-configuration.nix
    ./user-configuration.nix
  ];

  system.stateVersion = "25.05"; # Did you read the comment?
  networking.hostName = "Persephone";
  time.timeZone = "Asia/Dubai";

  zaphkiel = {
    secrets.tailAuth.file = ../../secrets/secret9.age;

    graphics = {
      enable = true;
      intel.enable = true;
    };

    programs = {
      # lanzaboote.enable = true;
      obs-studio.enable = false;
      steam.enable = false;
      hyprland.enable = true;
      keyd.enable = true;
      firefox.enable = true;
      kuruDM.enable = true;
      wine = {
        enable = true;
        ntsync.enable = true;
        wayland.enable = true;
        ge-proton.enable = true;
      };
      privoxy = {
        enable = true;
        forwards = [
          # I shouldn't be exposing myself like this
          {domains = ["www.privoxy.org" ".donmai.us" "rule34.xxx" ".yande.re" "www.zerochan.net" ".kemono.su" "hanime.tv"];}
        ];
      };
    };

    services = {
      enable = true;
      tailscale = {
        enable = true;
        exitNode.enable = false;
        authFile = config.age.secrets.tailAuth.path;
      };
      openssh.enable = true;
    };

    utils.btrfs-snapshots.rexies = [
      {
        subvolume = "Documents";
        calendar = "daily";
        expiry = "5d";
      }
      {
        subvolume = "Music";
        calendar = "weekly";
        expiry = "3w";
      }
      {
        subvolume = "Pictures";
        calendar = "weekly";
        expiry = "3w";
      }
    ];
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

  hardware.bluetooth.powerOnBoot = mkForce false;

  # btrfs
  services.btrfs.autoScrub = {
    enable = true;
    interval = "monthly";
    fileSystems = ["/"];
  };

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

  # disable network manager wait online service (+6 seconds to boot time!!!!)
  systemd.services.NetworkManager-wait-online.enable = false;

  services.sunshine = {
    enable = true;
    autoStart = false;
    capSysAdmin = true;
    openFirewall = true;
  };

  # idk the service didn't show up and now it does too lazy to rebuild and test
  # if it was a delusion. If it works don't break it, amiright
  systemd.user.services.sunshine.wantedBy = mkForce (optional config.services.sunshine.autoStart "graphical-session.target");

  security.tpm2 = {
    enable = true;
    pkcs11.enable = true;
    tctiEnvironment.enable = true;
  };
  users.users.rexies.extraGroups = ["tss"];
}
