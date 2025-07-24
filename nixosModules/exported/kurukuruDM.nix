{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) concatStringsSep mapAttrs attrValues mkEnableOption mkOption mkIf strings mkPackageOption optionalAttrs;
  inherit (lib.types) path lines;

  kuruOpts =
    {
      SESSIONS = concatStringsSep ":" config.services.displayManager.sessionPackages;
      WALLPATH = cfg.settings.wallpaper;
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
in {
  options.programs.kurukuruDM = {
    enable = mkEnableOption "kurukuru display manager";
    package =
      mkPackageOption pkgs "Kurukurubar package" {
        default = "kurukurubar-unstable";
      }
      // {
        apply = opt: opt.override {asGreeter = true;};
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
    };
  };

  config = mkIf cfg.enable {
    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.hyprland}/bin/hyprland --config ${hyprConf}";
        };
      };
    };
  };
}
