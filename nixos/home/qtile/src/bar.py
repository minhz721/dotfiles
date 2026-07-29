from libqtile import bar, widget, qtile
from libqtile.config import (
    Screen,
)
from libqtile.lazy import lazy
import os
import subprocess
from pathlib import Path

# Get home path
home = str(Path.home())

# --- Catppuccin Mocha Color Palette Definitions ---
# Place these variable definitions before your screens list
MOCHA_BASE = "#1e1e2e"  # Dark primary background
MOCHA_MANTLE = "#181825"  # Secondary dark background
MOCHA_SURFACE2 = "#585b70"  # Dimmed separators and placeholders
MOCHA_TEXT = "#ffffff"  # Primary soft white text
# MOCHA_TEXT = "#cdd6f4"  # Primary soft white text
MOCHA_SUBTEXT1 = "#bac2de"  # Secondary silver text
MOCHA_LAVENDER = "#b4befe"  # Main accent tone (borders/active highlights)
MOCHA_RED = "#f38ba8"  # Danger/Power accent tone
MOCHA_BLUE = "#89b4fa"  # Information accent tone
MOCHA_CPU = "#a6e3a1"
MOCHA_MEMORY = "#94e2d5"
MOCHA_PULSEVOLUME = "#f9e2af"
FONT = "JetBrainsMono Nerd Font"


# ---------------------------------------------------------------------------- #
#                                  Screenshot                                  #
# ---------------------------------------------------------------------------- #

# 1. Define the path layout targeting your existing screenshot script
screenshot_script_path = os.path.expanduser("~/.config/qtile/scripts/screenshot.sh")

# 2. Create the standalone icon widget instance
screenshot_widget = widget.TextBox(
    text="📸",  # Icon display profile component
    # foreground="#a6e3a1",  # Visual hex palette color property
    font=FONT,
    padding=10,
    center_aligned=True,
    fontsize=17,
    mouse_callbacks={
        "Button1": lazy.spawn(
            screenshot_script_path
        )  # Left-click handler script mapping
    },
)

# ---------------------------------------------------------------------------- #
#                                   Keybinds                                   #
# ---------------------------------------------------------------------------- #

# Define the absolute path to your markdown file safely
KEYBINDS_PATH = os.path.expanduser("~/.config/nvim/keybinds.md")

# Paste this inside your screens = [ Bar( [ ... ] ) ] structure
widget.TextBox(
    text="⌨️",
    font="sans",
    fontsize=14,
    padding=8,
    mouse_callbacks={
        # Button1 represents Left Click
        "Button1": lambda: qtile.cmd_spawn(
            f"bash -c \"grep -E -v '^#|^$' {KEYBINDS_PATH} | rofi -dmenu -i "
            "-p 'Neovim Keybindings' "
            "-theme-str 'window {width: 35%; border: 2px; border-color: #51afef;} listview {lines: 12;}'\""
        )
    },
)


