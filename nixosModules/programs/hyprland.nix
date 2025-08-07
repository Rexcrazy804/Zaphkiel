{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkForce attrValues mkAfter;
in {
  options.zaphkiel.programs.hyprland.enable = mkEnableOption "hyprland";
  config = mkIf config.zaphkiel.programs.hyprland.enable {
    # won't work as intended without mkAfter
    nixpkgs.overlays = mkAfter [
      (final: prev: {
        kurukurubar-unstable = prev.kurukurubar-unstable.override {
          customColors = config.programs.matugen.theme.files + "/quickshell-colors.qml";
        };
      })
    ];
    programs.hyprland = {
      enable = true;
      withUWSM = true;
    };
    services.hypridle.enable = true;
    systemd.user.services.hypridle.path = mkForce (attrValues {
      inherit (config.programs.hyprland) package;
      inherit (pkgs) systemd procps brightnessctl kurukurubar-unstable;
    });

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
    environment.systemPackages = attrValues {
      # internal overlay
      inherit (pkgs) kokCursor kurukurubar-unstable;
      inherit (pkgs.scripts) kde-send gpurecording cowask npins-show;
      # Themes
      inherit (pkgs) rose-pine-icon-theme rose-pine-gtk-theme;
      inherit (pkgs.kdePackages) qt6ct breeze;
      # utility
      inherit (pkgs) wl-clipboard cliphist grim slurp brightnessctl;
      inherit (pkgs) hyprsunset trashy fuzzel wl-screenrec;
      inherit (pkgs) libnotify swappy imv wayfreeze networkmanagerapplet;
      inherit (pkgs) yazi ripdrag seahorse app2unit;
    };

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
