# sometimes I ask myself:
# "Do I really have build this from source?".
# Yes, yes I fucking do.
# NOTE fuck go compile times for gtk
{
  lib,
  callPackage,
  sources,
  buildGoModule,
  pkg-config,
  glib,
  wrapGAppsHook3,
  gtk3,
}:
buildGoModule (final: {
  pname = "WiiUDownloader";
  version = "nightly";
  src = sources."WiiUDownloader";

  titles-db = callPackage ./titles.nix {};

  postPatch = ''
    cp ${final.titles-db} db.go
  '';

  vendorHash = "sha256-d5BIQKUkdrGYvpB3C2YD/BoUjxT/3Z1hgrfbofPZYFw=";

  subPackages = [
    "cmd/WiiUDownloader"
  ];

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    glib
    gtk3
  ];

  passthru.titles-db = final.titles-db;

  meta = {
    mainProgram = "WiiUDownloader";
    description = "Application for downloading wiiu files";
    licenses = lib.licenses.gpl3;
    maintainers = [lib.maintainers.rexies];
    platforms = lib.platforms.all;
  };
})
