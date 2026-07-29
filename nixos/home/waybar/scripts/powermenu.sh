#!/usr/bin/env bash

# Options
op_lock="🔒 Lock Screen"
op_logout="🚪 Log Out"
op_suspend="🌙 Suspend"
op_reboot="🔄 Reboot"
op_poweroff="⚡ Power Off"

options="$op_lock\n$op_logout\n$op_suspend\n$op_reboot\n$op_poweroff"

# Launch Fuzzel in dmenu mode
chosen=$(echo -e "$options" | fuzzel --dmenu \
    --prompt="⚡ Power Menu: " \
    --lines=5 \
    --width=25 \
    --font="JetBrainsMono Nerd Font:size=12")

# Execute selected option
case "$chosen" in
    "$op_lock")
        hyprlock
        ;;
    "$op_logout")
        niri msg action quit --skip-confirmation
        ;;
    "$op_suspend")
        systemctl suspend
        ;;
    "$op_reboot")
        systemctl reboot
        ;;
    "$op_poweroff")
        systemctl poweroff
        ;;
esac