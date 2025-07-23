#!/usr/bin/env bash

IFS=":"
read -a SESSIONS <<< $1

ENTRIES=()

# jesus christ I really hate this shity bash crap
for SES in ${SESSIONS[@]}; do
  # TODO for add each entry to the ENTRIES rather than just the HEAD
  # this currently works for nix but for non nix this may not be the case
  ENTRIES+=($(find $SES -name "*.desktop" | head -1))
done

# thank fucking god I know how to fucking use awk
for ENTRY in ${ENTRIES[@]}; do
  cat $ENTRY | awk 'BEGIN {FS="="} /Name/ { NAME=$2} /Exec/ {print NAME","$2}'
done
