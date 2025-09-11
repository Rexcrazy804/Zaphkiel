# this doesn't refer to matugen or qs in nixpkgs intentionally
# exclusively meant to be used internally
{writers}:
writers.writeFishBin "changeWall" ''
  set image $argv[1]
  matugen image $image --json hex > ~/.config/kurukurubar/colors.json
  kurukurubar ipc call config setWallpaper (path resolve $image)
''
