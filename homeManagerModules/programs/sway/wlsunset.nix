{lib, config, ...}: {
  config = lib.mkIf config.packages.sway.enable {
    services.wlsunset = {
      enable = true;
      sunrise = "6:30";
      sunset = "17:30";
      temperature.night = 2600;
    };
  };
}
