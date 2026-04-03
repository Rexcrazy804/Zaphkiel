{
  fetchFromGitHub,
  stdenv,
  texlive,
  texinfo,
  man,
  util-linux,
}:
stdenv.mkDerivation {
  pname = "latex2rtf";
  version = "unstable";

  src = fetchFromGitHub {
    owner = "latex2rtf";
    repo = "latex2rtf";
    rev = "f06be5983ee07293a994fc9c161564d0921230c5";
    hash = "sha256-q0TZoS79AiH0ebouDyWKYM/okAXHPpuz6zGobesMa2w=";
  };

  env.PREFIX = builtins.placeholder "out";

  nativeBuildInputs = [
    (texlive.combine {inherit (texlive) scheme-minimal texinfo;})
    texinfo
    man
    util-linux
  ];
}
