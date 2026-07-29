#!/usr/bin/env bash

active_engine=$(dbus-send --print-reply=literal --dest=org.fcitx.Fcitx5 /controller org.fcitx.Fcitx.Controller1.CurrentInputMethod 2>/dev/null)

if [[ "$active_engine" == *"bamboo"* ]]; then
    LABEL=" 🇻🇳 VIE "
elif [[ "$active_engine" == *"keyboard-us"* ]]; then
    LABEL=" 🇺🇸 ENG "
else
    LABEL=" ⌨️ IM "
fi

/usr/bin/qtile cmd-obj -o widget fcitx5_layout -f update -a "$LABEL"
