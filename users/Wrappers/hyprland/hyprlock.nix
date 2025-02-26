{pkgs, ...}:
pkgs.symlinkJoin {
  name = "hyprlock";
  paths = [
    pkgs.hyprlock
  ];

  buildInputs = [
    pkgs.makeWrapper
  ];

  # basically I am not sure if I want it to be immutable just yet so we are gonna roll with this for now
  postBuild = ''
    wrapProgram $out/bin/hyprlock \
      --add-flags '--config /home/rexies/nixos/users/Wrappers/hyprland/hyprlock.conf'
  '';
}
