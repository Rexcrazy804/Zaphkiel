{pkgs, ...}: {
  boot = {
    # Bootloader. DO NOT TOUCH
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    supportedFilesystems = ["ntfs"];

    plymouth = {
      enable = true;
      logo = pkgs.fetchurl {
        url = "https://www.pngarts.com/files/8/Cute-Hatsune-Miku-Transparent-Image.png";
        sha256 = "74f8a09646d2cfa7c87bfa72a0161f78f0a0f86b2058669bf677ab50d97e50b3";
      };
    };

    # Enable "Silent Boot" Required for plymouth
    consoleLogLevel = 0;
    initrd.verbose = false;
    kernelParams = [
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "loglevel=3"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
    ];
    # Hide the OS choice for bootloaders.
    # It's still possible to open the bootloader list by pressing any key
    # It will just not appear on screen unless a key is pressed
    loader.timeout = 0;
  };
}
