-- cosmo desktop (Ryzen 9 9900X, RTX 5080 on nvidia-open). Loaded by hyprland.lua.

-- Lenovo (portrait, transform 3) on the left; Samsung to its right, starting
-- at x=1080 - the Lenovo's logical width once rotated (1920x1080 native,
-- scale 1, transform swaps it to 1080 wide x 1920 tall in layout coordinates).
hl.monitor({ output = "desc:Samsung Electric Company Odyssey G81SF HNBYA00203", mode = "3840x2160@240", position = "1080x0", scale = 1.25, vrr = 1 })
hl.monitor({ output = "desc:Lenovo Group Limited LEN T24i-20 VNA5MNX8", mode = "preferred", position = "0x0", scale = 1, transform = 3 })
-- Fallback for unknown monitors
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1 })

require("modules.nvidia").setup()
require("modules.split-workspaces").setup({
    monitor_priority = {
        "desc:Samsung Electric Company Odyssey G81SF", -- workspaces 1-9
        "desc:Lenovo Group Limited LEN T24i-20",       -- workspaces 10-18
    },
})
