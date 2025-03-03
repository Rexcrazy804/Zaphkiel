#!/usr/bin/env bash

wifi_ssid=$(nmcli -t -f ACTIVE,SSID dev wifi | awk -F':' '$1=="yes" {print $2}')

if [[ -z "$wifi_ssid" ]]; then
    echo "0"
else
    echo "$wifi_ssid"
fi
