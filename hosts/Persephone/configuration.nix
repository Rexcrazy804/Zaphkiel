{config, ...}: {
  zaphkiel = {
    graphics.intel.hwAccelDriver = "media-driver";

    programs = {
      # lanzaboote.enable = true;
      mangowc.enable = true;
      wine = {
        enable = true;
        ntsync.enable = true;
        wayland.enable = true;
        ge-proton.enable = true;
      };
      privoxy.forwards = [
        # I shouldn't be exposing myself like this
        {domains = ["www.privoxy.org" ".donmai.us" "rule34.xxx" ".yande.re" "www.zerochan.net" ".kemono.su" "hanime.tv"];}
      ];
      shpool.users = ["rexies"];
    };

    secrets.tailAuth.file = ../../secrets/secret9.age;
    services = {
      tailscale = {
        enable = true;
        operator = "rexies";
        exitNode.enable = false;
        authFile = config.age.secrets.tailAuth.path;
      };
      openssh.enable = true;
    };
  };
}
