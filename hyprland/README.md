# Hyprland Configuration

Wayland compositor setup using Hyprland with supporting tools.

## Components

| Component   | Purpose                     |
|-------------|-----------------------------|
| hyprland    | Wayland compositor          |
| hyprpaper   | Wallpaper daemon            |
| hyprlock    | Lock screen                 |
| hypridle    | Idle management             |
| waybar      | Status bar                  |
| wofi        | Application launcher        |
| dunst       | Notifications               |

## Autostart

These services start automatically with Hyprland:

- `pipewire` - Audio server
- `dunst` - Notification daemon
- `waybar` - Status bar
- `hyprpaper` - Wallpaper
- `hypridle` - Idle manager
- `hyprpolkitagent` - Polkit authentication
- `runsvdir` - User runit services (see `linux/` package)
- SSH agent with key loading

## Default Applications

| Variable       | Application |
|----------------|-------------|
| `$terminal`    | alacritty   |
| `$fileManager` | nautilus    |
| `$menu`        | wofi        |

## Keybindings

Main modifier: `Super` (Windows key)

### General

| Binding              | Action                    |
|----------------------|---------------------------|
| `Super + Return`     | Open terminal             |
| `Super + Space`      | Open app launcher (wofi)  |
| `Super + Shift + C`  | Close active window       |
| `Super + Shift + Ctrl + M` | Exit Hyprland       |
| `Super + E`          | Open file manager         |
| `Super + W`          | Open Chromium             |
| `Super + V`          | Toggle floating           |
| `Super + P`          | Pseudo-tile (dwindle)     |
| `Super + Shift + J`  | Toggle split (dwindle)    |
| `Print`              | Screenshot (grim)         |

### Window Focus

| Binding              | Action         |
|----------------------|----------------|
| `Super + H` / `Left` | Focus left     |
| `Super + L` / `Right`| Focus right    |
| `Super + K` / `Up`   | Focus up       |
| `Super + J` / `Down` | Focus down     |

### Workspaces

| Binding              | Action                        |
|----------------------|-------------------------------|
| `Super + 1-9,0`      | Switch to workspace 1-10      |
| `Super + Shift + 1-9,0` | Move window to workspace 1-10 |
| `Super + Tab`        | Switch to previous workspace  |
| `Super + Scroll`     | Cycle through workspaces      |

### Scratchpad (Special Workspace)

| Binding              | Action                          |
|----------------------|---------------------------------|
| `Super + S`          | Toggle scratchpad visibility    |
| `Super + Shift + S`  | Move window to scratchpad       |

### Mouse

| Binding              | Action         |
|----------------------|----------------|
| `Super + LMB drag`   | Move window    |
| `Super + RMB drag`   | Resize window  |

### MX Master 4 Mouse Buttons

| Binding                     | Action                       |
|-----------------------------|------------------------------|
| `Mouse:278`                 | Previous workspace           |
| `Super + Shift + Mouse:278` | Close active window          |
| `Mouse:277`                 | Cycle to next window         |
| `Super + Mouse:277`         | Toggle scratchpad            |
| `Super + Shift + Mouse:277` | Move window to scratchpad    |

### System

| Binding                   | Action           |
|---------------------------|------------------|
| `Super + Shift + L`       | Lock screen      |
| `Super + Shift + Ctrl + S`| Suspend          |
| `Super + B`               | Toggle waybar    |

### Media Keys

| Key                  | Action                |
|----------------------|-----------------------|
| `XF86AudioRaiseVolume` | Volume up (5%)      |
| `XF86AudioLowerVolume` | Volume down (5%)    |
| `XF86AudioMute`      | Toggle mute           |
| `XF86AudioMicMute`   | Toggle mic mute       |
| `XF86MonBrightnessUp` | Brightness up (5%)   |
| `XF86MonBrightnessDown` | Brightness down (5%)|
| `XF86AudioPlay/Pause`| Play/pause (playerctl)|
| `XF86AudioNext`      | Next track            |
| `XF86AudioPrev`      | Previous track        |

## Idle Behavior (hypridle)

| Timeout | Action          |
|---------|-----------------|
| 7 min   | Lock screen     |
| 8 min   | Turn off display|
| 10 min  | Suspend system  |

Screen automatically turns back on when resuming from sleep or on user activity.

## Waybar Modules

Left: workspaces, window title  
Center: clock (click for alternate date format)  
Right: battery, power profile, backlight, volume, bluetooth, network, tray

Click actions:
- Network icon: opens nm-connection-editor
- Bluetooth icon: opens blueman-manager
- Volume icon: opens wiremix in terminal

## Environment Variables

Notable variables set in hyprland.conf:

- `SSH_AUTH_SOCK` - SSH agent socket
- `SSH_ASKPASS` - ksshaskpass for GUI prompts
- `GRIM_DEFAULT_DIR` - Screenshot directory
- `GTK_THEME` / `ICON_THEME` - Sweet-mars / Papirus-Dark
- `GDK_SCALE` / `QT_SCALE_FACTOR` - 1.175x scaling
- `ELECTRON_OZONE_PLATFORM_HINT` - Wayland for Electron apps

## Requirements

- hyprland, hyprpaper, hyprlock, hypridle
- waybar, wofi, dunst
- pipewire (audio)
- grim (screenshots)
- playerctl (media controls)
- brightnessctl (backlight)
- wpctl (volume via wireplumber)
- nm-connection-editor, blueman (GUI for network/bluetooth)
