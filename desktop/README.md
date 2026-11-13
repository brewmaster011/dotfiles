# Desktop Package

The Linux desktop layer, shared by `hyprland` and `dwm`: terminal, keyboard
remapping, notifications, audio, the ssh-agent service and statusbar scripts.
Stowed on top of `common` and `dev`, below a window manager and a host package:

```bash
make stow PACKAGES='common dev desktop hyprland cosmo'
```

## Contents

| Directory | Description |
|-----------|-------------|
| `alacritty/` | Terminal: base config + Linux window settings (`os.toml`) |
| `dunst/` | Notification daemon |
| `kanata/` | Keyboard remapper (home row mods) |
| `pipewire/` | Starts wireplumber and pipewire-pulse (no systemd) |
| `runit/` | User services (SSH agent) |
| `scripts/` | Statusbar scripts, playerctl hooks |
| `zsh/` | `SSH_AUTH_SOCK` (`env.d`), `MOZ_USE_XINPUT2` (`rc.d`), WireGuard/Spotify/wifipass aliases |

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

## Runit Services

User-level runit services in `runit/sv/`:

### SSH Agent

Manages SSH agent with a predictable socket path at `~/.ssh/ssh_auth_sock`.
`zsh/env.d/30-desktop.zsh` points `SSH_AUTH_SOCK` there for every zsh
(Hyprland's `core/env.lua` does the same for GUI launches).

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
| runit | `runit` | Service manager |
| playerctl | `playerctl` | Media controls |
