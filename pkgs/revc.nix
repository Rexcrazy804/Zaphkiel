{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  openal,
  glew,
  glfw,
  libsndfile,
  libmpg123,
  librw,
}:
stdenv.mkDerivation {
  pname = "revc";
  version = "unstable-30062025";

  src = fetchFromGitHub {
    owner = "mrxenginner";
    repo = "reVC";
    rev = "d7dd1354d258762480ab7dec56fa0553fa0e951a";
    hash = "sha256-zUexRiHiemSThpHoEJmY2/3tsn3Zxw0BRFag6u9SzWM=";
  };

  postPatch = ''
    patchShebangs printHash.sh
    substituteInPlace CMakeLists.txt \
      --replace-fail 'DESTINATION "."' 'DESTINATION "share/games/reVC/gamefiles"'

    substituteInPlace src/CMakeLists.txt \
      --replace-fail 'DESTINATION "."' 'DESTINATION "bin"'
  '';

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    openal
    glew
    glfw
    libsndfile
    libmpg123
    librw
  ];

  cmakeFlags = [
    (lib.cmakeBool "REVC_INSTALL" true)
    (lib.cmakeBool "REVC_WITH_OPUS" false)
    (lib.cmakeBool "REVC_VENDORED_LIBRW" false)
    (lib.cmakeBool "REVC_WITH_LIBSNDFILE" true)
  ];
}
