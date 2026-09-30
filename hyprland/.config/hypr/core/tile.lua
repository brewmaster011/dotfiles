-- dwm's tile() layout as a Lua layout, registered as "lua:tile".
-- See https://wiki.hypr.land/Configuring/Layouts/Custom-Layouts/
--
-- Unlike the built-in master layout, masters are a count (nmaster, 0 and up)
-- rather than a per-window flag: the first nmaster windows of the stack order
-- are masters, whatever those windows are. New windows attach at the top of
-- the stack, like dwm's attach(). nmaster and mfact are kept per workspace
-- (dwm's pertag patch).
--
-- Layout messages (hl.dsp.layout("...")):
--   incnmaster <+n|-n>   change nmaster, never below 0
--   mfact <+f|-f>        change the master area ratio, clamped to 0.05-0.95
--   zoom                 move the focused window to the top of the stack,
--                        or swap the master with the next window
--   movestack <+1|-1>    move the focused window down/up the stack
--
-- M.focusstack(dir) focuses the next/previous window in stack order (dwm
-- focusstack); it's a bind function rather than a layout message because it
-- dispatches focus. Tiled windows can't be resized with the mouse (Hyprland
-- hands Lua layouts no drag delta) - same as dwm, where mfact is keyboard-only.
local M = {}

local NMASTER = 1
local MFACT   = 0.55

-- workspace id -> { order = { window ids, top of stack first }, nmaster, mfact }
local workspaces = {}

local function target_id(target)
    local window = target.window
    return window and tostring(window.stable_id) or ("target:" .. target.index)
end

local function workspace_state(ws_id)
    local key = ws_id or "none"
    local ws = workspaces[key]
    if not ws then
        ws = { order = {}, nmaster = NMASTER, mfact = MFACT }
        workspaces[key] = ws
    end
    return ws
end

local function ctx_workspace(ctx)
    for _, target in ipairs(ctx.targets) do
        local window = target.window
        if window and window.workspace then
            return workspace_state(window.workspace.id)
        end
    end
    return workspace_state(nil)
end

local function index_of(tbl, value)
    for i, v in ipairs(tbl) do
        if v == value then return i end
    end
end

-- Drop ids that left the workspace and attach new ones at the top of the stack.
-- Returns id -> target for this pass.
local function sync_order(ws, ctx)
    local targets = {}
    for _, target in ipairs(ctx.targets) do
        targets[target_id(target)] = target
    end

    local order = {}
    for _, id in ipairs(ws.order) do
        if targets[id] then table.insert(order, id) end
    end

    -- ctx.targets is in insertion order, so attaching each unknown one at the
    -- front leaves the newest window on top.
    for _, target in ipairs(ctx.targets) do
        local id = target_id(target)
        if not index_of(order, id) then table.insert(order, 1, id) end
    end

    ws.order = order
    return targets
end

local function active_id(ctx)
    for _, target in ipairs(ctx.targets) do
        local window = target.window
        if window and window.active then return target_id(target) end
    end
end

local function tile(ctx)
    local ws      = ctx_workspace(ctx)
    local targets = sync_order(ws, ctx)
    local n       = #ws.order
    if n == 0 then return end

    local area = ctx.area
    local mw   = area.w
    if n > ws.nmaster then
        mw = ws.nmaster > 0 and area.w * ws.mfact or 0
    end

    local masters = math.min(n, ws.nmaster)
    local my, ty = 0, 0
    for i, id in ipairs(ws.order) do
        if i <= masters then
            local h = (area.h - my) / (masters - i + 1)
            targets[id]:place({ x = area.x, y = area.y + my, w = mw, h = h })
            my = my + h
        else
            local h = (area.h - ty) / (n - i + 1)
            targets[id]:place({ x = area.x + mw, y = area.y + ty, w = area.w - mw, h = h })
            ty = ty + h
        end
    end
end

local function layout_msg(ctx, msg)
    local ws = ctx_workspace(ctx)
    sync_order(ws, ctx)

    local command, arg = msg:match("^(%S+)%s*(%S*)")
    local id = active_id(ctx)
    local i  = id and index_of(ws.order, id)

    if command == "incnmaster" then
        ws.nmaster = math.max(ws.nmaster + (tonumber(arg) or 1), 0)
    elseif command == "mfact" then
        local delta = tonumber(arg)
        if not delta then return "tile: mfact expects a delta like +0.05" end
        ws.mfact = math.min(math.max(ws.mfact + delta, 0.05), 0.95)
    elseif command == "zoom" then
        if not i or #ws.order < 2 then return true end
        if i == 1 then
            ws.order[1], ws.order[2] = ws.order[2], ws.order[1]
        else
            table.remove(ws.order, i)
            table.insert(ws.order, 1, id)
        end
    elseif command == "movestack" then
        if not i or #ws.order < 2 then return true end
        local j = (i - 1 + (tonumber(arg) or 1)) % #ws.order + 1
        ws.order[i], ws.order[j] = ws.order[j], ws.order[i]
    else
        return "tile: expected incnmaster, mfact, zoom or movestack"
    end

    return true
end

hl.layout.register("tile", { recalculate = tile, layout_msg = layout_msg })

-- Focus the next (dir = 1) or previous (dir = -1) window in stack order,
-- wrapping around. Floating windows on the workspace follow the tiled ones.
function M.focusstack(dir)
    return function()
        local active = hl.get_active_window()
        if not active or not active.workspace then return end

        local all, windows = {}, {}
        for _, w in ipairs(hl.get_workspace_windows(active.workspace.id) or {}) do
            if w.mapped and not w.hidden then
                table.insert(all, w)
                windows[tostring(w.stable_id)] = w
            end
        end

        local list = {}
        for _, id in ipairs(workspace_state(active.workspace.id).order) do
            if windows[id] and not windows[id].floating then table.insert(list, windows[id]) end
        end
        for _, w in ipairs(all) do
            if w.floating then table.insert(list, w) end
        end
        if #list < 2 then return end

        local cur = 0
        for k, w in ipairs(list) do
            if w.stable_id == active.stable_id then cur = k break end
        end

        hl.dispatch(hl.dsp.focus({ window = list[(cur - 1 + dir) % #list + 1] }))
    end
end

return M
