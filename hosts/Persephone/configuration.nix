{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./user-configuration.nix
  ];

  system.stateVersion = "24.11"; # Did you read the comment?
  networking.hostName = "Persephone"; # Define your hostname.
  time.timeZone = "Asia/Dubai";

  services.xserver.enable = true;
  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  graphicsModule = {
    intel.enable = true;
  };

  servModule = {
    enable = true;
    tailscale = {
      enable = false;
      exitNode.enable = true;
      exitNode.networkDevice = "wlp1s0";
    };
    openssh.enable = false;
    jellyfin.enable = false;
    minecraft.enable = false;
  };

  progModule = {
    sddm-custom-theme = {
      enable = true;
      wallpaper = config.age.secrets.wallpaper.path;
    };
    direnv.enable = true;
    obs-studio.enable = false;
    steam.enable = true;
    hyprland.enable = true;
    keyd.enable = true;
  };

  # forward dns onto the tailnet
  # TODO correct this after setting up tailscale
  # networking.firewall.allowedTCPPorts = [53];
  # networking.firewall.allowedUDPPorts = [53];
  # services.dnscrypt-proxy2.settings = {
  #   listen_addresses = [
  #     "100.112.116.17:53"
  #     "[fd7a:115c:a1e0::eb01:7412]:53"
  #     "127.0.0.1:53"
  #     "[::1]:53"
  #   ];
  # };

  # tailscale
  # age.secrets.tailAuth.file = ../../secrets/secret5.age;
  # services.tailscale.authKeyFile = config.age.secrets.tailAuth.path;

  # sddm
  age.secrets.wallpaper = {
    file = ../../secrets/media_robin.age;
    name = "wallpaper.jpg";
    mode = "644";
  };

  # generic
  programs = {
    kdeconnect = {
      enable = true;
      package = pkgs.kdePackages.kdeconnect-kde;
    };
  };

  # services.displayManager.autoLogin.user = "rexies";
  # services.displayManager.defaultSession = "hyprland-uwsm";
  services.fstrim.enable = true;

  # disabled autosuspend
  services.logind.lidSwitchExternalPower = "ignore";

  # maybe move this into its own module idk
  environment.systemPackages = [pkgs.firefoxpwa];
  programs.firefox = {
    enable = true;
    nativeMessagingHosts.packages = [
      pkgs.firefoxpwa
    ];
  };

  services.flatpak.enable = true;
  systemd.services.flatpak-repo = {
    wantedBy = ["multi-user.target"];
    path = [pkgs.flatpak];
    script = ''
      flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    '';
  };
}
