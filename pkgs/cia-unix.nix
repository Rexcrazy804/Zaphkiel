# when life gives you lemons
# make a nix derrivation
{
  lib,
  stdenv,
  fetchFromGitHub,
  crystal,
  ctrtool,
  ctrdecrypt,
  makerom,
  makeWrapper,
  fetchurl,
}:
stdenv.mkDerivation (final: {
  pname = "cia-unix";
  version = "unstable-19052025";

  src = fetchFromGitHub {
    owner = "shijimasoft";
    repo = "cia-unix";
    rev = "f33b9b2fc71ea8d64273477e0bf22c5be1d4d715";
    hash = "sha256-UoEK+csxE48vOpSiBXjrFSekwj7qUqLC0IzVva2AV20=";
  };

  seeddb-bin = fetchurl {
    name = "seeddb.bin";
    url = "https://raw.githubusercontent.com/ihaveamac/3DS-rom-tools/ab7a398512e565b94436ea82093f3ed1639bcd08/seeddb/seeddb.bin";
    hash = "sha256-zNzqXkRlGUFYc3RiQ27BCuSGad2WGQIoKsKGHiYNA8k=";
  };

  postPatch = let
    out = builtins.placeholder "out";
  in ''
    # substitute relative paths with paths in the out/bin directory
    substituteInPlace cia-unix.cr \
      --replace-fail '"./' '"${out}/bin/'

    substituteInPlace cia-unix.cr \
      --replace-fail 'seeddb.bin' '${final.seeddb-bin}'
  '';

  nativeBuildInputs = [
    crystal
    makeWrapper
  ];

  buildPhase = ''
    runHook preBuild

    crystal build cia-unix.cr --release --no-debug

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm777 cia-unix $out/bin/cia-unix
    install -Dm777 ${lib.getExe ctrtool} $out/bin/ctrtool
    install -Dm777 ${lib.getExe ctrdecrypt} $out/bin/ctrdecrypt
    install -Dm777 ${lib.getExe makerom} $out/bin/makerom

    runHook postInstall
  '';

  meta = {
    mainProgram = "cia-unix";
    description = "Decrypt CIA/3DS roms in UNIX environments (Linux and macOS)";
    license = lib.licenses.asl20.fullName;
    maintainers = [lib.maintainers.rexies];
  };
})
