#!/bin/bash

# Apply wallpaper using wal
# wal -b 282738 -i ~/Wallpaper/Aesthetic2.png &&

# input method
fcitx5 -d

/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &

# Load notification service
dunst &

# Setup Wallpaper and update colors
# nitrogen --restore &
feh --bg-fill "$(cat ~/.cache/wallpaper_current)" &

# status bar
# polybar mybar &

xfce4-screensaver &

# Start xautolock and hook it directly to xfce4-screensaver-command
xautolock \
    -time 20 \
    -locker "xfce4-screensaver-command --lock" \
    -notify 15 \
    -notifier "dunstify -u critical 'System Lock' 'Locking screen in 15 seconds...'" &

# monitor
# xrandr --output DisplayPort-0 \
#     --mode 2560x1080 \
#     --rate 120

# edra epm16f60s
xrandr --output HDMI-A-0 --mode 1920x1080 --rate 60

blueman-applet &

# Load picom
# picom &
sleep 1
if ! pgrep -x "picom" >/dev/null; then
    picom -b --config ~/.config/picom/picom.conf
fi
