-- dwm tags on top of Hyprland workspaces.
--
-- In dwm a window has a set of tags and each monitor views a set of tags; a
-- window shows wherever the two meet. Hyprland puts a window on exactly one
-- workspace, so each of a monitor's 9 workspaces stands for one tag and:
--   - the monitor's active workspace holds its whole view: every window of that
--     monitor with a viewed tag is moved onto it as the view changes,
--   - every other window waits on the workspace of its lowest tag.
-- So a window tagged 1 and 3 shows on both, and one on every tag (Super +
-- Shift + 0, dwm's tag ~0) comes along to whichever tag you view.
--
-- A window's tags are kept on the window as Hyprland tags tag1..tag9, so they
-- survive config reloads (`hyprctl clients` lists them). A window without any
-- is tagged with its workspace alone, which is the plain Hyprland case.
--
-- Tags are per monitor: workspace ids go in ranges of 9 (split-workspaces gives
-- the second monitor 10-18, its tags 1-9). Without split-workspaces 1-9 are
-- tags 1-9 wherever those workspaces are.
--
-- The active workspace is dwm's pertag curtag: it carries the view's layout,
-- nmaster and mfact (core/layouts.lua, core/tile.lua). Viewing several tags
-- uses the workspace of the lowest one, or keeps the current one when it is
-- still in the view.
local M = {}

local TAGS = 9 -- split-workspaces' workspace_count must match
local ALL  = (1 << TAGS) - 1

local function bit(tag) return 1 << (tag - 1) end

local function lowest(mask)
    for t = 1, TAGS do
        if mask & bit(t) ~= 0 then return t end
    end
end

local function popcount(mask)
    local n = 0
    for t = 1, TAGS do
        if mask & bit(t) ~= 0 then n = n + 1 end
    end
    return n
end

-- Named and special workspaces have ids below 1 and take no part in tagging.
local function tagged(ws)
    return ws ~= nil and not ws.special and ws.id >= 1
end

-- workspace id -> first id of its range, tag
local function split(id)
    local base = (id - 1) // TAGS * TAGS
    return base, id - base
end

-- ---------------------------------------------------------------------------
-- A window's tags
-- ---------------------------------------------------------------------------

local function stored_mask(w)
    local mask = 0
    for _, name in ipairs(w.tags or {}) do
        local t = name:match("^tag(%d)$")
        if t and t ~= "0" then mask = mask | bit(tonumber(t)) end
    end
    return mask
end

local function window_mask(w)
    local mask = stored_mask(w)
    if mask ~= 0 or not tagged(w.workspace) then return mask end
    local _, t = split(w.workspace.id)
    return bit(t)
end

local function store(w, mask)
    local old = stored_mask(w)
    for t = 1, TAGS do
        local want = mask & bit(t) ~= 0
        if (old & bit(t) ~= 0) ~= want then
            hl.dispatch(hl.dsp.window.tag({ tag = (want and "+" or "-") .. "tag" .. t, window = w }))
        end
    end
end

-- ---------------------------------------------------------------------------
-- Each monitor's view: dwm's tagset[2] + seltags, with the anchor (curtag)
-- ---------------------------------------------------------------------------

-- monitor id -> { { mask, anchor }, { mask, anchor }, sel = 1|2 }
local views = {}

-- The monitor's view and active workspace. Switching workspaces some other way
-- (waybar, scrolling, gestures, a reload) views that one tag, as dwm's view.
local function state(mon)
    local ws = mon and mon.active_workspace
    if not tagged(ws) then return end
    local _, t = split(ws.id)

    local v = views[mon.id]
    if not v then
        v = { { mask = bit(t), anchor = t }, { mask = bit(t), anchor = t }, sel = 1 }
        views[mon.id] = v
    elseif v[v.sel].anchor ~= t then
        v.sel = 3 - v.sel
        v[v.sel] = { mask = bit(t), anchor = t }
    end
    return v, ws
end

-- Put w where mask says it belongs on its monitor: on the active workspace if
-- it shares a tag with the view, else on its lowest tag's workspace.
local function place(w, mask, view, base)
    local t = mask & view.mask ~= 0 and view.anchor or lowest(mask)
    -- A lone tag that matches the workspace needs no stored tags.
    store(w, mask == bit(t) and 0 or mask)
    if w.workspace.id ~= base + t then
        hl.dispatch(hl.dsp.window.move({ workspace = base + t, window = w, follow = false }))
    end
end

-- dwm's arrange(): bring every window of mon's range to where its tags say.
local function sync(mon)
    local v, ws = state(mon)
    if not v then return end
    local base = split(ws.id)

    for _, w in ipairs(hl.get_windows()) do
        local wws = w.workspace
        -- Swallowed windows and group members are hidden and move with the
        -- window in front of them; pinned ones follow the monitor by themselves.
        if w.mapped and not w.hidden and not w.pinned and tagged(wws)
            and wws.monitor and wws.monitor.id == mon.id and split(wws.id) == base then
            place(w, window_mask(w), v[v.sel], base)
        end
    end
end

-- Set while these binds switch workspaces themselves, so the workspace.active
-- handler leaves the view alone.
local switching = false

-- Show the monitor's selected view: switch to its anchor, gather the windows,
-- and give focus back to the window that had it if it is still in sight
-- (dwm's focus(NULL) picks the most recently focused visible window).
local function apply(mon, v)
    local focused = hl.get_active_window()
    local ws = mon.active_workspace
    local target = split(ws.id) + v[v.sel].anchor

    if ws.id ~= target then
        switching = true
        local ok, err = pcall(hl.dispatch, hl.dsp.focus({ workspace = target }))
        switching = false
        if not ok then error(err) end
    end
    sync(mon)

    if focused and focused.workspace and focused.workspace.id == target and not focused.active then
        hl.dispatch(hl.dsp.focus({ window = focused }))
    end
end

local function focused_state()
    local mon = hl.get_active_monitor()
    local v, ws = state(mon)
    if v then return mon, v, ws end
end

-- ---------------------------------------------------------------------------
-- dwm's tag functions, as bind functions
-- ---------------------------------------------------------------------------

-- view(mask): show exactly these tags; view(0) swaps back to the previous view
-- (Super + Tab). view(M.ALL) shows every window of the monitor.
function M.view(mask)
    return function()
        local mon, v = focused_state()
        if not mon or mask & ALL == v[v.sel].mask then return end
        local anchor = v[v.sel].anchor
        v.sel = 3 - v.sel
        if mask & ALL ~= 0 then
            -- dwm's pertag sets curtag 0 for ~0; keep the workspace we are on
            v[v.sel] = { mask = mask & ALL, anchor = mask & ALL == ALL and anchor or lowest(mask) }
        end
        apply(mon, v)
    end
end

-- toggleview(mask): add or remove tags from the view, never emptying it.
function M.toggleview(mask)
    return function()
        local mon, v = focused_state()
        if not mon then return end
        local cur = v[v.sel]
        local new = cur.mask ~ (mask & ALL)
        if new == 0 then return end
        cur.mask = new
        if new & bit(cur.anchor) == 0 then cur.anchor = lowest(new) end
        apply(mon, v)
    end
end

-- The focused window, if it is in the view (or the scratchpad, which these
-- binds then move it out of).
local function focused_window()
    local mon, v, ws = focused_state()
    local w = hl.get_active_window()
    if not mon or not w or not w.workspace then return end
    if w.workspace.id ~= ws.id and not w.workspace.special then return end
    return w, v, split(ws.id)
end

-- tag(mask): give the focused window exactly these tags, without following it.
-- tag(M.ALL) puts it on every tag: dwm's sticky "tag 0".
function M.tag(mask)
    return function()
        local w, v, base = focused_window()
        if w and mask & ALL ~= 0 then place(w, mask & ALL, v[v.sel], base) end
    end
end

-- toggletag(mask): add or remove tags from the focused window, never all of them.
function M.toggletag(mask)
    return function()
        local w, v, base = focused_window()
        if not w then return end
        local new = window_mask(w) ~ (mask & ALL)
        if new ~= 0 then place(w, new, v[v.sel], base) end
    end
end

-- dwm's focusadjacenttag: view (viewtoleft/right) or move the focused window's
-- tags (tagtoleft/right) one tag over. Only while viewing a single tag, and
-- without wrapping.
function M.viewadjacent(dir)
    return function()
        local mon, v = focused_state()
        if not mon or popcount(v[v.sel].mask) ~= 1 then return end
        local t = v[v.sel].anchor + dir
        if t >= 1 and t <= TAGS then M.view(bit(t))() end
    end
end

function M.tagadjacent(dir)
    return function()
        local w, v, base = focused_window()
        if not w or popcount(v[v.sel].mask) ~= 1 then return end
        local t = v[v.sel].anchor + dir
        if t < 1 or t > TAGS then return end
        local mask = window_mask(w)
        mask = (dir < 0 and mask >> 1 or mask << 1) & ALL
        if mask ~= 0 then place(w, mask, v[v.sel], base) end
    end
end

-- tagmon(offset): send the focused window to the next/previous monitor, onto
-- that monitor's view (dwm's sendmon). Focus follows it there.
function M.tagmon(offset)
    return function()
        local w = hl.get_active_window()
        local cur = hl.get_active_monitor()
        if not w or not cur then return end

        local mons = hl.get_monitors()
        if #mons < 2 then return end
        local idx
        for i, m in ipairs(mons) do
            if m.id == cur.id then idx = i break end
        end
        if not idx then return end

        local target = mons[((idx - 1 + offset) % #mons) + 1]
        local v, ws = state(target)
        if not v then return end
        if tagged(w.workspace) then
            local _, anchor = split(ws.id)
            store(w, v[v.sel].mask == bit(anchor) and 0 or v[v.sel].mask)
        end
        hl.dispatch(hl.dsp.window.move({ workspace = ws.id, follow = true }))
    end
end

M.ALL = ALL
M.bit = bit

-- ---------------------------------------------------------------------------
-- Keeping Hyprland's own moves in line
-- ---------------------------------------------------------------------------

hl.on("workspace.active", function(ws)
    if switching or not tagged(ws) then return end
    sync(ws.monitor)
end)

-- New windows get the tags being viewed (dwm's applyrules without a rule).
-- Ones a window rule sends elsewhere keep that workspace's tag.
hl.on("window.open", function(w)
    local ws = w and w.workspace
    if not tagged(ws) or not ws.monitor then return end
    local v, active = state(ws.monitor)
    if not v or active.id ~= ws.id or v[v.sel].mask == bit(v[v.sel].anchor) then return end
    store(w, v[v.sel].mask)
end)

-- A window moved some other way (another bind, a mouse drag, a window rule)
-- to a workspace its tags don't cover loses them: it is tagged with just that
-- workspace, like dwm's tag(). Moves made above always land somewhere the
-- window's tags cover.
hl.on("window.move_to_workspace", function(w, ws)
    if not w or w.pinned or not tagged(ws) then return end
    local mask = stored_mask(w)
    if mask == 0 then return end

    local _, t = split(ws.id)
    if mask & bit(t) ~= 0 then return end

    local v = ws.monitor and views[ws.monitor.id]
    local active = ws.monitor and ws.monitor.active_workspace
    if v and active and active.id == ws.id and mask & v[v.sel].mask ~= 0 then return end

    store(w, 0)
end)

return M
