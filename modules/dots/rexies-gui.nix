{
  config,
  inputs,
  ...
}: let
  inherit (config.nixpkgs.hostPlatform) system;
  inherit (inputs.self.legacyPackages.${system}) sources;

  username = "rexies";
  dots = config.hjem.users.${username}.impure.dotsDir;
in {
  hjem.users.${username}.xdg.config.files = {
    "uwsm/env".source = dots + "/uwsm/env";
    "qt6ct/qt6ct.conf".source = dots + "/qt6ct/qt6ct.conf";
    "background".source = config.zaphkiel.data.wallpaper;
    "matugen/config.toml".source = dots + "/matugen/config.toml";
    "matugen/templates".source = dots + "/matugen/templates";
    "fuzzel/fuzzel.ini".source = dots + "/fuzzel/fuzzel.ini";
    "foot/foot.ini".source = dots + "/foot/foot.ini";
    "foot/rose-pine.ini".source = sources.rosep-foot + "/rose-pine";
    "hypr/hypridle.conf".source = dots + "/hyprland/hypridle.conf";
    "gtk-4.0/settings.ini".source = dots + "/gtk/gtk4.ini";
  };
}
