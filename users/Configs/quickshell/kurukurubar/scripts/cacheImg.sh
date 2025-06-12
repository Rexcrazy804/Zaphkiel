#!/usr/bin/env bash

URL=$1
CACHEDIR=$2

# my bash skills are zero
# https://stackoverflow.com/questions/1199613/extract-filename-and-path-from-url-in-bash-script

FILENAME=${URL##*/}
mkdir -p $CACHEDIR
# basically only downloads file if it doesn't exist
if ! [ -f "${CACHEDIR}/${FILENAME}" ]; then
  curl $URL > "${CACHEDIR}/${FILENAME}"
fi
