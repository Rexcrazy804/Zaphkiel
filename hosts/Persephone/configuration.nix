{config, ...}: {
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
      mangowc.enable = true;
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
}
