{
  inputs,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  networking.hostName = "Orion";
  time.timeZone = "Asia/Kolkata";
  system.stateVersion = "23.11";


  # EDIT THIS
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

  servModule = {
    enable = true;
    tailscale.enable = true;
    openssh.enable = true;
  };

  progModule = {
    steam.enable = true;
    sddm-custom-theme.enable = true;
    anime-games.enable = true;
  };

  # generic
  programs = {
    partition-manager.enable = true;
    kdeconnect.enable = true;
    mosh.enable = true;
  };

  #icue
  hardware.ckb-next.enable = true;

  environment.systemPackages = with pkgs; [
    lenovo-legion
  ];
  # environment.variables = {
  #   SHELL = "${pkgs.bash}/bin/bash";
  # };

  # KDE
  services.desktopManager.plasma6.enable = true;
}
