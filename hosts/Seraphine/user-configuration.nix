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
  hjem.users."rexies".xdg.config.files = {
    "mango/config.conf".text = let
      # override scaling for seraphine
      from = ["monitorrule=eDP-1,1,1,tile,0,1.25,0,0,1920,1080,60"];
      to = ["monitorrule=eDP-1,1,1,tile,0,1,0,0,1920,1080,60"];
    in
      lib.mkForce (builtins.replaceStrings from to (builtins.readFile ../../users/dots/mango/config.conf));
  };
}
