{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkForce;
in {
  options.zaphkiel.programs.hyprland.enable = mkEnableOption "hyprland";
  config = mkIf config.zaphkiel.programs.hyprland.enable {
    zaphkiel.programs.compositor-common.enable = true;
    environment.systemPackages = [pkgs.hyprsunset];
    systemd.user.services.hypridle.path = mkForce [config.programs.hyprland.package];

    programs.hyprland = {
      enable = true;
      withUWSM = true;
    };

    # I could write a hypersunrise service to conflict but fuck it better to just
    # make a keybind to stop the service lol And I am less likely to forget to
    # turn the darn thing off if its right on my face
    systemd.user.timers.hyprsunset = {
      description = "Start hyprsunset after sunset";
      enable = true;
      wantedBy = ["timers.target"];
      timerConfig = {
        OnCalendar = "*-*-* 17:30:00";
      };
    };
    systemd.user.services.hyprsunset = {
      enable = true;
      description = "starts hyprsunset for blue light filtering";
      after = ["graphical.target"];
      serviceConfig = {
        ExecStart = "${pkgs.hyprsunset}/bin/hyprsunset -t 3000";
      };
    };
  };
}
