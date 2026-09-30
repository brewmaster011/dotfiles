# Hyprland Configuration

Wayland compositor setup using Hyprland with supporting tools.

## Components

| Component   | Purpose                     |
|-------------|-----------------------------|
| hyprland    | Wayland compositor          |
| hyprpaper   | Wallpaper daemon            |
| hyprlock    | Lock screen                 |
| hypridle    | Idle management             |
| hyprsunset  | Blue-light filter + screen blanking |
| waybar      | Status bar                  |
| wofi        | Application launcher        |
| dunst       | Notifications               |

## Layout

`hyprland.lua` loads `core/` and then the machine's `host.lua` (from a host stow
package). `core/tile.lua` is the default layout: dwm's `tile` as a Lua layout
(`lua:tile`), with nmaster/mfact per workspace. `core/layouts.lua` switches each
workspace between tile, float and monocle like dwm's pertag `setlayout`.
Swallowing (Alacritty) also comes from the dwm config.
Modules in `modules/` are enabled per host with `require("modules.<name>").setup(opts)`:

| Module             | What it does                                                        |
|--------------------|---------------------------------------------------------------------|
| `monitors`         | Screen catalog + named desk layouts (matched by EDID) and the fallback rule; optional built-in panel that turns off while docked |
| `laptop`           | Touchpad, 3-finger workspace swipe, backlight keys                  |
| `nvidia`           | NVIDIA Wayland env vars                                             |
| `kanata`           | Swallows kanata's F24 home-row-mod marker key                       |
| `split-workspaces` | Per-monitor workspaces via the `plugins/split-monitor-workspaces` submodule; replaces the global `Super + 0-9` binds |

## Autostart

These services start automatically with Hyprland:

- `pipewire` - Audio server
- `dunst` - Notification daemon
- `waybar` - Status bar
- `hyprpaper` - Wallpaper
- `hypridle` - Idle manager
- `hyprsunset` - Blue-light filter (neutral by default) and hypridle's screen blanking
- `hyprpolkitagent` - Polkit authentication
- `runsvdir` - User runit services (see `linux/` package)
- SSH agent with key loading

## Default Applications

Set at the top of `core/binds.lua`:

| Variable      | Application |
|---------------|-------------|
| `terminal`    | alacritty   |
| `fileManager` | nautilus    |
| `menu`        | wofi        |

## Keybindings

Main modifier: `Super` (Windows key)

### General

| Binding              | Action                    |
|----------------------|---------------------------|
| `Super + Return`     | Open terminal             |
| `Super + P`          | Open app launcher (wofi)  |
| `Super + Shift + C`  | Close active window       |
| `Super + Shift + Ctrl + M` | Exit Hyprland       |
| `Super + E`          | Open file manager         |
| `Super + W`          | Open Chromium             |
| `Super + Shift + Space` / `V` | Toggle floating   |
| `Print`              | Screenshot (grim)         |

### Tile Layout (dwm-style)

| Binding                  | Action                                          |
|--------------------------|-------------------------------------------------|
| `Super + J` / `K`        | Focus next / previous window in the stack       |
| `Super + Shift + J` / `K`| Move window down / up the stack                 |
| `Super + H` / `L`        | Shrink / grow the master area (mfact)           |
| `Super + I` / `D`        | Add / remove a master (0 and up)                |
| `Super + Shift + Return` | Zoom: swap focused window with the master       |
| `Super + T` / `F` / `M`  | Tile / float / monocle layout (per workspace)   |
| `Super + Space`          | Swap back to the previous layout                |

### Workspaces

| Binding              | Action                        |
|----------------------|-------------------------------|
| `Super + 1-9,0`      | Switch to workspace 1-10 (with `split-workspaces`: 1-9 on the focused monitor) |
| `Super + Shift + 1-9,0` | Move window to workspace 1-10 (with `split-workspaces`: silently, on the same monitor) |
| `Super + Comma` / `Period` | Focus previous / next monitor |
| `Super + Shift + Comma` / `Period` | Move window to previous / next monitor |
| `Super + Left` / `Right` | Switch to the adjacent workspace (no wrap)  |
| `Super + Shift + Left` / `Right` | Send window to the adjacent workspace, without following |
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
| `Super + RMB drag`   | Resize window (floating only; tiled windows use `Super + H/L`) |
| `Super + Middle click` | Toggle floating |

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
| `Super + Shift + I`       | Toggle relaxed idle profile |
| `Super + N`               | Toggle blue-light filter (6000K); also restores a blanked screen |

### Media Keys

| Key                  | Action                |
|----------------------|-----------------------|
| `XF86AudioRaiseVolume` | Volume up (5%)      |
| `XF86AudioLowerVolume` | Volume down (5%)    |
| `XF86AudioMute`      | Toggle mute           |
| `XF86AudioMicMute`   | Toggle mic mute       |
| `XF86MonBrightnessUp` | Brightness up (5%, `laptop` module)   |
| `XF86MonBrightnessDown` | Brightness down (5%, `laptop` module)|
| `XF86AudioPlay/Pause`| Play/pause (playerctl)|
| `XF86AudioNext`      | Next track            |
| `XF86AudioPrev`      | Previous track        |

## Idle Behavior (hypridle)

| Timeout | Action                         |
|---------|--------------------------------|
| 1 min   | Blank screens                  |
| 10 min  | Lock and suspend system        |

Blanking sets hyprsunset's gamma to 0 instead of turning the displays off with
DPMS: black is as good as off for the OLED, and the DisplayPort link stays up,
avoiding the NVIDIA DSC link-training failure on wake. Any input un-blanks.
The session only locks when it suspends.
`Super + Shift + I` toggles the relaxed profile (blank 1m, lock and suspend 60m).

## Waybar Modules

Left: workspaces, window title  
Center: clock (click for alternate date format)  
Right: battery, power profile, backlight, volume, bluetooth, network, tray

Click actions:
- Network icon: opens nm-connection-editor
- Bluetooth icon: opens blueman-manager
- Volume icon: opens wiremix in terminal

## Environment Variables

Notable variables set in `core/env.lua`:

- `SSH_AUTH_SOCK` - SSH agent socket
- `SSH_ASKPASS` - wofi-based askpass script for GUI prompts
- `GRIM_DEFAULT_DIR` - Screenshot directory
- `GTK_THEME` / `ICON_THEME` - Sweet-mars / Papirus-Dark
- Scaling is done per monitor by the compositor (eDP-1 at 1.175); no GDK_SCALE/QT_SCALE_FACTOR
- `ELECTRON_OZONE_PLATFORM_HINT` - Wayland for Electron apps

## Requirements

- hyprland, hyprpaper, hyprlock, hypridle, hyprsunset
- waybar, wofi, dunst
- pipewire (audio)
- grim (screenshots)
- playerctl (media controls)
- brightnessctl (backlight)
- wpctl (volume via wireplumber)
- nm-connection-editor, blueman (GUI for network/bluetooth)
