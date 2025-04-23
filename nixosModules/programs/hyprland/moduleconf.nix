pkgs: let
  scripts = import ./scripts.nix {inherit pkgs;};
in {
  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };
  programs.hyprlock.enable = true;
  systemd.user.services.hypridle.path = [
    pkgs.brightnessctl
  ];

  qt.enable = true;
  environment.variables = {
    QT_QPA_PLATFORM = "wayland";
    QT_QPA_PLATFORMTHEME = pkgs.lib.mkForce "qt6ct";
  };

  # dependencies .w.
  environment.systemPackages = [
    # QT dep
    pkgs.kdePackages.qt6ct
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
    pkgs.wrappedPkgs.fzf
    pkgs.wl-screenrec
    pkgs.libnotify
    pkgs.swappy

    # yazi + deps
    pkgs.yazi
    pkgs.ripdrag

    # nushell scripts
    scripts.kde-send
    scripts.gpurecording
    scripts.cowask
  ];

  # required when kde plasma is not installed .w.
  # ask me how I knew
  services.power-profiles-daemon.enable = true;
  services.upower = {
    enable = true;
    usePercentageForPolicy = true;
    criticalPowerAction = "PowerOff";
  };
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

  # Pokit agent
  security.soteria.enable = true;
}
