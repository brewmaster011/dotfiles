-- Framework 13 laptop. Loaded by hyprland.lua.

-- Monitors are matched by EDID description (stable across ports/replugs),
-- not by DP-N names. Confirm strings with `hyprctl monitors all` when docked.
hl.monitor({ output = "eDP-1", mode = "2256x1504@60Hz", position = "auto", scale = 1.175 })
-- hl.monitor({ output = "eDP-1", disabled = true })
-- TODO fill in desc: for these next time they're connected:
-- hl.monitor({ output = "desc:???", mode = "2560x1080@74.99", position = "auto", scale = 1, vrr = 1 })
-- hl.monitor({ output = "desc:Lenovo Group Limited LEN T24i-20 VNA5MNX8", mode = "1920x1080", position = "auto-left", scale = 1, transform = 3 })

require("modules.laptop").setup()
require("modules.kanata").setup()
