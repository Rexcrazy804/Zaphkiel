{
  pkgs,
  lib,
  config,
  users,
  ...
}: {
  options = {
    progModule.sddm-custom-theme = {
      enable = lib.mkEnableOption "Enable custom sddm theme";
      # left in here for not breaking things, will include it in later
      wallpaper = lib.mkOption {
        default = ./sddm-wall.png;
      };
    };
  };

  config = let
    cfg = config.progModule.sddm-custom-theme;
    sddm-theme = pkgs.sddm-silent.override {
      theme = "rei";
      theme-overrides = {
        "LoginScreen.LoginArea.Avatar" = {
          border-radius = 10;
        };
      };
    };
  in
    lib.mkIf cfg.enable {
      environment.systemPackages = [
        sddm-theme
        pkgs.kdePackages.qtsvg
        pkgs.kdePackages.qtmultimedia
        pkgs.kdePackages.qtvirtualkeyboard
      ];

      qt.enable = true;

      services.displayManager.sddm = {
        enable = lib.mkDefault true;
        enableHidpi = true;
        wayland.enable = true;
        theme = sddm-theme.pname;
        settings.Theme.CursorSize = 24;
      };

      systemd.tmpfiles.rules = let
        iconPath = user: config.hjem.users.${user}.files.".face.icon".source;
      in
        lib.pipe users [
          (builtins.filter (user: (iconPath user) != null))
          (builtins.map (user: [
            "f+ /var/lib/AccountsService/users/${user}  0600 root root -  [User]\\nIcon=/var/lib/AccountsService/icons/${user}\\n"
            "L+ /var/lib/AccountsService/icons/${user}  -    -    -    -  ${iconPath user}"
          ]))
          (lib.flatten)
        ];
    };
}
