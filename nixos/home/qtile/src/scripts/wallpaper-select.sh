
# exit 0
#!/bin/bash
#  ██╗    ██╗ █████╗ ██╗     ██╗     ██████╗  █████╗ ██████╗ ███████╗██████╗
#  ██║    ██║██╔══██╗██║     ██║     ██╔══██╗██╔══██╗██╔══██╗██╔════╝██╔══██╗
#  ██║ █╗ ██║███████║██║     ██║     ██████╔╝███████║██████╔╝█████╗  ██████╔╝
#  ██║███╗██║██╔══██║██║     ██║     ██╔═══╝ ██╔══██║██╔═══╝ ██╔══╝  ██╔══██╗
#  ╚███╔███╔╝██║  ██║███████╗███████╗██║     ██║  ██║██║     ███████╗██║  ██║
#   ╚══╝╚══╝ ╚═╝  ╚═╝╚══════╝╚══════╝╚═╝     ╚═╝  ╚═╝╚═╝     ╚══════╝╚═╝  ╚═╝
#
#  ██╗      █████╗ ██╗   ██╗███╗   ██╗ ██████╗██╗  ██╗███████╗██████╗
#  ██║     ██╔══██╗██║   ██║████╗  ██║██╔════╝██║  ██║██╔════╝██╔══██╗
#  ██║     ███████║██║   ██║██╔██╗ ██║██║     ███████║█████╗  ██████╔╝
#  ██║     ██╔══██║██║   ██║██║╚██╗██║██║     ██╔══██║██╔══╝  ██╔══██╗
#  ███████╗██║  ██║╚██████╔╝██║ ╚████║╚██████╗██║  ██║███████╗██║  ██║
#  ╚══════╝╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═══╝ ╚═════╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝
#

#!/usr/bin/env bash

# Path to the directory containing wallpaper images
WALLPAPER_DIR="$HOME/Pictures/wallpaper"

# Cache file storing the path of the currently active wallpaper
CACHE_FILE="$HOME/.cache/wallpaper_current"

# Rofi command pointing to your custom 3x3 layout configuration
ROFI_CMD="rofi -dmenu -i -config $HOME/.config/rofi/wallpaper-select.rasi"

# Scan and collect wallpaper files (jpg, jpeg, png) into an array
mapfile -t PAPERS < <(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) | sort)

# Build the structural menu layout with filenames and direct icon previews
generate_menu() {
    for img in "${PAPERS[@]}"; do
        filename=$(basename "$img")
        # Rofi syntax to pass structural data: Label\0icon\x1f/path/to/icon
        printf "%s\x00icon\x1f%s\n" "$filename" "$img"
    done
}

# Launch Rofi and capture the selected item text (filename)
SELECTED_NAME=$(generate_menu | $ROFI_CMD)

# Exit immediately if the user cancels or doesn't pick any layout
[ -z "$SELECTED_NAME" ] && echo "No choice selected. Exiting." && exit 0

# Reconstruct the absolute target path to the chosen image file
FULL_PATH="$WALLPAPER_DIR/$SELECTED_NAME"

# Fallback validation to verify the target wallpaper file exists locally
if [ ! -f "$FULL_PATH" ]; then
    echo "Error: Target image file not found on system."
    exit 1
fi

# Write the final choice location data out to system cache
echo "$FULL_PATH" > "$CACHE_FILE"

# Apply the graphic directly to the monitor matrix via feh --bg-fill
feh --bg-fill "$FULL_PATH"

# Trigger a system notification indicating operational success
notify-send "System Wallpaper Applied" "Active: $SELECTED_NAME"
