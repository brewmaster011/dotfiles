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
-- dispatches focus, and it also covers monocle workspaces. Tiled windows can't be resized with the mouse (Hyprland
-- hands Lua layouts no drag delta) - same as dwm, where mfact is keyboard-only.
local M = {}

local NMASTER = 1
local MFACT   = 0.55

-- monitor id -> window ids, top of stack first (dwm's per-monitor client list)
local stacks = {}
-- workspace id -> { nmaster, mfact }
local workspaces = {}

local function target_id(target)
    local window = target.window
    return window and tostring(window.stable_id) or ("target:" .. target.index)
end

local function window_monitor_id(window)
    local ws = window.workspace
    local mon = ws and ws.monitor or window.monitor
    return mon and mon.id
end

local function workspace_state(ws_id)
    local key = ws_id or "none"
    local ws = workspaces[key]
    if not ws then
        ws = { nmaster = NMASTER, mfact = MFACT }
        workspaces[key] = ws
    end
    return ws
end

local function stack_of(mon_id)
    local key = mon_id or "none"
    stacks[key] = stacks[key] or {}
    return stacks[key], key
end

-- The workspace's settings, its monitor's stack and that monitor's id.
local function ctx_state(ctx)
    for _, target in ipairs(ctx.targets) do
        local window = target.window
        if window and window.workspace then
            local stack, mon_id = stack_of(window_monitor_id(window))
            return workspace_state(window.workspace.id), stack, mon_id
        end
    end
    local stack, mon_id = stack_of(nil)
    return workspace_state(nil), stack, mon_id
end

local function index_of(tbl, value)
    for i, v in ipairs(tbl) do
        if v == value then return i end
    end
end

-- Drop ids of windows that are gone or left the monitor, and attach new ones at
-- the top of the stack. Windows waiting on the monitor's other workspaces keep
-- their place. Returns id -> target for this pass and the ids of this pass in
-- stack order.
local function sync_order(stack, mon_id, ctx)
    local targets = {}
    for _, target in ipairs(ctx.targets) do
        targets[target_id(target)] = target
    end

    local on_monitor = {}
    for _, w in ipairs(hl.get_windows()) do
        if window_monitor_id(w) == mon_id then on_monitor[tostring(w.stable_id)] = true end
    end

    local order = {}
    for _, id in ipairs(stack.order or {}) do
        if targets[id] or on_monitor[id] then table.insert(order, id) end
    end

    -- ctx.targets is in insertion order, so attaching each unknown one at the
    -- front leaves the newest window on top.
    for _, target in ipairs(ctx.targets) do
        local id = target_id(target)
        if not index_of(order, id) then table.insert(order, 1, id) end
    end

    stack.order = order

    local visible = {}
    for _, id in ipairs(order) do
        if targets[id] then table.insert(visible, id) end
    end
    return targets, visible
end

local function active_id(ctx)
    for _, target in ipairs(ctx.targets) do
        local window = target.window
        if window and window.active then return target_id(target) end
    end
end

local function tile(ctx)
    local ws, stack, mon_id = ctx_state(ctx)
    local targets, order    = sync_order(stack, mon_id, ctx)
    local n = #order
    if n == 0 then return end

    local area = ctx.area
    local mw   = area.w
    if n > ws.nmaster then
        mw = ws.nmaster > 0 and area.w * ws.mfact or 0
    end

    local masters = math.min(n, ws.nmaster)
    local my, ty = 0, 0
    for i, id in ipairs(order) do
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

-- Swap two ids in the monitor's stack.
local function swap(stack, a, b)
    local i, j = index_of(stack.order, a), index_of(stack.order, b)
    stack.order[i], stack.order[j] = stack.order[j], stack.order[i]
end

local function layout_msg(ctx, msg)
    local ws, stack, mon_id = ctx_state(ctx)
    local _, order = sync_order(stack, mon_id, ctx)

    local command, arg = msg:match("^(%S+)%s*(%S*)")
    local id = active_id(ctx)
    local i  = id and index_of(order, id)

    if command == "incnmaster" then
        ws.nmaster = math.max(ws.nmaster + (tonumber(arg) or 1), 0)
    elseif command == "mfact" then
        local delta = tonumber(arg)
        if not delta then return "tile: mfact expects a delta like +0.05" end
        ws.mfact = math.min(math.max(ws.mfact + delta, 0.05), 0.95)
    elseif command == "zoom" then
        if not i or #order < 2 then return true end
        -- the master swaps with the next tiled window, anything else goes on top
        local zoomed = i == 1 and order[2] or id
        table.remove(stack.order, index_of(stack.order, zoomed))
        table.insert(stack.order, 1, zoomed)
    elseif command == "movestack" then
        if not i or #order < 2 then return true end
        local j = (i - 1 + (tonumber(arg) or 1)) % #order + 1
        swap(stack, order[i], order[j])
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

        -- monocle ignores focus requests for windows behind the front one
        if active.workspace.tiled_layout == "monocle" and not active.floating then
            hl.dispatch(hl.dsp.layout(dir > 0 and "cyclenext" or "cycleprev"))
            return
        end

        local all, windows = {}, {}
        for _, w in ipairs(hl.get_workspace_windows(active.workspace.id) or {}) do
            if w.mapped and not w.hidden then
                table.insert(all, w)
                windows[tostring(w.stable_id)] = w
            end
        end

        local list = {}
        for _, id in ipairs(stack_of(window_monitor_id(active)).order or {}) do
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
