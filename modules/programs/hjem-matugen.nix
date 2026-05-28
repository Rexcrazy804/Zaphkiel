{self, ...}: {
  dandelion.modules.hjem-matugen = {
    hjem.extraModules = [self.dandelion.modules._hjem-matugen];
  };

  dandelion.modules._hjem-matugen = {
    pkgs,
    config,
    osConfig,
    lib,
    ...
  }: let
    inherit (lib) mkOption;
    inherit (lib.types) enum number;
    pkgx = self.lib.mkPkgx' pkgs;
    cfg = config.matugen;
    zphd = osConfig.zaphkiel.data;
  in {
    options.matugen = {
      scheme = mkOption {
        type = enum [
          "scheme-content"
          "scheme-expressive"
          "scheme-fidelity"
          "scheme-fruit-salad"
          "scheme-monochrome"
          "scheme-neutral"
          "scheme-rainbow"
          "scheme-tonal-spot"
        ];
        default = "scheme-tonal-spot";
        description = "sets color scheme type";
      };
      srcIndex = mkOption {
        type = number;
        default = 0;
        description = "source color index when multiple colors are found";
      };
    };

    config = {
      systemd.services."matugen" = {
        description = "invoke matugen to populate color files";
        path = [pkgx.mangowc];
        serviceConfig = {
          Type = "oneshot";
        };
        wantedBy = ["graphical-session-pre.target"];
        scriptArgs = "${zphd.wallpaper} ${cfg.scheme}";
        script = ''
          ${pkgs.matugen}/bin/matugen -t "$2" image "$1" --json hex --source-color-index ${builtins.toString cfg.srcIndex}
        '';
      };

      packages = [
        pkgs.matugen
        pkgx.scripts.changeWall
      ];
    };
  };
}
