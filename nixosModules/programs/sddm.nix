{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    progModule.sddm-custom-theme = {
      enable = lib.mkEnableOption "Enable custom sddm theme";
      wallpaper = lib.mkOption {
        default = ../../homeManagerModules/dots/sddm-wall.png;
      };
    };
  };

  config = let
    cfg = config.progModule.sddm-custom-theme;
  in
    lib.mkIf cfg.enable {
      environment.systemPackages = let
        sddm-astronaut = pkgs.sddm-astronaut.override {
          themeConfig = {
            Background = "${cfg.wallpaper}";
            PartialBlur = "true";
            BlurRadius = "13";
            ForceHideVirtualKeyboardButton = "true";
            FormPosition = "right";

            AccentColor = "\"#313FAB\"";
            placeholderColor = "\"#192E59\"";

            # MainColor="#F8F8F2";
            # OverrideTextFieldColor="";
            # BackgroundColor="#21222C";
            # IconColor="#ffffff";
            # OverrideLoginButtonTextColor="";
          };
        };
      in [sddm-astronaut];

      services.displayManager.sddm = {
        enable = lib.mkDefault true;
        enableHidpi = true;
        wayland.enable = true;
        theme = "sddm-astronaut-theme";
        settings.Theme.CursorSize = 24;
      };
    };
}
