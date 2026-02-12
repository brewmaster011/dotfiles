# dwm Configuration

X11 setup for dwm (dynamic window manager) on suckless stack.

> **Note**: dwm keybindings are defined in the dwm source code (config.h), which lives in a separate repository. This package only contains supporting configuration files.

## Contents

- `.xinitrc` - X session startup script
- `.config/picom/picom.conf` - Compositor settings
- `.config/xmodmap/` - Keyboard remapping (currently disabled)

## Autostart (.xinitrc)

Services started with the X session:

| Service       | Purpose                              |
|---------------|--------------------------------------|
| ssh-agent     | SSH key management                   |
| feh           | Wallpaper (via fehbg script)         |
| xcalib        | Color calibration (Framework laptop) |
| xss-lock      | Screen locker trigger                |
| slock         | Screen locker                        |
| unclutter     | Hide idle mouse cursor               |
| dwmblocks     | Status bar                           |
| picom         | Compositor                           |
| dunst         | Notifications                        |
| nm-applet     | NetworkManager tray                  |
| blueman-applet| Bluetooth tray                       |
| pipewire      | Audio server                         |
| pasystray     | PulseAudio/PipeWire tray             |

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

## Requirements

- dwm, dwmblocks, slock (from suckless)
- picom (compositor)
- feh (wallpaper)
- xcalib (color calibration)
- xss-lock, unclutter
- dunst (notifications)
- pipewire, pasystray
- nm-applet, blueman-applet
