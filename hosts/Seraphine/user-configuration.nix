{
  pkgs,
  lib,
  mein,
  ...
}: let
  packages = lib.attrValues {
    inherit (pkgs) foot;
    # from internal overlay
    inherit (mein.${pkgs.system}) mpv-wrapped;
  };
in {
  imports = [./extras/filebrowser.nix];
  users.users."rexies" = {
    inherit packages;
    extraGroups = ["video" "input"];
  };
  zaphkiel.data.wallpaper = pkgs.fetchurl {
    url = "https://cdn.donmai.us/original/e6/cb/__lumine_and_noelle_genshin_impact_drawn_by_chigalidepoi__e6cb4bdb2a28017256fd6980eb1cc51b.jpg";
    hash = "sha256-3XFnzhlBKr2PURGxDWtdOCfXv0ItH/nquxosBZLlm0Y=";
  };
  hjem.users."rexies".files = {
    ".config/hypr/hyprland.conf".text = let
      # override scaling for seraphine
      from = ["monitor = eDP-1, preferred, auto, 1.25"];
      to = ["monitor = eDP-1, preferred, auto, auto"];
    in
      lib.mkForce (builtins.replaceStrings from to (builtins.readFile ../../users/dots/hyprland/hyprland.conf));
  };
}
