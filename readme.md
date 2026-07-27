### My dotfiles

- Don't copy :))

- Dump config
```
dconf dump /org/nemo/ > nemo_dconf_backup.txt

```
- Load config

```
dconf load /org/nemo/ < nemo_dconf_backup.txt
```