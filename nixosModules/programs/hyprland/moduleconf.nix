pkgs: let
  # small script to send files over kde connect on yazi
  kde-send = pkgs.writers.writeNuBin "kde-send" ''
    def main [...files] {
      let device = kdeconnect-cli -a --name-only | fzf

      for $file in $files {
        kdeconnect-cli -n $"($device)" --share $"($file)"
      }
    }
  '';
  gpurecording = pkgs.writers.writeNuBin "gpurecording" ''
    def "main start" [] {
      notify-send -t 2000 -i nix-snowflake-white "Recording started" "Gpu screen recording has begun"
      gpu-screen-recorder -w eDP-1 -f 60 -a default_output -o $"($env.HOME)/Videos/recording-(^date +%d%h%m_%H%M%S).mp4";
      notify-send -t 2000 -i nix-snowflake-white "Recording stopped" "Gpu screen recording has concluded"
    }

    def "main stop" [] {
      ps
      | where name =~ gpu-screen-reco
      | kill -s 2 $in.0.pid
    }

    def main [] {
      print "Available subcommands:"
      print "start                 - Start gpu recording"
      print "stop                  - Stop gpu recording"
    }
  '';
  cowask = pkgs.writers.writeNuBin "cowask" ''
    def main [question] {
      cowsay $"($question)? \n (if (random bool) { 'yes lol' } else {'no fuck you' })"
    }
  '';
  flameshot = pkgs.flameshot.override {enableWlrSupport = true;};
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
    pkgs.wrappedPkgs.fzf
    flameshot

    # yazi + deps
    pkgs.yazi
    pkgs.ripdrag

    # nushell scripts
    kde-send
    gpurecording
    cowask
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
