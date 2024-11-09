{
  inputs,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  networking.hostName = "Zaphkiel";
  time.timeZone = "Asia/Kolkata";
  system.stateVersion = "23.11";

  graphicsModule = {
    amd.enable = true;
    nvidia = {
      enable = true;

      hybrid = {
        enable = true;
        igpu = {
          vendor = "amd";
          port = "PCI:5:0:0";
        };
        dgpu.port = "PCI:1:0:0";
      };
    };
  };

  progModule = {
    steam.enable = true;
    sddm-custom-theme.enable = true;
    anime-games.enable = true;
    tailscale.enable = true;
  };

  # generic
  programs = {
    partition-manager.enable = true;
    kdeconnect.enable = true;
    mosh.enable = true;
  };

  environment.systemPackages = with pkgs; [
    lenovo-legion
  ];

  # KDE
  services.desktopManager.plasma6.enable = true;

  # ssd + btrfs stuff
  services.btrfs.autoScrub.enable = true;
  services.fstrim.enable = true;

  # tailscale
  age.secrets.tailAuth.file = ../../secrets/secret2.age;
  services.tailscale.authKeyFile = config.age.secrets.tailAuth.path;

  services.openssh = {
    enable = true;
    passwordAuthentication = false;
  };

  # obs stuff
  boot.extraModulePackages = with config.boot.kernelPackages; [
    v4l2loopback
  ];
  boot.kernelModules = ["v4l2loopback"];
  boot.extraModprobeConfig = ''
    options v4l2loopback devices=1 video_nr=1 card_label="OBS Cam" exclusive_caps=1
  '';
  security.polkit.enable = true;

}
