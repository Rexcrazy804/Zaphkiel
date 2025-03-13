{pkgs, ...}: let
  dependencies = [
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

    # wrapped
    pkgs.wrappedPkgs.fuzzel
    pkgs.wrappedPkgs.yazi
    (pkgs.flameshot.override {enableWlrSupport = true;})
  ];
in
  pkgs.symlinkJoin {
    name = "hyprland";
    version = pkgs.hyprland.version;
    paths = [
      pkgs.hyprland
      pkgs.hyprlock
      pkgs.hypridle
      # let sww from hyprpanel handle it
      # pkgs.hyprpaper
    ];

    buildInputs = [
      pkgs.makeWrapper
    ];

    # man needing to rebuild os to change hyprland config defintiely isn't my cup of tea
    postBuild = let
      confdir = "/home/rexies/nixos/users/Wrappers/hyprland/conf";
    in
      /*
      bash
      */
      ''
        wrapProgram $out/bin/Hyprland \
          --add-flags '--config ${confdir}/hyprland.conf'
        # wrapProgram $out/bin/hyprpaper \
        #   --add-flags '--config ${confdir}/hyprpaper.conf'
        wrapProgram $out/bin/hypridle \
          --add-flags '--config ${confdir}/hypridle.conf'
        wrapProgram $out/bin/hyprlock \
          --add-flags '--config ${confdir}/hyprlock.conf'
      '';

    passthru = {
      inherit dependencies;
      providedSessions = ["hyprland"];
    };
  }
