{
  stdenv,
  lib,
  go,
  winboat,
  buildGoModule,
  writableTmpDirAsHomeHook,
}:
stdenv.mkDerivation (final: {
  pname = "winboat-guest-server";
  inherit (winboat) src version;

  nativeBuildInputs = [
    go
    writableTmpDirAsHomeHook
  ];

  buildPhase = let
    guestDrv = buildGoModule {
      inherit (final) version src;
      modRoot = "guest_server";
      pname = "winboat-server";
      vendorHash = "sha256-JglpTv1hkqxmcbD8xmG80Sukul5hzGyyANfe+GeKzQ4=";
    };
  in ''
    cd guest_server

    export GOOS=windows
    export GOARCH=amd64
    export PACKAGE=winboat-server
    export BUILD_TIMESTAMP=$(date '+%Y-%m-%dT%H:%M:%S')
    export LDFLAGS=(
      "-X 'main.Version=${final.version}'"
      "-X 'main.CommitHash=${final.src.revision}'"
      "-X 'main.BuildTimestamp=''${BUILD_TIMESTAMP}'"
    )

    cp -r --reflink=auto "${guestDrv.goModules}" vendor

    mkdir -p $out
    go build -ldflags="''${LDFLAGS[*]}" -o $out/winboat_guest_server.exe *.go
  '';

  meta = {
    description = "winboat guest server";
    license = lib.licenses.mit;
  };
})
