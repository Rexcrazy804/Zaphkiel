{pkgs, ...}: let
  script = pkgs.writers.writeBashBin "backup" ''
    set -euxo pipefail
    ${pkgs.btrfs-progs}/bin/btrfs subvolume snapshot -r ~/Documents ~/.snapshots/Documents_$(date +%b%d)
  '';
in {
  systemd.user.tmpfiles.users."rexies".rules = ["d %h/.snapshots - - - 2d -"];
  systemd.user.timers."snapshot-Documents@rexies" = {
    description = "Timer to start document backup for rexies";
    enable = true;
    wantedBy = ["timers.target"];
    timerConfig = {
      OnCalendar = "*-*-* 12:00:00";
      Persistent = true;
    };
  };
  systemd.user.services."snapshot-Documents@rexies" = {
    enable = true;
    unitConfig.ConditionUser = "rexies";
    description = "Backsup document subvolume for rexies";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${script}/bin/backup";
    };
  };
}
