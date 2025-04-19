{...}: {
  # uncategorized
  services.thermald.enable = true;
  services.fwupd.enable = true;

  # Configure keymap in X11
  services.xserver = {
    xkb.layout = "us";
    xkb.variant = "";
  };

  # cups [printers]
  services.printing.enable = false;

  # extra firmware
  hardware.enableAllFirmware = true;
  hardware.steam-hardware.enable = true;
}
