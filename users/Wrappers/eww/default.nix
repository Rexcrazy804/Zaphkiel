{pkgs, ...}:
pkgs.symlinkJoin {
  name = "eww-wrapper";
  paths = [pkgs.eww];
  buildInputs = [pkgs.makeWrapper];

  postBuild = ''
    wrapProgram $out/bin/eww \
    --add-flags '--config ${./config}'
  '';
}
