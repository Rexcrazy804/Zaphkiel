#!/usr/bin/env bash

usage_count=$(lsmod | grep '^uvcvideo' | awk '{print $3}')
if [[ "$usage_count" -gt 0 ]]; then
    echo 1
else
    echo 0
fi

