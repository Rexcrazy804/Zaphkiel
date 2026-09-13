{
  pkgs,
  config,
  osConfig,
  lib,
  inputs,
  ...
}: let
  inherit (lib) mkOption;
  inherit (lib.types) enum number;
  inherit (osConfig.nixpkgs.hostPlatform) system;
  inherit (inputs.self.legacyPackages.${system}) mangowc scripts;

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
      path = [mangowc];
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
      scripts.changeWall
    ];
  };
}
