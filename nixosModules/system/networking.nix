{pkgs, lib, ...}: {
  networking = {
    # DNS
    nameservers = [
      "1.1.1.1"
      "1.0.0.1"
      "2606:4700:4700::1111" 
      "2606:4700:4700::1001" 
    ];
    # don't resolve dns over dhcpd or networkmanager
    dhcpcd.extraConfig = "nohook resolv.conf";
    networkmanager.dns = lib.mkForce "none";

    nftables.enable = true;
    networkmanager = {
      enable = true;
      wifi = {
        powersave = false;
        macAddress = "random";
      };
    };

    firewall = {
      enable = true;
      allowedTCPPortRanges = [];
      allowedUDPPortRanges = [];
    };
  };

  # Bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings.General.Experimental = true;
  };
  systemd.user.services.mpris-proxy = {
    description = "Mpris proxy";
    after = ["network.target" "sound.target"];
    wantedBy = ["default.target"];
    serviceConfig.ExecStart = "${pkgs.bluez}/bin/mpris-proxy";
  };
}
