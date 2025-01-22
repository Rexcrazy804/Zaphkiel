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

  services.dnscrypt-proxy2 = let
    forwarding-rules = pkgs.writeTextFile {
      name = "forwarding-rules.txt";
      text = ''
        ts.net 100.100.100.100
      '';
    };
  in {
    enable = true;
    settings = {
      ipv4_servers = true;
      ipv6_servers = true;
      doh_servers = true;
      require_dnssec = true;
      forwarding_rules = forwarding-rules;

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
        "cloudflare-security"
        "cloudflare-security-ipv6"
      ];
    };
  };
}
