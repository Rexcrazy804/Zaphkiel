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
    ../../nixosModules/exported/kurukuruDM.nix
    ./user-configuration.nix
    ./extras/privoxy.nix
  ];

  system.stateVersion = "24.11";
  networking.hostName = "Persephone";
  time.timeZone = "Asia/Dubai";

  zaphkiel = {
    graphics = {
      enable = true;
      intel.enable = true;
    };

    programs = {
      lanzaboote.enable = true;
      sddm-custom-theme.enable = false;
      obs-studio.enable = false;
      steam.enable = false;
      hyprland.enable = true;
      keyd.enable = true;
      firefox.enable = true;
      wine = {
        enable = true;
        ntsync.enable = true;
        wayland.enable = true;
        ge-proton.enable = true;
      };
    };

    services = {
      enable = true;
      tailscale = {
        enable = true;
        exitNode.enable = false;
      };
      openssh.enable = true;
    };
  };

  programs.kurukuruDM = let
    # lets me just read my uwsm env stuff for the env vars
    # largely just to set my cursor lol
    uwuToHypr = pkgs.runCommandLocal "quick" {} ''
      awk '/^export/ { split($2, ARR, "="); print "env = "ARR[1]","ARR[2]}' ${../../users/dots/uwsm/env} > $out
    '';
  in {
    enable = true;
    settings = {
      wallpaper = config.programs.matugen.wallpaper;
      colorsQML = config.programs.matugen.theme.files + "/quickshell-colors.qml";
      instantAuth = true;
      extraConfig = ''
        monitor = eDP-1, preferred, auto, 1.25
        # night light
        exec-once = fish -c 'set -l hour (date +%H); if test $hour -ge 17 || test $hour -le  7; systemctl --user start hyprsunset.service; end'
        source = ${uwuToHypr}
      '';
    };
  };

  # tailscale
  age.secrets.tailAuth.file = ../../secrets/secret9.age;
  services.tailscale.authKeyFile = config.age.secrets.tailAuth.path;

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
    autoStart = false;
    capSysAdmin = true;
    openFirewall = true;
  };

  # idk the service didn't show up and now it does too lazy to rebuild and test
  # if it was a delusion. If it works don't break it, amiright
  systemd.user.services.sunshine.wantedBy = mkForce (optional config.services.sunshine.autoStart "graphical-session.target");
}
