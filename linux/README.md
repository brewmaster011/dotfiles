# Linux Package

Linux-specific configurations for desktop systems. Includes keyboard remapping, notifications, file manager, and system services.

## Contents

| Directory | Description |
|-----------|-------------|
| `dunst/` | Notification daemon |
| `kanata/` | Keyboard remapper (home row mods) |
| `ranger/` | Terminal file manager |
| `neofetch/` | System info display |
| `runit/` | User services (SSH agent) |
| `scripts/` | Statusbar scripts, playerctl hooks |
| `feh/` | Wallpaper setter (`fehbg`) |

## Kanata (Keyboard Remapper)

[Kanata](https://github.com/jtroo/kanata) provides home row mods - modifiers on the home row keys that activate when held.

### Home Row Mods

```
┌─────┬─────┬─────┬─────┬─────┬─────┬─────┬─────┬─────┐
│     │     │     │     │     │     │     │     │     │
├─────┼─────┼─────┼─────┼─────┼─────┼─────┼─────┼─────┤
│     │  A  │  S  │  D  │  F  │  J  │  K  │  L  │  ;  │
│     │ Sft │ Alt │ Met │ Ctl │ Ctl │ Met │ Alt │ Sft │
└─────┴─────┴─────┴─────┴─────┴─────┴─────┴─────┴─────┘
         ↑ Hold for modifier, tap for letter ↑
```

| Key | Tap | Hold |
|-----|-----|------|
| `CapsLock` | Escape | CapsLock |
| `A` | a | Left Shift |
| `S` | s | Left Alt |
| `D` | d | Left Meta (Super) |
| `F` | f | Left Ctrl |
| `J` | j | Right Ctrl |
| `K` | k | Right Meta (Super) |
| `L` | l | Right Alt |
| `;` | ; | Right Shift |

### Timing

- **Tap time:** 150ms (max time for a tap)
- **Hold time:** 200ms (time before hold activates)

### Running Kanata

```bash
# Run manually
sudo kanata -c ~/.config/kanata/kanata.kbd

# Or create a systemd service
```

## Dunst (Notifications)

Notification daemon with:
- Bottom-center positioning
- 2x scaling for HiDPI
- Gruvbox-inspired colors

## Ranger (File Manager)

Terminal file manager with vim-like keybindings.

### Key Ranger Bindings

| Key | Action |
|-----|--------|
| `h/j/k/l` | Navigate (vim-style) |
| `gg` / `G` | Top / Bottom |
| `H` / `L` | History back / forward |
| `Space` | Mark file |
| `yy` | Copy (yank) |
| `dd` | Cut |
| `pp` | Paste |
| `dD` | Delete |
| `cw` | Rename |
| `/` | Search |
| `n` / `N` | Next / Previous match |
| `zh` | Toggle hidden files |
| `zp` | Toggle preview |

### Directory Shortcuts

| Key | Directory |
|-----|-----------|
| `gh` | Home (`~`) |
| `ge` | `/etc` |
| `gu` | `/usr` |
| `gd` | `/dev` |
| `go` | `/opt` |
| `gm` | `/media` |
| `gr` | `/` (root) |

See `rc.conf` for the full list of keybindings.

## Runit Services

User-level runit services in `runit/sv/`:

### SSH Agent

Manages SSH agent with a predictable socket path at `~/.ssh/ssh_auth_sock`.

```bash
# The service is started via runsvdir in .xinitrc or hyprland.conf
runsvdir $HOME/.config/runit/runsvdir/current &
```

## Scripts

### Statusbar (`scripts/statusbar/`)

Scripts for the dwm status bar (dwmblocks):

| Script | Shows | Notes |
|--------|-------|-------|
| `battery.sh` | Charge level and state | Auto-detects the battery under `/sys/class/power_supply` (BAT1, axp20x-battery, ...); prints nothing on desktops |
| `brightness.sh` | Screen brightness | Reads percentages from `brightnessctl`, so it works on any backlight scale; appends keyboard backlight where present |
| `volume.sh` | Volume / mute | Via `pamixer` |
| `wifi.sh` | Wifi signal strength | Plus a lock icon when a VPN tunnel is up |
| `datetime.sh` | Date and time | |
| `misc/player` | Now playing | Via `playerctl` |

These are hardware-agnostic on purpose - the same scripts run on the Framework
laptop and the uConsole with no per-device overrides.

### Playerctl (`scripts/playerctl/`)

- `on_song_change_hook` - Sends notification with album art when song changes (for spotifyd)

## Dependencies

| Tool | Package (Arch) | Purpose |
|------|----------------|---------|
| dunst | `dunst` | Notifications |
| kanata | `kanata` (AUR) | Keyboard remapper |
| ranger | `ranger` | File manager |
| neofetch | `neofetch` | System info |
| runit | `runit` | Service manager |
| playerctl | `playerctl` | Media controls |
| brightnessctl | `brightnessctl` | Statusbar brightness |
| pamixer | `pamixer` | Statusbar volume |
| feh | `feh` | Wallpaper |
