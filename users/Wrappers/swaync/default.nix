{pkgs, ...}:
pkgs.symlinkJoin {
  name = "swaync-wrapper";
  paths = [pkgs.swaynotificationcenter];
  buildInputs = [pkgs.makeWrapper];

  # practically just defaults, too lazy to configure this now
  postBuild = let 
    stylesheet = ./style.css;
    config = ./config.json;
    # stylesheet = "/home/rexies/nixos/users/Wrappers/swaync/style.css";
    # config = "/home/rexies/nixos/users/Wrappers/swaync/config.json";
  in /*bash*/''
    wrapProgram $out/bin/swaync \
    --add-flags '-c ${config}' \
    --add-flags '-s ${stylesheet}'
  '';
}
