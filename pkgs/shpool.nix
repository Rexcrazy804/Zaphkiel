{
  sources,
  rustPlatform,
}:
rustPlatform.buildRustPackage (final: {
  inherit (sources.shpool) version;
  pname = "shpool";
  src = sources.shpool;

  cargoLock.lockFile = final.src + /Cargo.lock;
  enableParallelBuilding = true;
  doCheck = false;

  postInstall = ''
    install -Dm444 systemd/shpool.service $out/share/systemd/user/shpool.service
    install -Dm444 systemd/shpool.socket $out/share/systemd/user/shpool.socket
  '';

  meta.mainProgram = "shpool";
})
