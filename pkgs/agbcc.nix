{
  fetchFromGitHub,
  stdenv,
  gcc-arm-embedded-14,
}:
stdenv.mkDerivation {
  pname = "agbcc";
  version = "unstable";
  src = fetchFromGitHub {
    owner = "pret";
    repo = "agbcc";
    rev = "da598c1d918402c42c0c0d7128ba14567f3175e9";
    hash = "sha256-/7SM2bRuz44WQiomMYqkf4pXge0ypSNViVu26FnEi2Q=";
  };

  nativeBuildInputs = [
    gcc-arm-embedded-14
  ];

  buildPhase = ''
    ./build.sh
  '';

  installPhase = ''
    mkdir -p $out
    ./install.sh $out

    mv $out/tools/agbcc/* $out/
    rm -rf $out/tools
  '';
}
