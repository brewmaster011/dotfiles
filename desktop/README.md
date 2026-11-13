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

Scripts for dwm status bar (dwmblocks):
- `battery` - Battery percentage and status
- `brightness` - Screen brightness
- `datetime` - Date and time
- `volume` - Audio volume
- `misc` - Miscellaneous info

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
