-- Framework 13 laptop. Loaded by hyprland.lua.
local monitors = require("modules.monitors")

-- Docked it uses the same desk as cosmo; the built-in panel turns off while
-- a desk screen is connected and back on when undocked.
monitors.setup({
    layout  = "desk",
    builtin = {
        output   = "eDP-1",
        mode     = "2256x1504@60Hz",
        position = "auto",
        scale    = 1.175,
        -- Panel profile for the BOE NE135FBM-N41; icc needs an absolute path.
        icc      = os.getenv("HOME") .. "/.config/color-calibration/BOE_CQ_______NE135FBM_N41_03.icm",
    },
})

require("modules.laptop").setup()
require("modules.kanata").setup()
require("modules.wluma").setup()
-- Same per-monitor workspaces as cosmo when docked. eDP-1 goes last so it
-- never shifts the desk screens' ranges while docking.
require("modules.split-workspaces").setup({
    monitor_priority = {
        monitors.desc("samsung"), -- workspaces 1-9
        monitors.desc("lenovo"),  -- workspaces 10-18
        "eDP-1",                  -- 1-9 when booted undocked, 19-27 after undocking
    },
})
