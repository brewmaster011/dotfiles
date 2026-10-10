-- Automatic screen and keyboard backlight from the ambient light sensor and
-- screen contents (https://github.com/maximbaz/wluma). It learns from manual
-- brightness changes. Config: ~/.config/wluma/config.toml (host package).
local M = {}

function M.setup()
    -- Session start only, so a config reload doesn't spawn a second daemon.
    hl.on("hyprland.start", function()
        hl.exec_cmd("wluma")
    end)
end

return M
