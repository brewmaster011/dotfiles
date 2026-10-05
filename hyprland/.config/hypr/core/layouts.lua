-- dwm's setlayout with the pertag patch: each workspace has a current and a
-- previous layout, Super + Space swaps them. Layouts, as in dwm's layouts[]:
--   tile     "[]="  lua:tile (core/tile.lua), the default
--   float    "><>"  Hyprland has no floating layout, so every window on the
--                   workspace is floated instead; new windows float too, and
--                   the ones floated this way are tiled again on leaving it
--   monocle  "[M]"  Hyprland's built-in monocle
-- A workspace's tiled layout is switched with a runtime workspace rule.
local M = {}

-- workspace id -> { cur, prev }. dwm starts every tag with layouts[0] and
-- layouts[1] in its two slots, so the first Super + Space goes to float.
local selected = {}
-- workspace id -> monocle workspace rule, created on first use
local monocle_rules = {}
-- workspace id -> { [stable_id] = true } windows floated by the float layout
local floated = {}

local function workspace_selector(ws)
    return ws.special and ws.name or tostring(ws.id)
end

-- box: where to put w once floating, or nil for Hyprland's own float placement
local function float_window(ws_id, w, box)
    if w.floating then return end
    hl.dispatch(hl.dsp.window.float({ action = "on", window = w }))
    if box then
        hl.dispatch(hl.dsp.window.resize({ window = w, x = box.w, y = box.h }))
        hl.dispatch(hl.dsp.window.move({ window = w, x = box.x, y = box.y }))
    end
    floated[ws_id][w.stable_id] = true
end

-- Like dwm's floating layout, windows stay at their tiled geometry. Snapshot
-- it first: floating one window re-tiles the rest.
local function enter_float(ws)
    floated[ws.id] = floated[ws.id] or {}
    local windows, boxes = hl.get_workspace_windows(ws.id) or {}, {}
    for i, w in ipairs(windows) do
        boxes[i] = { x = w.at.x, y = w.at.y, w = w.size.x, h = w.size.y }
    end
    for i, w in ipairs(windows) do
        float_window(ws.id, w, boxes[i])
    end
end

local function leave_float(ws)
    local ids = floated[ws.id]
    if not ids then return end
    floated[ws.id] = nil
    for _, w in ipairs(hl.get_workspace_windows(ws.id) or {}) do
        if ids[w.stable_id] and w.floating then
            hl.dispatch(hl.dsp.window.float({ action = "off", window = w }))
        end
    end
end

local function apply(ws, name)
    if name == "float" then enter_float(ws) else leave_float(ws) end

    local rule = monocle_rules[ws.id]
    if name == "monocle" and not rule then
        monocle_rules[ws.id] = hl.workspace_rule({ workspace = workspace_selector(ws), layout = "monocle" })
    elseif rule then
        rule:set_enabled(name == "monocle")
    end
end

local function active_state()
    local ws = hl.get_active_workspace()
    if not ws then return end
    local sel = selected[ws.id]
    if not sel then
        sel = { cur = "tile", prev = "float" }
        selected[ws.id] = sel
    end
    return ws, sel
end

-- setlayout(name): switch the focused workspace to name, remembering the old
-- one. setlayout() with no name swaps back to the previous layout.
function M.setlayout(name)
    return function()
        local ws, sel = active_state()
        if not ws then return end
        if not name then
            sel.cur, sel.prev = sel.prev, sel.cur
        elseif name ~= sel.cur then
            sel.cur, sel.prev = name, sel.cur
        else
            return
        end
        apply(ws, sel.cur)
    end
end

-- Keep the float layout floating: windows that open on, or move to, a float
-- workspace float; ones it floated that move away are tiled again.
hl.on("window.open", function(w)
    if w and w.workspace and floated[w.workspace.id] then
        float_window(w.workspace.id, w)
    end
end)

hl.on("window.move_to_workspace", function(w, ws)
    if not w or not ws then return end
    for id, ids in pairs(floated) do
        if id ~= ws.id and ids[w.stable_id] then
            ids[w.stable_id] = nil
            if not floated[ws.id] and w.floating then
                hl.dispatch(hl.dsp.window.float({ action = "off", window = w }))
            end
        end
    end
    if floated[ws.id] then float_window(ws.id, w) end
end)

return M
