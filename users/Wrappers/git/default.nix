{
  pkgs,
  username ? throw "Please override username",
  email ? throw "Please override email",
}:
pkgs.symlinkJoin {
  name = "git";
  paths = [
    pkgs.git
  ];

  buildInputs = [
    pkgs.makeWrapper
  ];

  postBuild = ''
    wrapProgram $out/bin/git \
    --add-flags '-c user.name="${username}" -c user.email="${email}"'
  '';
}
