{...}: {
  networking = {
    hostName = "Zaphkiel"; # Define your hostname.

    networkmanager = {
      enable = true;
      wifi = {
        powersave = false;
        backend = "iwd";
        macAddress = "random";
      };
    };

    firewall = {
      enable = true;
      allowedTCPPortRanges = [
        {
          from = 1714;
          to = 1764;
        } # KDE Connect
      ];
      allowedUDPPortRanges = [
        {
          from = 1714;
          to = 1764;
        } # KDE Connect
      ];
    };
  };
}
