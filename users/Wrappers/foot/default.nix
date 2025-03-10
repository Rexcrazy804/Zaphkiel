{pkgs, ...}:
pkgs.symlinkJoin {
  name = "foot-wrapper";
  paths = [pkgs.foot];
  buildInputs = [pkgs.makeWrapper];

  postBuild = let
    config_dir = ./foot.ini;
  in
    /*
    bash
    */
    ''
      wrapProgram $out/bin/foot \
      --add-flags "-c ${config_dir}"
    '';

  meta.mainProgram = "foot";
}
