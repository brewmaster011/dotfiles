# dwm Configuration

X11 setup for dwm (dynamic window manager) on the suckless stack. Used by the
ClockworkPi uConsole (primary X11 machine) and available as a fallback session
on the Framework laptop.

> **Note**: dwm keybindings are defined in the dwm source code (config.h), which lives in a separate repository. This package only contains supporting configuration files.

## Contents

- `.xinitrc` - X session startup script
- `.config/picom/picom.conf` - Compositor settings

## Autostart (.xinitrc)

Services started with the X session:

| Service   | Purpose                        |
|-----------|--------------------------------|
| ssh-agent | SSH key management             |
| feh       | Wallpaper (via fehbg script)   |
| xss-lock  | Screen locker trigger          |
| slock     | Screen locker                  |
| unclutter | Hide idle mouse cursor         |
| dwmblocks | Status bar                     |
| picom     | Compositor                     |
| dunst     | Notifications                  |
| pipewire  | Audio server                   |

Network, bluetooth and volume trays (`nm-applet`, `blueman-applet`,
`pasystray`) are **not** started - the `linux/` statusbar scripts report wifi
and volume directly in dwmblocks.

### Device-specific setup

`.xinitrc` sources `~/.config/x11/xinitrc.local` if it exists, so per-machine X
quirks stay out of this package:

| Package | What its `xinitrc.local` does |
|---------|-------------------------------|
| `uconsole` | `xrandr --output DSI-1 --primary --rotate right` |
| `framework` | `xcalib` colour calibration |

### SSH agent

The session exports `SSH_AUTH_SOCK=~/.ssh/ssh_auth_sock`, matching what
`common/.config/zsh/zshrc` expects. If `runsvdir` is available the runit service
from `linux/.config/runit/` manages the agent; otherwise `.xinitrc` starts a
plain `ssh-agent` bound to that same socket.

## X Settings

```
xset r rate 450 150   # Key repeat: 450ms delay, 150ms rate
xset s off            # Disable screen blanking
```

## Picom

Compositor with:
- Shadows disabled
- Backend: glx
- VSync enabled

> On the uConsole (CM4 / VideoCore VI) the `glx` backend is untested. If the
> compositor misbehaves or is slow, switch `backend` to `"xrender"` in
> `picom.conf`.

## Requirements

- dwm, dwmblocks, slock (from suckless)
- picom (compositor)
- feh (wallpaper, from the `linux` package)
- xss-lock, unclutter
- dunst (notifications)
- pipewire
- xcalib (only for the `framework` package's colour calibration)
