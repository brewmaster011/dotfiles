# uConsole Package

Device-specific configuration for the [ClockworkPi uConsole](https://www.clockworkpi.com/uconsole) (CM4 handheld).

Stow this alongside `common linux dwm` — it only carries what is genuinely
uConsole hardware-specific.

```bash
make stow PACKAGES='common linux dwm uconsole'
```

## Contents

| Path | Description |
|------|-------------|
| `.config/x11/xinitrc.local` | Rotates the DSI panel to landscape at X startup |

`dwm/.xinitrc` sources `~/.config/x11/xinitrc.local` if it exists, so each
machine drops its own X quirks in via its device package (`framework/` uses the
same hook for colour calibration).

## Hardware notes

| Thing | On the uConsole |
|-------|-----------------|
| Battery | `axp20x-battery` (not `BAT1`) |
| Mains | `axp22x-ac` |
| Display | `DSI-1`, 1280x480, mounted rotated - needs `xrandr --rotate right` |
| Backlight | `backlight@0`, range 0-9 (not 0-65535) |
| Wifi | `wlan0` |

The `linux/` statusbar scripts handle all of these without a uConsole-specific
override: `battery.sh` auto-detects the battery by scanning
`/sys/class/power_supply/*/type`, and `brightness.sh` reads percentages from
`brightnessctl` rather than assuming a raw scale.

## Caveat: dunst version

The uConsole runs Debian 11 (bullseye), which ships **dunst 1.5.0**.
`linux/.config/dunst/dunstrc` uses `width`/`origin`/`progress_bar`/`gap_size`,
which require **dunst >= 1.9**, and the `dunstrc.d/` drop-in directory needs
1.10. Bullseye has no backport, so dunst must be built from source on this
device before notifications will be configured correctly.

Until dunst is upgraded, expect it to fall back to its built-in defaults and log
unknown-option warnings.

## Not installed by default

`runit` is absent on this device, so `dwm/.xinitrc` falls back to starting a
plain `ssh-agent` on the same socket path (`~/.ssh/ssh_auth_sock`) that
`common/.config/zsh/zshrc` expects. Installing `runit` switches it to the
supervised service automatically - no config change needed.
