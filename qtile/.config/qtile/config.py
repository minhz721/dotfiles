from libqtile import bar, layout, hook, widget, qtile
from libqtile.config import (
    Click,
    Drag,
    Group,
    Key,
    Match,
    hook,
    Screen,
)
from libqtile.lazy import lazy
from pathlib import Path
import os
import subprocess

from bar import screens

mod = "mod4"
alt = "mod1"
terminal = "ghostty"

# Get home path
home = str(Path.home())


keys = [
    # =============================== Focus =======================================
    Key([mod], "Left", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "Right", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "Down", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "Up", lazy.layout.up(), desc="Move focus up"),
    Key([mod], "space", lazy.layout.next(), desc="Focus next window"),
    # ================================ Move =======================================
    Key([mod, "shift"], "Left", lazy.layout.shuffle_left(), desc="Move window left"),
    Key([mod, "shift"], "Right", lazy.layout.shuffle_right(), desc="Move window right"),
    Key([mod, "shift"], "Down", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, "shift"], "Up", lazy.layout.shuffle_up(), desc="Move window up"),
    # ================================ Swap =======================================
    Key([mod, "shift"], "h", lazy.layout.swap_left(), desc="Swap window left"),
    Key([mod, "shift"], "l", lazy.layout.swap_right(), desc="Swap window right"),
    # ============================== Window =======================================
    Key([mod], "f", lazy.window.toggle_floating(), desc="Toggle floating"),
    Key([mod], "m", lazy.window.toggle_fullscreen(), desc="Toggle fullscreen"),
    Key(
        [mod, "shift"], "Return", lazy.layout.toggle_split(), desc="Toggle split layout"
    ),
    Key([mod], "t", lazy.next_layout(), desc="Next layout"),
    Key([mod], "q", lazy.window.kill(), desc="Kill focused window"),
    Key([mod], "n", lazy.window.toggle_minimized(), desc="Minimize window"),
    Key([mod, "shift"], "n", lazy.group.next_window(), desc="Unminimize next window"),
    # ============================== Qtile =======================================
    Key(
        [mod, "shift"],
        "r",
        lazy.spawn("bash -c ~/.config/qtile/scripts/reload_config.sh"),
        desc="Reload Qtile",
    ),
    Key([mod, "control"], "q", lazy.shutdown(), desc="Shutdown Qtile"),
    Key([mod], "l", lazy.spawn("xfce4-screensaver-command -l")),
    # ============================== Media ========================================
    Key(
        [],
        "XF86AudioRaiseVolume",
        lazy.spawn(f"{home}/.config/qtile/scripts/volumecontrol.sh up"),
        desc="Volume up",
    ),
    Key(
        [],
        "XF86AudioLowerVolume",
        lazy.spawn(f"{home}/.config/qtile/scripts/volumecontrol.sh down"),
        desc="Volume down",
    ),
    Key(
        [],
        "XF86AudioMute",
        lazy.spawn(f"{home}/.config/qtile/scripts/volumecontrol.sh mute"),
        desc="Toggle mute",
    ),
    # ============================== Launchers ===================================
    Key([mod], "e", lazy.spawn("nemo"), desc="File manager"),
    Key([mod], "b", lazy.spawn("thorium-browser"), desc="Browser"),
    Key([mod], "c", lazy.spawn("code"), desc="VS Code"),
    Key([mod], "d", lazy.spawn("rofi -show drun"), desc="App launcher"),
    Key([alt], "tab", lazy.spawn("rofi -show window"), desc="Window switcher"),
    Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),
    # Key(["mod1"], "space", lazy.spawn("lookapp"), desc="Open Look Launcher"),
    Key(
        ["shift"],
        "Control_L",
        lazy.spawn(
            "bash -c 'fcitx5-remote -t && ~/.config/qtile/scripts/update_fcitx5.sh'"
        ),
    ),
    # ============================== Screenshot ===================================
    Key(
        [mod, "shift"],
        "s",
        lazy.spawn(home + "/.config/qtile/scripts/screenshot.sh"),
        desc="Take screenshot",
    ),
    # Note: Shift + Arrows is reserved for Tiling layouts here.
    # If it conflicts with Floating Resize below, you can change [mod, "shift"] to [mod, "mod1"] (Alt)
    Key(
        [mod, "shift"],
        "Left",
        lazy.layout.shuffle_left(),
        desc="Move window to the left",
    ),
    Key(
        [mod, "shift"],
        "Right",
        lazy.layout.shuffle_right(),
        desc="Move window to the right",
    ),
    Key([mod, "shift"], "Down", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, "shift"], "Up", lazy.layout.shuffle_up(), desc="Move window up"),
    # For Tiling Layouts (MonadTall, MonadWide) Resizing
    Key(
        [mod, "control"],
        "Left",
        lazy.layout.shrink(),
        desc="Shrink master window width",
    ),
    Key([mod, "control"], "Right", lazy.layout.grow(), desc="Grow master window width"),
    Key(
        [mod, "control"],
        "Down",
        lazy.layout.grow_main(),
        desc="Grow master window height",
    ),
    Key(
        [mod, "control"],
        "Up",
        lazy.layout.shrink_main(),
        desc="Shrink master window height",
    ),
    Key([mod, "control"], "n", lazy.layout.reset(), desc="Reset window sizes"),
    # For Floating Layouts Resizing (Using Alt/Mod1 to avoid Shift conflict)
    Key(
        [mod, "mod1"],
        "Left",
        lazy.layout.resize_floating(-20, 0),
        desc="Decrease floating width",
    ),
    Key(
        [mod, "mod1"],
        "Right",
        lazy.layout.resize_floating(20, 0),
        desc="Increase floating width",
    ),
    Key(
        [mod, "mod1"],
        "Down",
        lazy.layout.resize_floating(0, 20),
        desc="Increase floating height",
    ),
    Key(
        [mod, "mod1"],
        "Up",
        lazy.layout.resize_floating(0, -20),
        desc="Decrease floating height",
    ),
]

