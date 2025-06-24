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
    sddm-theme = let
      zero-bg = pkgs.fetchurl {
        url = "https://www.desktophut.com/files/kV1sBGwNvy-Wallpaperghgh2Prob4.mp4";
        hash = "sha256-VkOAkmFrK9L00+CeYR7BKyij/R1b/WhWuYf0nWjsIkM=";
      };

      zero-thumb = pkgs.runCommandWith {
        name = "thumbnail.png";
        derivationArgs.nativeBuildInputs = [pkgs.ffmpeg];
      } ''
        ffmpeg -i ${zero-bg} -vf "select=eq(n\,34)" -vframes 1 $out
      '';
    in
      pkgs.sddm-silent.override {
        theme = "rei";
        extraBackgrounds = [zero-bg zero-thumb];
        theme-overrides = {
          "LoginScreen.LoginArea.Avatar" = {
            shape = "circle";
            active-border-size = 0;
            inactive-border-size = 0;
          };
          "LoginScreen" = {
            background = "${zero-bg.name}";
          };
          "LockScreen" = {
            background = "${zero-bg.name}";
          };
          "General" = {
            animated-background-placeholder = "${zero-thumb.name}";
          };
        };
      };
  in
    lib.mkIf cfg.enable {
      # changes might require a restart to be reflected correctly without errors
      environment.systemPackages = [sddm-theme];
      qt.enable = true;
      services.displayManager.sddm = {
        package = pkgs.kdePackages.sddm;
        enable = lib.mkDefault true;
        enableHidpi = true;
        wayland.enable = true;
        theme = sddm-theme.pname;
        settings.Theme.CursorSize = 24;
        extraPackages = sddm-theme.propagatedBuildInputs;
        settings = {
          General = {
            # required for theming the virtual keyboard
            GreeterEnvironment = "QML2_IMPORT_PATH=${sddm-theme}/share/sddm/themes/${sddm-theme.pname}/components/,QT_IM_MODULE=qtvirtualkeyboard";
            InputMethod = "qtvirtualkeyboard";
          };
        };
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
