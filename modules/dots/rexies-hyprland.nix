{config, ...}: let
  username = "rexies";
  dots = config.hjem.users.${username}.impure.dotsDir;
in {
  hjem.users.${username}.xdg.config.files = {
    "hypr/hyprland.conf".source = dots + "/hyprland/hyprland.conf";
  };
}
