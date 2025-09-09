{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  # lets me just read my uwsm env stuff for the env vars
  # largely just to set my cursor lol
  uwuToHypr = pkgs.runCommandLocal "quick" {} ''
    awk '/^export/ { split($2, ARR, "="); print "env = "ARR[1]","ARR[2]}' ${../../users/dots/uwsm/env} > $out
  '';
  inherit (config.zaphkiel.data) wallpaper;
in {
  options.zaphkiel.programs.kuruDM.enable = mkEnableOption "kurukuruDM";
  config = mkIf config.zaphkiel.programs.kuruDM.enable {
    programs.kurukuruDM = {
      enable = true;
      settings = {
        inherit wallpaper;
        # colorsQML = theme.files + "/quickshell-colors.qml";
        instantAuth = true;
        extraConfig = ''
          monitor = eDP-1, preferred, auto, 1.25
          # night light
          exec-once = fish -c 'set -l hour (date +%H); if test $hour -ge 17 || test $hour -le  7; systemctl --user start hyprsunset.service; end'
          source = ${uwuToHypr}
        '';
      };
    };
  };
}
