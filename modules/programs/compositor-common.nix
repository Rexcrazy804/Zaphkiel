{
  self,
  hs-todo,
  ...
}: {
  dandelion.modules.compositor-common = {
    pkgs,
    lib,
    ...
  }: let
    inherit (lib) mkForce attrValues;

    system = pkgs.stdenv.hostPlatform.system;
    zpkgs = self.packages.${system};
    todo = hs-todo.packages.${system}.default;
  in {
    # for whatever reason swappy likes to open images
    # don't let that fucker open images
    xdg.mime.defaultApplications = {
      "image/jpeg" = ["imv.desktop"];
      "image/png" = ["imv.desktop"];
      "application/pdf" = ["librewolf.desktop"];
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
      inherit (pkgs) foot libsixel;
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
