{
  mein,
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  inherit (lib) genAttrs map;
  cfg = config.zaphkiel.programs.matugen;
  zphd = config.zaphkiel.data;
in {
  options.zaphkiel.programs.matugen.enable = mkEnableOption "matugen copy service";

  # TODO
  # currently relies on hjem's linker services
  # replace with systemd's tmpfiles target when/if possible
  config = mkIf cfg.enable {
    systemd.targets.hjem.requires = map (user: "matugen-copy@${user}.service") zphd.users;
    systemd.services."matugen-copy@" = {
      description = "Link files for %i from their manifest";
      serviceConfig = {
        User = "%i";
        Type = "oneshot";
      };
      after = ["hjem-activate@%i.service"];
      scriptArgs = "${zphd.wallpaper}";
      script = ''
        ${pkgs.matugen}/bin/matugen image $1
      '';
    };

    users.users = genAttrs zphd.users (user: {
      packages = [pkgs.matugen mein.${pkgs.system}.scripts.changeWall];
    });
  };
}
