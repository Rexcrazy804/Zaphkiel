# you might wanna ask, WHY??
# I just couldn't get it to --no-wine wrapper "umu-run" for whatever reason
{
  lib,
  writers,
  writeJQ,
  jq,
  legendary-heroic,
  umu-launcher,
}: let
  inherit (lib) getExe;
  legparse = writeJQ "parseleg" ''
    "STORE=egs " +
    (.environment | to_entries | map(.key + "=" + .value) | join(" ") | gsub("UMU_ID"; "GAMEID")) +
    " ${getExe umu-launcher} "  +
    .game_directory + "/" + .game_executable + " " +
    (.egl_parameters | join(" "))
  '';
in
  writers.writeFishBin "legumulaunch" ''
    # must be piped to fish to launch
    ${getExe legendary-heroic} launch $argv[1] --no-wine --json | ${getExe jq} -r -f ${legparse}
  ''
