{
  config,
  lib,
  ...
}: {
  config = lib.mkIf (!config.zaphkiel.data.headless) {
    # Bluetooth
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings.General.Experimental = true;
    };
  };
}
