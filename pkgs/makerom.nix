# adapted from nixpkgs derivation for ctrtool
{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation (final: {
  pname = "makerom";
  version = "0.18.4";

  src = fetchFromGitHub {
    owner = "jakcron";
    repo = "Project_CTR";
    rev = "makerom-v${final.version}";
    sha256 = "sha256-XGktRr/PY8LItXsN1sTJNKcPIfnTnAUQHx7Om/bniXg=";
  };

  sourceRoot = "${final.src.name}/makerom";

  enableParallelBuilding = true;

  preBuild = ''
    make -j $NIX_BUILD_CORES deps
  '';

  # workaround for https://github.com/3DSGuy/Project_CTR/issues/145
  env.NIX_CFLAGS_COMPILE = "-O0";

  installPhase = "
    mkdir $out/bin -p
    cp bin/makerom${stdenv.hostPlatform.extensions.executable} $out/bin/
  ";

  meta = {
    mainProgram = "makerom";
    description = "A CLI tool to create CTR (Nintendo 3DS) ROM images. ";
    license = lib.licenses.mit;
    platforms = with lib.platforms; linux ++ darwin;
    maintainers = [lib.maintainers.rexies];
  };
})
