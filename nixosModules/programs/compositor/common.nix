{
  lib,
  pkgs,
  mein,
  inputs,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkForce attrValues;
  zpkgs = mein.${pkgs.system};
  todo = inputs.hs-todo.packages.${pkgs.system}.default;
  cfg = config.zaphkiel.programs.compositor-common;
in {
  options.zaphkiel.programs.compositor-common.enable = mkEnableOption "common compositor options";

  config = mkIf cfg.enable {
    # for whatever reason swappy likes to open images
    # don't let that fucker open images
    xdg.mime.defaultApplications = {
      "image/jpeg" = ["imv.desktop"];
      "image/png" = ["imv.desktop"];
    };

    services.gnome.gnome-keyring.enable = true;

    # required for mounting mobile phones
    services.gvfs.enable = true;

    # required when kde plasma is not installed .w.
    # ask me how I knew
    services.power-profiles-daemon.enable = true;
    services.upower = {
      enable = true;
      usePercentageForPolicy = true;
      criticalPowerAction = "PowerOff";
    };

    # dependencies .w.
    environment.systemPackages = attrValues {
      # internal overlay
      inherit (zpkgs) kokCursor kurukurubar stash;
      inherit (zpkgs.scripts) taildrop gpurecording cowask npins-show;
      # Themes
      inherit (pkgs) rose-pine-icon-theme rose-pine-gtk-theme;
      inherit (pkgs.kdePackages) qt6ct breeze;
      # utility
      inherit (pkgs) wl-clipboard grim slurp brightnessctl;
      inherit (pkgs) trashy fuzzel wl-screenrec;
      inherit (pkgs) libnotify swappy imv wayfreeze networkmanagerapplet;
      inherit (pkgs) yazi ripdrag seahorse app2unit;
      # external
      inherit todo;
    };

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

    services.hypridle.enable = true;
    systemd.user.services.hypridle.path = mkForce (attrValues {
      inherit (pkgs) systemd procps brightnessctl;
      inherit (zpkgs) kurukurubar;
    });
  };
}
