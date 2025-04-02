{
  lib,
  pkgs,
  config,
  ...
}: {
  # don't resolve dns over dhcpd or networkmanager
  networking = {
    dhcpcd.extraConfig = "nohook resolv.conf";
    networkmanager.dns = lib.mkForce "none";
    nameservers = [
      "::1"
      "127.0.0.1"
    ];
  };

  services.dnscrypt-proxy2 = {
    enable = true;
    settings = {
      ipv4_servers = true;
      ipv6_servers = true;
      doh_servers = true;
      require_dnssec = true;

      forwarding_rules = pkgs.writeText "forwarding_rules.txt" ''
        ts.net 100.100.100.100
      '';

      cloaking_rules = pkgs.writeText "cloaking_rules.txt" ''
        mc.modded.maria.net 34.91.97.127
        mc.vanilla.maria.net 34.141.241.246

        seraphine fd7a:115c:a1e0::eb01:7412
        aphrodite fd7a:115c:a1e0::6e01:5604
        zaphkiel fd7a:115c:a1e0::5d01:ae12
        raphael fd7a:115c:a1e0::5801:e445

        bread fd7a:115c:a1e0::2d01:be72
        erza fd7a:115c:a1e0::b101:2875
        orion fd7a:115c:a1e0::2a01:6c27
        vortex fd7a:115c:a1e0::5801:637
      '';

      listen_addresses = [
        "127.0.0.1:53"
        "[::1]:53"
      ];

      sources.public-resolvers = {
        urls = [
          "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/public-resolvers.md"
          "https://download.dnscrypt.info/resolvers-list/v3/public-resolvers.md"
        ];
        cache_file = "/var/lib/dnscrypt-proxy/public-resolvers.md";
        minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
      };

      # You can choose a specific set of servers from https://github.com/DNSCrypt/dnscrypt-resolvers/blob/master/v3/public-resolvers.md
      server_names = [
        "cloudflare"
        "cloudflare-ipv6"
      ];
    };
  };
}
