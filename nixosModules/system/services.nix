{
  config,
  lib,
  ...
}: {
  config = lib.mkIf (!config.zaphkiel.data.headless) {
    # uncategorized
    services.thermald.enable = true;
    services.fwupd.enable = true;

    # Configure keymap in X11
    services.xserver = {
      xkb.layout = "us";
      xkb.variant = "";
    };

    # extra firmware
    hardware.enableAllFirmware = true;
    hardware.steam-hardware.enable = true;
  };
}
