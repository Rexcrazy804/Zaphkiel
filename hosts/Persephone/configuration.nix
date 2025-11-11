{
  config,
  pkgs,
  lib,
  mein,
  ...
}: let
  inherit (lib) mkForce;
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
      intel = {
        enable = true;
        hwAccelDriver = "media-driver";
      };
    };

    programs = {
      # lanzaboote.enable = true;
      obs-studio.enable = false;
      steam.enable = false;
      mangowc.enable = true;
      keyd.enable = true;
      firefox.enable = true;
      kuruDM.enable = true;
      winboat.enable = true;
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
      shpool = {
        enable = true;
        users = ["rexies"];
      };
    };

    services = {
      enable = true;
      tailscale = {
        enable = true;
        operator = "rexies";
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
  services.dnscrypt-proxy.settings = {
    listen_addresses = [
      "100.110.70.18:53"
      "[fd7a:115c:a1e0::6a01:4614]:53"
      "127.0.0.1:53"
      "[::1]:53"
    ];
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

  security.tpm2 = {
    enable = true;
    pkcs11.enable = true;
    tctiEnvironment.enable = true;
  };
  users.users.rexies.extraGroups = ["tss"];

  powerManagement.powertop.enable = true;
  # multi-user.target shouldn't wait for powertop
  systemd.services.powertop.serviceConfig.Type = mkForce "exec";

  # network printing
  services.printing = {
    enable = true;
    browsed.enable = true;
  };

  # use mangowc as base for kurukuruDM
  services.greetd.settings.default_session.command = let
    cfg = config.programs.kurukuruDM;
  in let
    mangoConfDir = pkgs.linkFarmFromDrvs "mango" [
      (pkgs.writeShellScript "autostart.sh" ''
        ${cfg.finalOpts} ${cfg.package}/bin/kurukurubar && pkill mango
      '')
      (pkgs.writeText "config.conf" ''
        monitorrule=eDP-1,1,1,tile,0,1.25,0,0,1920,1080,60
        cursor_theme=Kokomi_Cursor
      '')
    ];
  in
    mkForce "env MANGOCONFIG=${mangoConfDir} ${mein.${pkgs.system}.mangowc}/bin/mango";
}
