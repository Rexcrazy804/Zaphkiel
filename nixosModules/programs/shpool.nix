{
  pkgs,
  lib,
  config,
  mein,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkOption getExe;
  inherit (lib.strings) concatStringsSep;
  inherit (lib.types) enum listOf package;

  cfg = config.zaphkiel.programs.shpool;
in {
  options.zaphkiel.programs.shpool = {
    enable = mkEnableOption "shpool";
    users = mkOption {
      type = listOf (enum config.zaphkiel.data.users);
      description = "users for which to enable the shpool service for";
      apply = concatStringsSep "|";
    };
    package = mkOption {
      type = package;
      default = mein.${pkgs.system}.shpool;
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [cfg.package];
    systemd.user.services."shpool" = {
      description = "Shpool - Shell Session Pool";
      requires = ["shpool.socket"];
      wantedBy = ["default.target"];
      unitConfig.ConditionUser = cfg.users;
      path = [cfg.package];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${getExe cfg.package} daemon";
        KillMode = "mixed";
        TimeoutStopSec = "2s";
        SendSIGHUP = "yes";
      };
    };
    systemd.user.sockets."shpool" = {
      description = "Shpool Shell Session Pooler";
      wantedBy = ["sockets.target"];
      unitConfig.ConditionUser = cfg.users;
      socketConfig = {
        ListenStream = "%t/shpool/shpool.socket";
        SocketMode = 0600;
      };
    };
  };
}
