-- cosmo desktop (Ryzen 9 9900X, RTX 5080 on nvidia-open). Loaded by hyprland.lua.
local monitors = require("modules.monitors")

monitors.setup({ layout = "desk" })

require("modules.nvidia").setup()
require("modules.split-workspaces").setup({
    monitor_priority = {
        monitors.desc("samsung"), -- workspaces 1-9
        monitors.desc("lenovo"),  -- workspaces 10-18
    },
})
