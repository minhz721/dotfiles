#!/bin/bash

send_notification() {

    volume="$(pamixer --get-volume)"
    mute_status="$(pamixer --get-mute)"

    if [[ "$mute_status" == "true" ]]; then
        icon="audio-volume-muted"
        message="Muted"
    elif (("$volume" > 70)); then
        icon="audio-volume-high"
        message="$volume%"
    elif (("$volume" > 30)); then
        icon="audio-volume-medium"
        message="$volume%"
    else
        icon="audio-volume-low"
        message="$volume%"
    fi

    notify-send "Volume Control" "Volume: $message" -i "$icon" -u normal -t 2000 -h string:x-dunst-stack-tag:volume_notification
}

case "$1" in
up)
    pactl set-sink-volume 0 +5%
    send_notification
    ;;
down)
    pactl set-sink-volume 0 -5%
    send_notification
    ;;
mute)
    pamixer --toggle-mute
    send_notification
    ;;
*)
    echo "Cách dùng: $0 {up|down|mute}"
    exit 1
    ;;
esac

