{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) concatStringsSep mapAttrs attrValues mkEnableOption;
  inherit (lib) mkOption mkIf strings mkPackageOption optionalAttrs;
  inherit (lib) filterAttrs attrNames elemAt;
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
      force_default_wallpaper = 1 # Set to 0 or 1 to disable the anime mascot wallpapers
      disable_hyprland_logo = true # If true disables the random hyprland logo / anime girl background. :(
    }
  '';
  hyprConf = pkgs.writeText "hyprland.conf" (strings.concatLines [
    baseConfig
    cfg.settings.extraConfig
  ]);
  cfg = config.programs.kurukuruDM;

  normalUsers = attrNames (filterAttrs (k: v: v.isNormalUser) config.users.users);
in {
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
            customColors = cfg.settings.colorsQML;
          };
      };
    settings = {
      wallpaper = mkOption {
        type = path;
        description = "Wallpaper path";
      };
      instantAuth = mkEnableOption "instantAuth (ideal for finnger print)";
      extraConfig = mkOption {
        type = lines;
        default = "";
        description = "extra configuration appended to containerized hyprland instance";
      };
      default_user = mkOption {
        type = enum normalUsers;
        default = elemAt normalUsers 0;
        description = "default selected user";
      };
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
      colorsQML = mkOption {
        type = nullOr path;
        default = null;
        description = "A qml file following the Data/Colors.qml format of kurukurubar";
      };
    };
  };

  config = mkIf cfg.enable {
    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.dbus}/bin/dbus-run-session ${pkgs.hyprland}/bin/hyprland --config ${hyprConf}";
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
