{
  dandelion.modules.firmware = {
    # uncategorized
    services.thermald.enable = true;
    services.fwupd.enable = true;

    # extra firmware
    hardware.enableAllFirmware = true;
    hardware.steam-hardware.enable = true;
  };
}