# ============================== Groups ========================================
groups = [Group(f"{i+1}", label="") for i in range(8)]

for i in groups:
    keys.extend(
        [
            Key(
                [mod],
                i.name,
                lazy.group[i.name].toscreen(),
                desc="Switch to group {}".format(i.name),
            ),
            Key(
                [mod, "shift"],
                i.name,
                lazy.window.togroup(i.name, switch_group=True),
                desc="Switch to & move focused window to group {}".format(i.name),
            ),
        ]
    )


# ============================== Layouts ========================================
layout_theme = {
    "border_width": 2,
    "margin": 12,
    "border_focus": "#d4be98",
    "border_normal": "#24273A",
    "single_border_width": 3,
}

layouts = [
    # Tiling Layouts
    layout.MonadTall(**layout_theme),
    layout.MonadWide(**layout_theme),
    layout.RatioTile(**layout_theme),
    # Fullscreen Layout
    layout.Max(**layout_theme),
    layout.Floating(),
]


widget_defaults = dict(
    fontsize=12,
    padding=3,
    font="JetBrainsMono Nerd Font",
)
extension_defaults = [widget_defaults.copy()]


# ============================== Bar ========================================
# screens = [Screen()]
screens = screens

# Define mouse bindings for window manipulation
mouse = [
    # Mod + Left Click: Drag to move floating windows
    Drag(
        [mod],
        "Button1",
        lazy.window.set_position_floating(),
        start=lazy.window.get_position(),
    ),
    # Mod + Right Click: Drag to resize floating windows
    Drag(
        [mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()
    ),
    # Mod + Left Click (No drag): Bring a floating window to the front
    Click([mod], "Button1", lazy.window.bring_to_front()),
]


dgroups_key_binder = None
dgroups_app_rules = []  # type: list
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
floating_layout = layout.Floating(
    border_focus="#1F1D2E",
    border_normal="#1F1D2E",
    border_width=0,
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
        Match(wm_class="xdm-app"),
        Match(wm_class="Xdman"),
        Match(wm_class="Xdman-Main"),
        Match(wm_class="xdman-Main"),
        Match(wm_class="blueman-manager"),
        Match(title="XDM 2020"),
        Match(title="java-lang-Thread"),
        Match(title="mpv"),
        Match(wm_class="mpv"),
        Match(title="Mission Center"),
        Match(wm_class="java-lang-Thread"),
        Match(wm_class="fcitx5-config-qt"),
        Match(wm_class="fcitx"),
        Match(wm_class="fcitx5-configtool"),
    ],
)


# stuff
@hook.subscribe.startup_once
def autostart():
    autostartscript = "~/.config/qtile/autostart_once.sh"
    home = os.path.expanduser(autostartscript)
    subprocess.Popen([home])


from libqtile import hook


@hook.subscribe.client_new
def center_floating(window):
    if window.floating:
        window.center()


auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True

# When using the Wayland backend, this can be used to configure input devices.
wl_input_rules = None

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "QTILE"
