{lib, config, pkgs, ...}: {
  config = lib.mkIf config.packages.sway.enable {
    services.swayidle = {
      enable = true;
      events = [
        { event = "before-sleep"; command = "${pkgs.swaylock}/bin/swaylock -fF"; }
        { event = "lock"; command = "lock"; }
      ];
    };
  };
}
