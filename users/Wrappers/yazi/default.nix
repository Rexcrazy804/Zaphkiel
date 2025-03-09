{pkgs, ...}:
pkgs.symlinkJoin {
  name = "yazi-wrapper";
  paths = [
    pkgs.yazi
    pkgs.ripdrag
  ];
  buildInputs = [pkgs.makeWrapper];

  postBuild = ''
    wrapProgram $out/bin/yazi \
      --set-default YAZI_CONFIG_HOME ${./config}
  '';
}
