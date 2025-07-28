{
  pkgs,
  lib,
  config,
  ...
}: {
  options.zaphkiel.programs.hyprland.enable = lib.mkEnableOption "hyprland";
  config = lib.mkIf config.zaphkiel.programs.hyprland.enable {
    programs.hyprland = {
      enable = true;
      withUWSM = true;
    };
    services.hypridle.enable = true;
    systemd.user.services.hypridle.path = lib.mkForce [
      config.programs.hyprland.package
      pkgs.procps
      pkgs.brightnessctl
      pkgs.quickshell
    ];

    qt.enable = true;

    programs.dconf.profiles.user.databases = [
      {
        settings = {
          "org/gnome/desktop/interface" = {
            cursor-theme = "Kokomi_Cursor";
            gtk-theme = "rose-pine";
            icon-theme = "rose-pine";
            document-font-name = "DejaVu Serif";
            font-name = "DejaVu Sans";
            monospace-font-name = "CaskaydiaMono NF";
            accent-color = "purple";
            color-scheme = "prefer-dark";
          };
        };
      }
    ];

    # dependencies .w.
    environment.systemPackages = [
      pkgs.kokCursor
      # QT dep
      pkgs.kdePackages.qt6ct
      pkgs.kdePackages.breeze
      # Theme
      # pkgs.rose-pine-cursor
      # pkgs.rose-pine-hyprcursor
      pkgs.rose-pine-icon-theme
      pkgs.rose-pine-gtk-theme

      # utility
      pkgs.wl-clipboard
      pkgs.grim
      pkgs.slurp
      pkgs.brightnessctl
      pkgs.hyprsunset
      pkgs.trashy
      pkgs.walker
      pkgs.wl-screenrec
      pkgs.libnotify
      pkgs.swappy
      pkgs.imv
      pkgs.wayfreeze
      pkgs.networkmanagerapplet
      pkgs.yazi
      pkgs.ripdrag
      # gnome keyring
      pkgs.seahorse

      # quickshell dep
      pkgs.quickshell
      pkgs.rembg

      # supporting scripts
      pkgs.scripts.kde-send
      pkgs.scripts.gpurecording
      pkgs.scripts.cowask
      pkgs.scripts.npins-show
    ];

    # required when kde plasma is not installed .w.
    # ask me how I knew
    services.power-profiles-daemon.enable = true;
    services.upower = {
      enable = true;
      usePercentageForPolicy = true;
      criticalPowerAction = "PowerOff";
    };

    # I could write a hypersunrise service to conflict but fuck it better to just
    # make a keybind to stop the service lol And I am less likely to forget to
    # turn the darn thing off if its right on my face
    systemd.user.timers.hyprsunset = {
      description = "Start hyprsunset after sunset";
      enable = true;
      wantedBy = ["timers.target"];
      timerConfig = {
        OnCalendar = "*-*-* 17:30:00";
      };
    };
    systemd.user.services.hyprsunset = {
      enable = true;
      description = "starts hyprsunset for blue light filtering";
      after = ["graphical.target"];
      serviceConfig = {
        ExecStart = "${pkgs.hyprsunset}/bin/hyprsunset -t 3000";
      };
    };

    # Pokit agent
    security.soteria.enable = true;

    # for whatever reason swappy likes to open images
    # don't let that fucker open images
    xdg.mime.defaultApplications = {
      "image/jpeg" = ["imv.desktop"];
      "image/png" = ["imv.desktop"];
    };

    services.gnome.gnome-keyring.enable = true;
  };
}
