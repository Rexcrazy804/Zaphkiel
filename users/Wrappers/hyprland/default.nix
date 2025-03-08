{pkgs, ...}:
pkgs.symlinkJoin {
  name = "hyprland";
  version = pkgs.hyprland.version;
  paths = [
    pkgs.hyprland
    pkgs.hyprpaper
  ];

  buildInputs = [
    pkgs.makeWrapper
  ];

  # basically I am not sure if I want it to be immutable just yet so we are gonna roll with this for now
  postBuild = let
    confdir = "/home/rexies/nixos/users/Wrappers/hyprland/conf";
  in
    /*
    bash
    */
    ''
      wrapProgram $out/bin/Hyprland \
        --add-flags '--config ${confdir}/hyprland.conf'
      wrapProgram $out/bin/hyprpaper \
        --add-flags '--config ${confdir}/hyprpaper.conf'
    '';

  passthru.dependencies = [
    pkgs.wl-clipboard
    pkgs.cliphist
    pkgs.grim
    pkgs.slurp
    pkgs.brightnessctl
    pkgs.hyprsunset
    pkgs.yazi

    # wrapped
    pkgs.wrappedPkgs.fuzzel
    pkgs.wrappedPkgs.swaync
    pkgs.wrappedPkgs.eww
    (pkgs.flameshot.override {enableWlrSupport = true;})
  ];

  passthru.providedSessions = ["hyprland"];
}
