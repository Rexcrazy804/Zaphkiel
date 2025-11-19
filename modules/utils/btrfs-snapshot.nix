{...}: {
  dandelion.modules.btrfs-snapshots = {
    lib,
    config,
    pkgs,
    ...
  }: let
    inherit (lib) mkOption mkIf literalExpression mkMerge;
    inherit (lib) map genAttrs pipe filter flatten;
    inherit (lib.attrsets) mapAttrs attrValues;
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

    users = map (x: x.user) cfg;
    tmpfilesFor = user: {
      rules = pipe cfg [
        (filter (x: x.user == user))
        (map (x: "d '${config.users.users.${user}.home}/.snapshots/${x.subvolume}' - - - ${x.expiry} -"))
      ];
    };

    timers =
      map
      (x: {
        "snapshot-${replaceString "/" "-" x.subvolume}@${x.user}" = {
          enable = true;
          description = "Timer to start ${x.subvolume} backup for ${x.user}";
          wantedBy = ["timers.target"];
          timerConfig = {
            OnCalendar = x.calendar;
            Persistent = true;
          };
        };
      })
      cfg;

    script = subvol:
      pkgs.writers.writeBashBin "backup" ''
        set -euxo pipefail
        ${pkgs.btrfs-progs}/bin/btrfs subvolume snapshot -r ~/${subvol} ~/.snapshots/${subvol}/$(date +%b%d)
      '';

    services =
      map
      (x: {
        "snapshot-${replaceString "/" "-" x.subvolume}@${x.user}" = {
          enable = true;
          unitConfig.ConditionUser = x.user;
          description = "Backup ${x.subvolume} for ${x.user}";
          serviceConfig = {
            Type = "oneshot";
            ExecStart = "${script x.subvolume}/bin/backup";
          };
        };
      })
      cfg;
  in {
    options.zaphkiel.utils.btrfs-snapshots = mkOption {
      type = attrsOf (listOf snapshotAttr);
      default = {};
      description = "a list describing files to back up";
      example = literalExpression ''
        {
          rexies = [
            {subvolume = "subVolume/path/from/home"; calendar = "*-*-* 12:00:00"; expiry = "7d";}
          ];
          quinz = [
            {subvolume = "muhVol"; calendar = "daily"; expiry = "4d";}
          ];
        }
      '';
      apply = opt:
        pipe opt [
          (mapAttrs (user: attrList: map (attr: attr // {inherit user;}) attrList))
          attrValues
          flatten
        ];
    };

    config = mkIf (cfg != []) {
      systemd.user.tmpfiles.users = genAttrs users tmpfilesFor;
      systemd.user.timers = mkMerge timers;
      systemd.user.services = mkMerge services;
    };
  };
}
