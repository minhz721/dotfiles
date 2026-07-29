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
from controls import mod, keys

mod = "mod4"
alt = "mod1"
terminal = "ghostty"

# Get home path
home = str(Path.home())


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
