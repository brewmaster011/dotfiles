-- Per-monitor workspaces via split-monitor-workspaces, a git submodule at
-- plugins/split-monitor-workspaces. It only hands each monitor its own range of
-- workspace ids; core/tags.lua turns each range into that monitor's dwm tags 1-9
-- and owns the binds.
local M = {}

local defaults = {
    -- core/tags.lua's TAGS and waybar's hyprland/workspaces format-icons (ids
    -- 10-18 back to 1-9) assume 9; update both if this changes.
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
end

return M
