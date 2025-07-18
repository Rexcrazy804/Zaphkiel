{
  stdenvNoCC,
  fetchFromGitHub,
  python313Packages,
}:
stdenvNoCC.mkDerivation (final: {
  pname = "Gnomon";
  version = "1.2";
  src = fetchFromGitHub {
    owner = "indestructible-type";
    repo = "Gnomon";
    hash = "sha256-7+4N2XFRfZ5tZnECQPcuejq4ZPGoVsIWF8u+85TGURk=";
    rev = "7517c821773e1df27a04288fa1cf31f8abea36e7";
  };

  nativeBuildInputs = [python313Packages.fontmake];

  buildPhase = ''
    cd Source/Gnomon*\ Web/
    fontmake -o variable -m gnomon.designspace
  '';

  installPhase = ''
    mkdir -p $out/share/fonts/truetype
    cp variable_ttf/gnomon-VF.ttf $out/share/fonts/truetype
  '';
})
