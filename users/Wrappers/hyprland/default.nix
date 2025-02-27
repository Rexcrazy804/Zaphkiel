{pkgs, ...}:
pkgs.symlinkJoin {
  name = "hyprland";
  version = pkgs.hyprland.version;
  paths = [
    pkgs.hyprland
    pkgs.hyprpaper
    pkgs.wl-clipboard
    pkgs.cliphist
    pkgs.grim
    pkgs.slurp
    pkgs.brightnessctl
    pkgs.swaynotificationcenter

    pkgs.wrappedPkgs.fuzzel
  ];

  buildInputs = [
    pkgs.makeWrapper
  ];

  # basically I am not sure if I want it to be immutable just yet so we are gonna roll with this for now
  postBuild = let 
    confdir = "/home/rexies/nixos/users/Wrappers/hyprland/conf";
  in ''
    wrapProgram $out/bin/Hyprland \
      --add-flags '--config ${confdir}/hyprland.conf'
    wrapProgram $out/bin/hyprland \
      --add-flags '--config ${confdir}/hyprland.conf'
    wrapProgram $out/bin/hyprpaper \
      --add-flags '--config ${confdir}/hyprpaper.conf'
  '';
}
