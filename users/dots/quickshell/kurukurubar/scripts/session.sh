#!/usr/bin/env bash
awk 'BEGIN {
  FS="="; 
  ARGI=1;
}
/Name=/ { NAME=$2 } 
/Exec=/ {
  FPATHLEN = split(ARGV[ARGI], FPATH, "/")
  print FPATH[FPATHLEN]","NAME","$2; 
  ARGI += 1;
}
' $(find $1 -name "*.desktop")
