{
  lib,
  rustPlatform,
  fetchFromGitHub,
  openssl,
  pkg-config,
}:
rustPlatform.buildRustPackage {
  pname = "ctrdecrypt";
  version = "unstable-20122025";

  src = fetchFromGitHub {
    owner = "shijimasoft";
    repo = "ctrdecrypt";
    rev = "025d440186ace4d9cf04fbb53d2e20388555c757";
    hash = "sha256-ZUrr1vAuqW3kGHZxpHy8M8fOfhQtxkvkfVNqYiJ2ins=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  postPatch = ''
    cp ${./Cargo.lock} ./Cargo.lock
  '';

  cargoLock.lockFile = ./Cargo.lock;

  meta = {
    mainProgram = "ctrdecrypt";
    description = "Decrypt module for cia-unix";
    license = lib.licenses.gpl3;
    maintainers = [lib.maintainers.rexies];
  };
}
