-- Framework 13 laptop. Loaded by hyprland.lua.

-- Docked it uses the same desk as cosmo; the built-in panel turns off while
-- a desk screen is connected and back on when undocked.
require("modules.monitors").setup({
    layout  = "desk",
    builtin = { output = "eDP-1", mode = "2256x1504@60Hz", position = "auto", scale = 1.175 },
})

require("modules.laptop").setup()
require("modules.kanata").setup()
