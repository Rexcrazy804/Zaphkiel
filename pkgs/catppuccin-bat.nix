{
  fetchFromGitHub,
  stdenvNoCC,
  lib,
}:
stdenvNoCC.mkDerivation (final: {
  pname = "catppuccin-bat";
  version = "unstable-${builtins.substring 0 8 final.src.rev}";

  src = fetchFromGitHub {
    repo = "bat";
    owner = "catppuccin";
    rev = "699f60fc8ec434574ca7451b444b880430319941";
    hash = "sha256-6fWoCH90IGumAMc4buLRWL0N61op+AuMNN9CAR9/OdI=";
  };

  installPhase = ''
    install -Dm 755 themes/* -t $out/themes
  '';

  meta.license = lib.licenses.mit;
})
