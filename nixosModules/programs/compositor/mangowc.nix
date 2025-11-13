{
  mein,
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkOption mkIf mkDefault mkForce;
  cfg = config.zaphkiel.programs.mangowc;

  # adapted from https://github.com/Vladimir-csp/uwsm/blob/master/uwsm-plugins/labwc.sh
  uwsmWithPlugin = let
    mango-plugin = ./mango-plugin.sh;
  in
    pkgs.uwsm.overrideAttrs (old: {
      postPatch =
        (old.postPatch or "")
        + ''
          cp ${mango-plugin} uwsm-plugins/mango.sh

          substituteInPlace uwsm-plugins/meson.build \
            --replace-fail "'hyprland.sh'," "'hyprland.sh', 'mango.sh',"
        '';
    });
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
