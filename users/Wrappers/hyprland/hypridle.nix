{pkgs, ...}:
pkgs.symlinkJoin {
  name = "hypridle";
  paths = [
    pkgs.hypridle
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
      wrapProgram $out/bin/hypridle \
        --add-flags '--config ${confdir}/hypridle.conf'
    '';
}
