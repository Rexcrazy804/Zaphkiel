pkgs: {
  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };
  programs.hyprlock.enable = true;

  # dependencies .w.
  environment.systemPackages = [
    pkgs.hyprpanel
    # Theme
    pkgs.rose-pine-cursor
    pkgs.rose-pine-hyprcursor
    pkgs.rose-pine-icon-theme
    pkgs.rose-pine-gtk-theme

    # utility
    pkgs.wl-clipboard
    pkgs.cliphist
    pkgs.grim
    pkgs.slurp
    pkgs.brightnessctl
    pkgs.hyprsunset
    pkgs.trashy
    pkgs.fuzzel
    pkgs.yazi
    (pkgs.flameshot.override {enableWlrSupport = true;})
  ];

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
