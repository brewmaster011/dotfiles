# Framework Package

Device-specific configuration for the Framework Laptop 14.

```bash
# with Hyprland (primary)
make stow PACKAGES='common linux hyprland framework'

# with dwm (fallback)
make stow PACKAGES='common linux dwm framework'
```

## Contents

| Path | Description |
|------|-------------|
| `.config/color-calibration/` | ICC profile for the BOE panel |
| `.config/easyeffects/` | EasyEffects audio preset |
| `.config/x11/xinitrc.local` | Applies the ICC profile via `xcalib` at X startup |
| `.config/zsh/aliases/framework.aliases.sh` | Thermal and power profile aliases |

## Thermal profiles

`framework.aliases.sh` provides `performance`, `balanced`, `cool-bottom` and
`quiet`. These shell out to `smbios-thermal-ctl` (Dell) and `powerprofilesctl`,
so they only work on this hardware - which is why they live here rather than in
`linux/`.

## X11 hook

`dwm/.xinitrc` sources `~/.config/x11/xinitrc.local` when present. This package
uses that hook for colour calibration; under Hyprland the file is simply not
read.
