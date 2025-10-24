# PRO TIP
# use lang:nix <some package name> on github
# to potentially find expressions for packages that are not available
# in nixpkgs and other sources.
# Its a neat trick, and I started using it because of my homie Quinz <3
#
# Github Search Optimization
# dustRacing2D
# dust racing
{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  pkg-config,
  libvorbis,
  openal,
  kdePackages,
}:
stdenv.mkDerivation {
  pname = "dust-racing-2d";
  version = "sep25-2025";

  src = fetchFromGitHub {
    owner = "juzzlin";
    repo = "dustRacing2D";
    rev = "1cb08dface778f92786bbd0d7e2f1c4180c4846c";
    hash = "sha256-pxC9cVpERPADggikaH/z09oRwWehxu5j40KfkGgkjCk=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    kdePackages.wrapQtAppsHook
  ];

  buildInputs = [
    libvorbis
    openal
    kdePackages.qtbase
    kdePackages.qttools
  ];

  cmakeFlags = [
    (lib.cmakeBool "ReleaseBuild" true)
  ];

  meta = {
    mainProgram = "dustrac-game";
    description = "Dust Racing 2D is a traditional top-down car racing game including a level editor.";
    homepage = "https://juzzlin.github.io/DustRacing2D/index.html";
    platforms = ["x86_64-linux"];
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [
      rexies
    ];
  };
}
