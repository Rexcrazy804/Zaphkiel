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
    inherit (lib.types) enum;
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
    };

    config = {
      systemd.services."matugen" = {
        description = "invoke matugen to populate color files";
        path = [self.packages.${pkgs.stdenv.hostPlatform.system}.mangowc];
        serviceConfig = {
          Type = "oneshot";
        };
        wantedBy = ["graphical-session-pre.target"];
        scriptArgs = "${zphd.wallpaper} ${cfg.scheme}";
        script = ''
          ${pkgs.matugen}/bin/matugen -t $2 image $1 --json hex
        '';
      };

      packages = [
        pkgs.matugen
        self.packages.${pkgs.stdenv.hostPlatform.system}.scripts.changeWall
      ];
    };
  };
}
