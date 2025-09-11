{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) concatStringsSep mapAttrs attrValues mkEnableOption;
  inherit (lib) mkOption mkIf strings mkPackageOption optionalAttrs;
  inherit (lib) filterAttrs attrNames elemAt warn length optional;
  inherit (lib) mkRenamedOptionModule;
  inherit (lib.types) path lines enum nullOr;
  inherit (config.services.displayManager) sessionData defaultSession;

  kuruOpts =
    {
      SESSIONS = sessionData.desktops;
      WALLPATH = cfg.settings.wallpaper;
      PREF_USR = cfg.settings.default_user;
      PREF_SES = cfg.settings.default_session;
    }
    // (optionalAttrs cfg.settings.instantAuth {
      INSTANTAUTH = "1";
    });

  optsToString = concatStringsSep " " (attrValues (mapAttrs (k: v: "KURU_DM_${k}=\"${v}\"") kuruOpts));
  baseConfig = ''
    monitor = ,preferred, auto, auto
    exec-once = ${optsToString} ${cfg.package}/bin/kurukurubar && pkill Hyprland

    misc {
      force_default_wallpaper = 1
      disable_hyprland_logo = true
    }
  '';
  hyprConf = pkgs.writeText "hyprland.conf" (strings.concatLines [
    baseConfig
    cfg.settings.extraConfig
  ]);
  cfg = config.programs.kurukuruDM;

  normalUsers = attrNames (filterAttrs (k: v: v.isNormalUser) config.users.users);
in {
  imports = [
    (mkRenamedOptionModule
      ["programs" "kurukuruDM" "settings" "colorsQML"]
      ["programs" "kurukuruDM" "settings" "colors"])
  ];
  options.programs.kurukuruDM = {
    enable = mkEnableOption "kurukuru display manager";
    package =
      mkPackageOption pkgs "Kurukurubar package" {
        default = "kurukurubar-unstable";
      }
      // {
        apply = opt:
          opt.override {
            asGreeter = true;
            customColors = cfg.settings.colors;
          };
      };
    settings = {
      wallpaper = mkOption {
        type = nullOr path;
        default = pkgs.fetchurl {
          url = "https://cdn.donmai.us/original/42/64/426488004c63005100d07cec1c3eb074.jpg";
          hash = "sha256-fht2+m63+hQ/nRAsXfyBKzHPq+lMIiAtnd50+v52mLo=";
        };
        description = "Wallpaper path";
      };
      instantAuth = mkEnableOption "instantAuth (ideal for finnger print)";
      extraConfig = mkOption {
        type = lines;
        default = "";
        description = "extra configuration appended to containerized hyprland instance";
      };
      default_user = let
        true_def_usr = elemAt normalUsers 0;
      in
        mkOption {
          type = enum normalUsers;
          description = "default selected user";
          default =
            if (cfg.settings.instantAuth && (length normalUsers) > 1)
            then warn "kurukuruDM.settings.instantAuth enabled without specifying settings.default_user" true_def_usr
            else true_def_usr;
        };
      # WARN
      # currently if you have no valid sessions, this throws a out of bonds
      # error which may be hard to narrow down to this
      # todo enable nullOr and on null builtins.trace the possible values
      default_session = mkOption {
        type = enum sessionData.sessionNames;
        default =
          if defaultSession != null
          then defaultSession
          else elemAt sessionData.sessionNames 0;
        description = "session name for default session set as null for list";
        example = "hyprland-uwsm";
        apply = opt: opt + ".desktop";
      };
      colors = mkOption {
        type = nullOr path;
        default = null;
        description = "A json file following the Data/Colors.qml format of kurukurubar";
      };
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = lib.hasSuffix ".json" cfg.settings.colors;
        message = "KurukuruDM: `settings.colors` must be a json file!";
      }
    ];
    warnings = optional (cfg.settings.instantAuth && !config.services.fprintd.enable) ''
      `programs.kurukuruDM.settings.instantAuth` enabled without fprintd service.
      This option is useless and counter intuitive if not used with finger print unlock
    '';

    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.hyprland}/bin/hyprland --config ${hyprConf}";
        };
      };
    };

    # https://github.com/NixOS/nixpkgs/issues/357201
    security.pam.services.greetd.text = ''
      auth      substack      login
      account   include       login
      password  substack      login
      session   include       login
    '';
  };
}
