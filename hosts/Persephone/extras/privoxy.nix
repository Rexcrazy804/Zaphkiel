{...}: {
  # cucked way to bypass captive networks
  services.privoxy = {
    enable = true;
    settings = {
      listen-address = "127.0.0.1:8118";
      forward = let
        forwarding_domains = [
          "www.privoxy.org"
          ".donmai.us"
          "nyaa.si"
          "rule34.xxx"
          ".yande.re"
          "www.zerochan.net"
        ];
        proxy = "100.121.86.4:8888";
      in
        builtins.map (domain: "${domain} ${proxy}") forwarding_domains;
    };
  };
  networking.proxy.default = "127.0.0.1:8118";
}
