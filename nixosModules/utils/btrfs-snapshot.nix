# module for snapshoting subvoulmes within user home directory
{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkOption mkIf literalExpression mkMerge;
  inherit (lib) map genAttrs pipe flatten;
  inherit (lib.attrsets) attrValues attrNames filterAttrs mapAttrs;
  inherit (lib.strings) replaceString;
  inherit (lib.types) listOf submodule str strMatching attrsOf;

  cfg = config.zaphkiel.utils.btrfs-snapshots;

  snapshotAttr = submodule {
    options = {
      subvolume = mkOption {
        type = str;
        example = "subvolume/path/from/home";
      };
      # TODO: figure out how I can make this point to the type declaration
      # of systemd.timers.timerConfig.onCalander.type
      calendar = mkOption {
        type = str;
        default = "*-*-* 12:00:00";
        example = "weekly";
      };
      expiry = mkOption {
        type = strMatching "[0-9]+[smhdw]";
        default = "1w";
        example = "3d";
      };
    };
  };

  users = attrNames cfg;
  tmpfilesFor = user: {
    rules = pipe cfg [
      (filterAttrs (k: v: k == user))
      attrValues
      flatten
      (map (x: "d '${config.users.users.${user}.home}/.snapshots/${x.subvolume}' - - - ${x.expiry} -"))
    ];
  };

  timers = let
    toTimer = user: list:
      map (x: {
        "snapshot-${replaceString "/" "-" x.subvolume}@${user}" = {
          enable = true;
          description = "Timer to start ${x.subvolume} backup for ${user}";
          wantedBy = ["timers.target"];
          timerConfig = {
            OnCalendar = x.calendar;
            Persistent = true;
          };
        };
      })
      list;
  in
    pipe cfg [
      (mapAttrs toTimer)
      attrValues
      flatten
    ];

  services = let
    script = subvol:
      pkgs.writers.writeBashBin "backup" ''
        set -euxo pipefail
        ${pkgs.btrfs-progs}/bin/btrfs subvolume snapshot ~/${subvol} ~/.snapshots/${subvol}/$(date +%b%d)
      '';

    toService = user: list:
      map (x: {
        "snapshot-${replaceString "/" "-" x.subvolume}@${user}" = {
          enable = true;
          unitConfig.ConditionUser = user;
          description = "Backup ${x.subvolume} for ${user}";
          serviceConfig = {
            Type = "oneshot";
            ExecStart = "${script x.subvolume}/bin/backup";
          };
        };
      })
      list;
  in
    pipe cfg [
      (mapAttrs toService)
      attrValues
      flatten
    ];
in {
  options.zaphkiel.utils.btrfs-snapshots = mkOption {
    type = attrsOf (listOf snapshotAttr);
    default = {};
    description = "a list describing files to back up";
    example = literalExpression ''
      snapshots = [
        {user = "rexies"; subvolume = "subVolume/path/from/home"; calendar = "*-*-* 12:00:00"; timeToLive = "7d";}
      ];
    '';
  };

  config = mkIf (cfg != {}) {
    systemd.user.tmpfiles.users = genAttrs users tmpfilesFor;
    systemd.user.timers = mkMerge timers;
    systemd.user.services = mkMerge services;
  };
}
