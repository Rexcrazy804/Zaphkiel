{pkgs, ...}: {
  environment.systemPackages = let
    wallpaper = ../../home/dots/sddm-wall.png;
    sddm-astronaut = pkgs.sddm-astronaut.override {
      themeConfig = {
        Background = "${wallpaper}";
        PartialBlur = "true";
        BlurRadius = "45";
        ForceHideVirtualKeyboardButton = "true";
        FormPosition = "right";
      };
    };
  in [
    sddm-astronaut
  ];

  services.displayManager.sddm = {
    enable = true;
    enableHidpi = true;
    wayland.enable = true;
    theme = "sddm-astronaut-theme";
    settings.Theme.CursorSize = 24;
  };
}
