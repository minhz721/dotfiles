#!/usr/bin/env bash

# ───────────────────────────────────────────────────────────────
#                          Power Options
# ───────────────────────────────────────────────────────────────

options=(
    "shutdown:  Shutdown"
    "reboot:  Reboot"
    "lock:  Lock"
    "suspend:  Suspend"
    "logout:  Logout"
)

username=" $(whoami)"
messages=("See ya!" "Adiós, amigo!" "Catch you on the flip side!" "Powering down..." "Peace out!")
sendoff="${messages[$((RANDOM % ${#messages[@]}))]}"

# Theme rofi
theme="$HOME/.config/rofi/themes/catppuccin-mocha.rasi"


# ───────────────────────────────────────────────────────────────
#                            Rofi UI
# ───────────────────────────────────────────────────────────────

rofi_cmd() {
    rofi -dmenu \
        -p "$username" \
        -mesg "$sendoff" \
        -theme "$theme"
}

run_rofi() {
    printf "%s\n" "${options[@]}" | cut -d: -f2 | rofi_cmd
}

# ───────────────────────────────────────────────────────────────
#                        Run Commands
# ───────────────────────────────────────────────────────────────

run_cmd() {
    case "$1" in
    shutdown)
        systemctl poweroff
        ;;
    reboot)
        systemctl reboot
        ;;
    suspend)
        mpc -q pause 2>/dev/null
        amixer set Master mute
        systemctl suspend
        ;;
    logout)
        pkill -KILL -u "$USER"
        ;;
    lock)
        xfce4-screensaver-command -l
        ;;
    *)
        notify-send "Invalid option: $1"
        ;;
    esac
}

# ───────────────────────────────────────────────────────────────
#                          Main Menu
# ───────────────────────────────────────────────────────────────

# chosen="$(run_rofi)"

# # Get the action (key before colon) that matches the chosen label
# action=$(printf "%s\n" "${options[@]}" | grep -F ":$chosen" | cut -d: -f1)

# # Only run if action is not empty
# if [[ -n "$action" ]]; then
#     run_cmd "$action"
# else
#     notify-send "No action selected or invalid selection."
# fi

chosen="$(run_rofi)"

if [[ -z "$chosen" ]]; then
    exit 0
fi

action=$(printf "%s\n" "${options[@]}" | grep -F ":$chosen" | cut -d: -f1)

if [[ -n "$action" ]]; then
    run_cmd "$action"
else
    notify-send "No action selected or invalid selection."
fi