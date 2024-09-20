{...}: {
  # uncategorized
  services.xserver.enable = true;
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

  # finger print [disabled cause 30s delay on sddm login]
  # services.fprintd = {
  #   enable = true;
  #   tod.enable = true;
  #   tod.driver = pkgs.libfprint-2-tod1-elan;
  # };
  # systemd.services.fprintd = {
  #   wantedBy = [ "multi-user.target" ];
  #   serviceConfig.Type = "simple";
  # };
}
