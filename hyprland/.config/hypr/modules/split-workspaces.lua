-- Per-monitor numbered workspaces (dwm-tags-style) via split-monitor-workspaces,
-- a git submodule at plugins/split-monitor-workspaces.
-- Replaces the global SUPER + [0-9] binds from core/binds.
local M = {}

local defaults = {
    -- waybar's hyprland/workspaces format-icons maps ids 10-18 back to 1-9;
    -- update that map if this changes.
    workspace_count = 9,
    -- The library's own default is true (all tags always shown per monitor,
    -- dwm-tag-bar style). We want the old Hyprland behavior instead:
    -- only show workspaces that actually exist/have windows.
    enable_persistent_workspaces = false,
}

-- opts are passed to smw.setup(); see plugins/split-monitor-workspaces/lua/globals.lua.
-- monitor_priority takes "desc:<EDID description prefix>" so workspace ranges
-- survive port renumbering: first monitor gets ids 1-9, second 10-18, ...
function M.setup(opts)
    local ok, smw = pcall(require, "plugins.split-monitor-workspaces")
    if not ok or type(smw) ~= "table" or not smw.setup then
        hl.notification.create({ text = "split-monitor-workspaces missing: git submodule update --init", duration = 10000, icon = "warning" })
        return
    end

    local cfg = {}
    for k, v in pairs(defaults) do cfg[k] = v end
    for k, v in pairs(opts or {}) do cfg[k] = v end
    smw.setup(cfg)

    local mainMod = "SUPER"
    for i = 1, 10 do
        local key = tostring(i % 10)
        hl.unbind(mainMod .. " + " .. key)
        hl.unbind(mainMod .. " + SHIFT + " .. key)
    end
    for i = 1, smw.get_amount_of_workspaces() do
        local key = tostring(i % 10) -- 10 maps to key 0
        hl.bind(mainMod .. " + " .. key,         smw.workspace(key))
        hl.bind(mainMod .. " + SHIFT + " .. key, smw.move_to_workspace_silent(key))
    end
end

return M
