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
  in {
    environment.systemPackages = let
      wallpaper = cfg.wallpaper;
      sddm-astronaut = pkgs.sddm-astronaut.override {
        themeConfig = {
          Background = "${wallpaper}";
          PartialBlur = "true";
          BlurRadius = "45";
          ForceHideVirtualKeyboardButton = "true";
          FormPosition = "right";
        };
      };
    in
      lib.mkIf cfg.enable [
        sddm-astronaut
      ];

    services.displayManager.sddm = {
      enable = lib.mkDefault true;
      enableHidpi = true;
      wayland.enable = true;
      theme = "sddm-astronaut-theme";
      settings.Theme.CursorSize = 24;
    };
  };
}
