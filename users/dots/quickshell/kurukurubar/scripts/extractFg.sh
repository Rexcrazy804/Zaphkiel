#!/usr/bin/env bash
SRCIMG=$1
CACHEDIR=$(realpath $2)

SRCHASH=$(sha256sum $SRCIMG | awk '{print substr($1, 0, 10)}')

DSTDIR=${CACHEDIR}/foregrounds
DSTIMG=${DSTDIR}/${SRCHASH}
mkdir -p $DSTDIR

# basically only downloads file if it doesn't exist
if ! [ -f "${DSTIMG}" ]; then
  echo "[INFO] Extracting wallpaper foreground"
  if rembg i -m birefnet-general $SRCIMG $DSTIMG; then
    echo "[INFO] Successfully extracted foreground"
  else
    echo "[ERROR] Failed to extract foreground"
  fi
else
  echo "[INFO] File in cache"
fi

echo $DSTIMG
