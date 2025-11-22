{self, ...}: {
  dandelion.modules.kuruDM = {
    config,
    pkgs,
    ...
  }: let
    inherit (config.zaphkiel.data) wallpaper;

    uwuToHypr = pkgs.runCommandLocal "quick" {} ''
      awk '/^export/ { split($2, ARR, "="); print "env = "ARR[1]","ARR[2]}' ${self.paths.dots + /uwsm/env} > $out
    '';
  in {
    imports = [self.nixosModules.default];
    programs.kurukuruDM = {
      enable = true;
      settings = {
        inherit wallpaper;
        # color = self.paths.dots + /quickshell/colors.json;
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
