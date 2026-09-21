# Hack to bypass local restrictions on discord
{
  fetchFromGitHub,
  stdenv,
  symlinkJoin,
  makeWrapper,
}:
stdenv.mkDerivation (final: {
  pname = "drover";
  version = "unstable-b9769b9";

  src = fetchFromGitHub {
    owner = "SimoHypers";
    repo = "discord-drover";
    rev = "b9769b908f00309c60396468fc0bc913ac32f9fb";
    hash = "sha256-Yct0mHmnssXsC1R7647/H5LdnoVQmx9lXhuG2aBU4mo=";
  };

  buildPhase = ''
    gcc -shared -fPIC -O2 \
      -o drover.so \
      linux/drover.c \
      -ldl -lpthread
  '';

  installPhase = ''
    mkdir -p $out/lib
    install -Dm444 drover.so $out/lib/drover.so
  '';

  passthru.wrapWithDrover = discord:
    symlinkJoin {
      inherit (discord) pname version meta;
      paths = [discord final.finalPackage];
      nativeBuildInputs = [makeWrapper];

      postBuild = ''
        wrapProgram $out/bin/discord \
          --prefix LD_PRELOAD : "$out/lib/drover.so"

        wrapProgram $out/bin/Discord \
          --prefix LD_PRELOAD : "$out/lib/drover.so"
      '';
    };
})
