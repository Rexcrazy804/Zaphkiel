{
  pkgs,
  config,
  lib,
  ...
}: let
  script = pkgs.writeShellScriptBin "rcon-backup" ''
    function rcon {
        ${lib.getExe pkgs.rconc} hollyj "$1"
    }

    export PATH="$PATH:${pkgs.gzip}/bin/"

    rcon 'say [§4WARNING§r] Server backup process will begin in 5 minutes.'
    sleep 5m

    rcon 'say [§4WARNING§r] Server backup process is starting NOW.'

    rcon "save-off"
    rcon "save-all"
    ${lib.getExe pkgs.gnutar} -cvpzf ~/backups/hollyj/backup-$(date +%F_%R).tar.gz ~/hollyj/world
    rcon "save-on"

    rcon 'say [§bNOTICE§r] Server backup process is complete. Carry on.'

    ## Delete older backups
    find ~/backups/hollyj -type f -mtime +7 -name 'backup-*.tar.gz' -delete
  '';
in {
  config = lib.mkIf (config.servModule.minecraft.enable && config.servModule.enable) {
    systemd.services.mc-hollyj-backup = {
      enable = true;
      description = "Backup minecraft world data to backup folder";
      serviceConfig = {
        User = "minecraft";
        Type = "oneshot";
        ExecStart = "${script}/bin/rcon-backup";
      };
    };
    systemd.timers.mc-hollyj-backup = {
      description = "Timer to regularly backup the mc server";
      enable = true;
      timerConfig = {
        OnCalendar = "daily";
        Persistent = true;
      };
    };
  };
}
