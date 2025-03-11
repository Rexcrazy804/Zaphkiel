{
  users,
  pkgs,
  lib,
  config,
  ...
}: {
  options = let
    inherit (lib) types mkEnableOption mkOption literalExpression;
  in {
    progModule.hyprland = {
      enable = mkEnableOption "Enable Hyprland";
      users = mkOption {
        type = types.listOf types.string;
        default = users;
        example = literalExpression "[\"rexies\", \"sanoys\"]";
        description = "
          list of users to include hyprland dots for
        ";
      };
    };
  };

  config = let
    cfg = config.progModule.hyprland;
    veedu = builtins.map (user:
      import ../../../lib/veedu.nix {
        user = user;
        source = ./conf;
        destination = ".config/hypr/";
      });

    configuration = {
      programs.hyprland = {
        enable = true;
        withUWSM = true;
      };

      programs.hyprlock = {
        enable = true;
      };

      services.displayManager.defaultSession = "hyprland-uwsm";
      environment.systemPackages = [
        pkgs.hyprpaper
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
        pkgs.wrappedPkgs.swaync
        pkgs.wrappedPkgs.eww
        pkgs.wrappedPkgs.yazi
        (pkgs.flameshot.override {enableWlrSupport = true;})
      ];

      systemd.user.services.hyprsunset = {
        enable = true;
        description = "starts hyprsunset for blue light filtering";
        after = ["graphical.target"];
        serviceConfig = {
          conflicts = "hypersunrise.service";
          ExecStart = "${pkgs.hyprsunset}/bin/hyprsunset -t 3000";
        };
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

      services.displayManager.sddm = {
        package = pkgs.kdePackages.sddm;
        extraPackages = [
          pkgs.kdePackages.qtmultimedia
        ];
      };

      services.power-profiles-daemon.enable = true;
    };
  in
    lib.mkIf cfg.enable (lib.mkMerge ([configuration] ++ veedu users));
}
