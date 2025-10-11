{
  mein,
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkOption;
  inherit (lib) genAttrs map;
  inherit (lib.types) enum;
  cfg = config.zaphkiel.programs.matugen;
  zphd = config.zaphkiel.data;
in {
  options.zaphkiel.programs.matugen = {
    enable = mkEnableOption "matugen copy service";
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

  config = mkIf cfg.enable {
    systemd.targets.hjem.requires = map (user: "matugen-copy@${user}.service") zphd.users;
    systemd.services."matugen-copy@" = {
      description = "Link files for %i from their manifest";
      serviceConfig = {
        User = "%i";
        Type = "oneshot";
      };
      after = ["hjem-activate@%i.service"];
      scriptArgs = "${zphd.wallpaper} ${cfg.scheme}";
      script = ''
        ${pkgs.matugen}/bin/matugen -t $2 image $1 --json hex > $HOME/.config/kurukurubar/colors.json
      '';
    };

    users.users = genAttrs zphd.users (_user: {
      packages = [pkgs.matugen mein.${pkgs.system}.scripts.changeWall];
    });
  };
}
