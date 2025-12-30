# adapted from https://github.com/NixOS/nixpkgs/pull/130089
# for reVC
{
  stdenv,
  lib,
  fetchFromGitHub,
  glfw,
  cmake,
  withTools ? false,
}:
stdenv.mkDerivation {
  pname = "librw";
  version = "unstable-2021-08-19";

  src = fetchFromGitHub {
    repo = "librw";
    owner = "aap";
    rev = "5501c4fdc7425ff926be59369a13593bb6c81b54";
    sha256 = "z3hQ0PAlwfPfgM5oFwX8rMVc/IKLTo2fgFw1/nSH87I=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    glfw
  ];

  cmakeFlags = [
    (lib.cmakeFeature "LIBRW_PLATFORM" "GL3")
    (lib.cmakeFeature "LIBRW_PLATFORM" "GL3")
    (lib.cmakeFeature "LIBRW_GL3_GFXLIB" "GLFW")
    (lib.cmakeBool "LIBRW_INSTALL" true)
    (lib.cmakeBool "LIBRW_EXAMPLES" false)
    (lib.cmakeBool "LIBRW_TOOLS" withTools)
  ];

  meta = with lib; {
    description = "A re-implementation of the RenderWare Graphics engine";
    homepage = "https://github.com/aap/librw";
    license = licenses.mit;
    maintainers = with maintainers; [luc65r];
    platforms = platforms.all;
  };
}