screens = [
    Screen(
        top=bar.Bar(
            [
                widget.Spacer(length=18),
                # === LEFT ===
                widget.GroupBox(
                    fontsize=17,
                    borderwidth=3,
                    highlight_method="line",
                    highlight_color=[MOCHA_BASE, MOCHA_BASE],
                    this_current_screen_border=MOCHA_LAVENDER,
                    active=MOCHA_TEXT,
                    inactive=MOCHA_SURFACE2,
                    rounded=False,
                    disable_drag=True,
                    padding_x=8,
                    padding_y=3,
                    margin_x=3,
                    font=FONT,
                ),
                widget.Spacer(length=10),
                widget.Sep(
                    linewidth=1,
                    padding=15,
                    foreground=MOCHA_SURFACE2,
                ),
                widget.TextBox(
                    text="⌨️",
                    fontsize=18,
                    mouse_callbacks={
                        "Button1": lazy.spawn(
                            f"bash -c \"grep -E -v '^#|^$' {KEYBINDS_PATH} | rofi -dmenu -i "
                            "-p 'Neovim Keybindings' "
                            f"-theme-str 'window {{width: 75%; border: 2px; border-color: {MOCHA_LAVENDER};}} listview {{lines: 18; columns: 2;}}'\""
                        )
                    },
                ),
                widget.Sep(
                    linewidth=1,
                    padding=15,
                    foreground=MOCHA_SURFACE2,
                ),
                widget.CurrentLayout(
                    fontsize=17,
                    padding=8,
                    foreground=MOCHA_TEXT,
                    font=FONT,
                ),
                widget.Spacer(),
                # === CENTER ===
                widget.Clock(
                    format="%I:%M %p, %a %Y-%m-%d",
                    font=FONT,
                    fontsize=17,
                    foreground=MOCHA_TEXT,
                    mouse_callbacks={"Button1": lazy.spawn("gsimplecal")},
                ),
                widget.Spacer(),
                # === RIGHT ===
                widget.CPU(
                    format="CPU: {load_percent:.1f}%",
                    fontsize=17,
                    padding=10,
                    update_interval=5,
                    foreground=MOCHA_CPU,
                    font=FONT,
                    mouse_callbacks={"Button1": lazy.spawn("ghostty -e btop")},
                ),
                widget.ThermalSensor(
                    format="🌡️ {temp:.0f}°C",
                    tag_sensor="Tctl",
                    fontsize=17,
                    padding=10,
                    update_interval=2,
                    metric=True,
                    threshold=75,
                    foreground=MOCHA_SUBTEXT1,
                    font=FONT,
                    mouse_callbacks={"Button1": lazy.spawn("ghostty -e btop")},
                ),
                widget.Sep(
                    linewidth=1,
                    padding=15,
                    foreground=MOCHA_SURFACE2,
                ),
                widget.Memory(
                    format="RAM: {MemUsed:.1f}GB",
                    measure_mem="G",
                    fontsize=17,
                    padding=10,
                    update_interval=5,
                    foreground=MOCHA_MEMORY,
                    font=FONT,
                    mouse_callbacks={"Button1": lazy.spawn("ghostty -e btop")},
                ),
                widget.Sep(
                    linewidth=1,
                    padding=15,
                    foreground=MOCHA_SURFACE2,
                ),
                widget.PulseVolume(
                    fmt="  {}",
                    fontsize=17,
                    padding=3,
                    foreground=MOCHA_PULSEVOLUME,
                    mouse_callbacks={
                        "Button1": lazy.spawn(
                            f"{home}/.config/qtile/scripts/volumecontrol.sh mute"
                        )
                    },
                    font=FONT,
                ),
                widget.Sep(
                    linewidth=1,
                    padding=15,
                    foreground=MOCHA_SURFACE2,
                ),
                widget.Systray(),
                widget.Sep(
                    linewidth=1,
                    padding=15,
                    foreground=MOCHA_SURFACE2,
                ),
                screenshot_widget,
                widget.Sep(
                    linewidth=1,
                    padding=15,
                    foreground=MOCHA_SURFACE2,
                ),
                widget.TextBox(
                    text="",
                    fontsize=18,
                    padding=15,
                    foreground=MOCHA_BLUE,
                    mouse_callbacks={
                        "Button1": lazy.spawn(
                            "bash -c ~/.config/qtile/scripts/wallpaper-select.sh"
                        )
                    },
                    font=FONT,
                ),
                widget.Sep(
                    linewidth=1,
                    padding=15,
                    foreground=MOCHA_SURFACE2,
                ),
                widget.TextBox(
                    text="",
                    fontsize=18,
                    padding=15,
                    foreground=MOCHA_RED,
                    mouse_callbacks={
                        "Button1": lazy.spawn(
                            "bash -c ~/.config/rofi/scripts/powermenu.sh"
                        )
                    },
                    font=FONT,
                ),
                widget.Spacer(length=18),
            ],
            size=38,
            margin=[10, 10, 10, 10],
            background=MOCHA_BASE,
            opacity=0.95,
        ),
        wallpaper_mode="center",
    ),
]
