-- dwm's bar on waybar: one waybar per monitor, shown or hidden per tag (dwm's
-- pertag showbar). Super + B toggles it for the tag being viewed; with several
-- tags in view that is the workspace holding the view, as dwm's curtag.
--
-- Each waybar runs with a generated config in $XDG_RUNTIME_DIR/waybar/ that
-- includes ~/.config/waybar/config.jsonc, pins the bar to its output and turns
-- SIGUSR1/SIGUSR2 into show/hide, so a bar is told exactly what to be rather
-- than toggled. waybar keeps a bar for an output that comes and goes, so each
-- monitor's waybar is started once and left running.
local M = {}

local HOME = os.getenv("HOME")
local DIR  = (os.getenv("XDG_RUNTIME_DIR") or "/tmp") .. "/waybar"
os.execute("mkdir -p '" .. DIR .. "'")

-- Hands off until Hyprland is up (see core/tags.lua): on a cold start the
-- config loads before the compositor exists. A reload finds monitors already.
local ready = #hl.get_monitors() > 0

-- workspace id -> true where the bar is hidden. Lost on config reload, which
-- shows every bar again.
local hidden = {}
-- monitor name -> whether its waybar was last told to show
local shown = {}

local function config_path(mon)
    return DIR .. "/" .. mon.name .. ".jsonc"
end

-- The waybar started below, not one started by hand. Signals go to it alone:
-- the sh waiting to start it would die of SIGUSR1/2.
local function waybar_pattern(mon)
    return "'^waybar -c " .. config_path(mon) .. "'"
end

-- That waybar or the sh still waiting to start it. "[w]" keeps pgrep's own
-- sh -c from matching.
local function any_pattern(mon)
    return "'[w]aybar -c " .. config_path(mon) .. "'"
end

local function wanted(mon)
    local ws = mon.active_workspace
    return not (ws and hidden[ws.id])
end

local function update(mon, force)
    local want = wanted(mon)
    if not force and shown[mon.name] == want then return end
    shown[mon.name] = want
    hl.exec_cmd("pkill -" .. (want and "USR1" or "USR2") .. " -f " .. waybar_pattern(mon))
end

-- Start mon's waybar, or bring a running one in line after a reload.
local function running(mon)
    -- Hyprland reaps its children, so os.execute can't report pgrep's exit
    -- status (it always fails with ECHILD); go by its output instead.
    local p = io.popen("pgrep -f " .. any_pattern(mon))
    if not p then return false end
    local out = p:read("a")
    p:close()
    return out ~= ""
end

-- monitor name -> true once this config instance started its waybar, which
-- covers the startup events that fire before pgrep could see it.
local started = {}

local function ensure(mon)
    if started[mon.name] then return end
    if running(mon) then
        -- left over from before a config reload: bring it in line
        started[mon.name] = true
        update(mon, true)
        return
    end

    local f = io.open(config_path(mon), "w")
    if not f then return end
    f:write(string.format(
        '{"include": ["%s/.config/waybar/config.jsonc"], "output": "%s", "start_hidden": %s,'
            .. ' "on-sigusr1": "show", "on-sigusr2": "hide"}\n',
        HOME, mon.name, tostring(not wanted(mon))))
    f:close()
    shown[mon.name] = wanted(mon)
    started[mon.name] = true

    -- waybar races pipewire-pulse at session start; gate it on the pulse socket.
    -- The signals it gets (show/hide here, redraw from core/tags.lua) kill it
    -- until it has set up its handlers, so start it with them ignored: that
    -- survives the exec, and waybar replaces it with its handlers. 42 is
    -- SIGRTMIN+8 under glibc, the tag modules' "signal".
    hl.exec_cmd(string.format(
        [[sh -c 'trap "" USR1 USR2 42; until [ -S "$XDG_RUNTIME_DIR/pulse/native" ]; do sleep 0.25; done; exec waybar -c %s -s %s/.config/waybar/style.css']],
        config_path(mon), HOME))
end

-- togglebar: hide or show the bar for the focused monitor's view.
function M.toggle()
    if not ready then return end
    local mon = hl.get_active_monitor()
    local ws = mon and mon.active_workspace
    if not ws then return end
    hidden[ws.id] = not hidden[ws.id] or nil
    update(mon)
end

local function ensure_all()
    for _, mon in ipairs(hl.get_monitors()) do ensure(mon) end
end

hl.on("hyprland.start", function()
    ready = true
    ensure_all()
end)
hl.on("monitor.added", function(mon)
    if ready and mon then ensure(mon) end
end)
hl.on("workspace.active", function(ws)
    if ready and ws and ws.monitor then update(ws.monitor) end
end)
if ready then ensure_all() end

return M
