{
  writers,
  writeAwk,
  npins,
}: let
  betterShow = writeAwk "betterShow" ''
    BEGIN { print "PIN FROZEN REPOSITORY REVISION" }
    /^\w.*:/ { split($1, BUF, ":"); PIN=BUF[1]; REPO="UNKNOWN"; REVISION="UNKNOWN";}
    /repository: / { REPO=$2 }
    /revision:/ { REVISION=$2 }
    /frozen:/ { print PIN, $2, REPO, REVISION }
  '';
in
  writers.writeFishBin "npins-show" ''
    ${npins}/bin/npins show | ${betterShow} | column -t
  ''
