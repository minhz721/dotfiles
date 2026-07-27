#!/bin/sh

if bluetoothctl show | grep -q "Powered: yes"; then

    if bluetoothctl info | grep -q "Connected: yes"; then
        echo "%{F#FCDE64}%{F-} Connected"

        # device=$(bluetoothctl info | grep 'Alias:' | sed 's/Alias: //g' | tr -d '\n')
        # notify-send "Bluetooth Device Connected" "$device" -u normal
    else
        echo " On"
    fi
else
    echo "%{F#66ffffff} Off"
fi

