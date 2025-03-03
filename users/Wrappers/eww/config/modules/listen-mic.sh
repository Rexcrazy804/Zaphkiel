#!/usr/bin/env bash
# returns 0: muted, 1: not running, 2: running

get_mic_status() {
    mic_id=$1

    # Check the mute status
    mute_status=$(pactl list sources | grep -A 15 "Source #$mic_id" | grep 'Mute:' | awk '{print $2}')

    # Check if the source is running
    running_status=$(pactl list sources | grep -A 15 "Source #$mic_id" | grep 'State:' | awk '{print $2}')

    if [[ -z "$mute_status" ]] || [[ -z "$running_status" ]]; then
        return 1
    fi

    # If muted, return 1
    if [[ "$mute_status" == "yes" ]]; then
        echo 0
    # If running, return 2
    elif [[ "$running_status" == "RUNNING" ]]; then
        echo 2
    else
        echo 1
    fi
}

DEFAULT_SOURCE_NAME="$(pactl get-default-source)"
DEFAULT_SOURCE_ID="$(pactl list sources short | grep "$DEFAULT_SOURCE_NAME" | awk '{print $1}')"
MUTE_STATUS="$(get_mic_status $DEFAULT_SOURCE_ID)"

echo "$MUTE_STATUS"

pactl subscribe | while read -r line; do
    if echo "$line" | grep -q "Event 'change' on source #$DEFAULT_SOURCE_ID"; then
        MUTE_STATUS="$(get_mic_status $DEFAULT_SOURCE_ID)"
        echo "$MUTE_STATUS"
        DEFAULT_SOURCE_NAME="$(pactl get-default-source)"
        DEFAULT_SOURCE_ID=$(pactl list sources short | grep "$DEFAULT_SOURCE_NAME" | awk '{print $1}')
    fi
done

