## Dump shortcut

```
dconf dump /org/cinnamon/desktop/keybindings/ > ~/dotfiles/arch-linux/cinnamon_custom_keybindings.dconf
```

## Load shortcut

```
dconf load /org/cinnamon/desktop/keybindings/ < ~/dotfiles/arch-linux/cinnamon_custom_keybindings.dconf

```

## Disable recent files **nemo**

```
dconf write /org/gnome/desktop/privacy/remember-recent-files false
```

## Dump config nemo

```
 dconf dump /org/cinnamon/desktop/privacy/  > ~/dotfiles/arch-linux/config_nemo.dconf
```

## Load config nemo

```
 dconf load /org/cinnamon/desktop/privacy/  < ~/dotfiles/arch-linux/config_nemo.dconf
```

## Setting fcitx5

```
sudo nano /usr/share/applications/google-chrome.desktop
```

- Find line **Exec** and replace

```
Exec=/usr/bin/google-chrome-stable --enable-features=UseOzonePlatform --ozone-platform=wayland --enable-wayland-ime %U
```

- Uninstall Xdm
```
sudo pacman -Rns xdman_gtk


sudo rm -rf /opt/xdman
sudo rm -f /usr/bin/xdman
sudo rm -f /usr/share/applications/xdman.desktop
```