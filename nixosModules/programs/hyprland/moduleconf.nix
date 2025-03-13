pkgs: {
  programs.hyprland = {
    package = pkgs.wrappedPkgs.hyprland;
    enable = true;
    withUWSM = true;
  };

  # hypridle
  security.pam.services.hyprlock = { };

  # dependencies .w.
  environment.systemPackages = pkgs.wrappedPkgs.hyprland.dependencies;

  # required when kde plasma is not installed .w.
  # ask me how I knew
  services.power-profiles-daemon.enable = true;
  services.displayManager.sddm = {
    package = pkgs.kdePackages.sddm;
    extraPackages = [
      pkgs.kdePackages.qtmultimedia
    ];
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
}
