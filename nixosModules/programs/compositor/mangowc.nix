{
  mein,
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkOption mkIf mkDefault mkForce;
  cfg = config.zaphkiel.programs.mangowc;

  uwsmWithPlugin = pkgs.symlinkJoin {
    inherit (pkgs.uwsm) pname version;
    paths = [pkgs.uwsm];
    postBuild = ''
      ln -sf ${./mango-plugin.sh} $out/share/uwsm/plugins/mango.sh
    '';

    meta = pkgs.uwsm.meta // {outputsToInstall = ["out"];};
  };
in {
  options.zaphkiel.programs.mangowc = {
    enable = mkEnableOption "mango wayland compositor";
    package = mkOption {
      default = mein.${pkgs.system}.mangowc;
    };
    withUWSM = mkEnableOption "uwsm for mangowc" // {default = true;};
  };

  config = mkIf cfg.enable {
    zaphkiel.programs.compositor-common.enable = true;
    environment.systemPackages = [
      cfg.package
      pkgs.wlsunset
    ];

    systemd.user.services.hypridle.path = mkForce [cfg.package];

    # REQUIRES uwsm finalize in autostart.sh
    programs.uwsm = mkIf cfg.withUWSM {
      enable = true;
      package = uwsmWithPlugin;
      waylandCompositors.mango = {
        prettyName = "MangoWC";
        comment = "Mango compositor managed by UWSM";
        binPath = "/run/current-system/sw/bin/mango";
      };
    };

    xdg.portal = {
      enable = mkDefault true;
      wlr.enable = mkDefault true;
      configPackages = [cfg.package];
    };

    security.polkit.enable = mkDefault true;
    programs.xwayland.enable = mkDefault true;

    services = {
      displayManager.sessionPackages = mkIf (! cfg.withUWSM) [cfg.package];
      graphical-desktop.enable = mkDefault true;
    };
  };
}
