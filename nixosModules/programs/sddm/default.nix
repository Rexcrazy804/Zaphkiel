{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkOption mkDefault mkIf;
  inherit (lib) pipe flatten;
in {
  options.zaphkiel.programs.sddm-custom-theme = {
    enable = mkEnableOption "Enable custom sddm theme";
    # left in here for not breaking things, will include it in later
    wallpaper = mkOption {
      default = ./sddm-wall.png;
    };
  };

  config = let
    cfg = config.zaphkiel.programs.sddm-custom-theme;
    # the theme is overriden via the internal overlay
    # its done this way to be able to export it onto the flake
    sddm-theme = pkgs.sddm-silent-custom;
  in
    mkIf cfg.enable {
      # changes might require a restart to be reflected correctly without errors
      environment.systemPackages = [sddm-theme];
      qt.enable = true;
      services.displayManager.sddm = {
        package = pkgs.kdePackages.sddm;
        enable = mkDefault true;
        enableHidpi = true;
        wayland.enable = true;
        theme = sddm-theme.pname;
        settings.Theme.CursorSize = 24;
        extraPackages = sddm-theme.propagatedBuildInputs;
        settings = {
          General = {
            # required for theming the virtual keyboard
            GreeterEnvironment = builtins.concatStringsSep "," [
              "QML2_IMPORT_PATH=${sddm-theme}/share/sddm/themes/${sddm-theme.pname}/components/"
              "QT_IM_MODULE=qtvirtualkeyboard"
            ];
            InputMethod = "qtvirtualkeyboard";
          };
        };
      };

      systemd.tmpfiles.rules = let
        iconPath = user: config.hjem.users.${user}.files.".face.icon".source or "";
      in
        pipe config.zaphkiel.data.users [
          (builtins.filter (user: (iconPath user) != null))
          (builtins.map (user: [
            "f+ /var/lib/AccountsService/users/${user}  0600 root root -  [User]\\nIcon=/var/lib/AccountsService/icons/${user}\\n"
            "L+ /var/lib/AccountsService/icons/${user}  -    -    -    -  ${iconPath user}"
          ]))
          flatten
        ];
    };
}
