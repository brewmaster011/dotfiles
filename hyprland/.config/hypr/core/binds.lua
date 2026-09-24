-- See https://wiki.hypr.land/Configuring/Binds/
local HOME = os.getenv("HOME")

local mainMod     = "SUPER"
local terminal    = "alacritty"
local fileManager = "nautilus"
local menu        = "wofi --show run,drun"

hl.bind(mainMod .. " + Return",           hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + SHIFT + C",        hl.dsp.window.close())
hl.bind(mainMod .. " + SHIFT + CTRL + M", hl.dsp.exit())
hl.bind(mainMod .. " + E",                hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + V",                hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + SPACE",            hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + P",                hl.dsp.window.pseudo())         -- dwindle
hl.bind(mainMod .. " + SHIFT + J",        hl.dsp.layout("togglesplit"))   -- dwindle

-- Runtime layout switching
hl.bind(mainMod .. " + CTRL + SPACE",         function() hl.config({ general = { layout = "master" } }) end)
hl.bind(mainMod .. " + CTRL + SHIFT + SPACE", function() hl.config({ general = { layout = "dwindle" } }) end)

-- Move focus with mainMod + arrow keys
hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "l" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "r" }))
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "u" }))
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "d" }))

-- Move focus with mainMod + vim keys
hl.bind(mainMod .. " + h", hl.dsp.focus({ direction = "l" }))
hl.bind(mainMod .. " + l", hl.dsp.focus({ direction = "r" }))
hl.bind(mainMod .. " + k", hl.dsp.focus({ direction = "u" }))
hl.bind(mainMod .. " + j", hl.dsp.focus({ direction = "d" }))

-- Switch to most recent workspace
hl.bind(mainMod .. " + TAB", hl.dsp.focus({ workspace = "previous" }))

-- Global workspaces with mainMod + [0-9], move window with mainMod + SHIFT + [0-9].
-- modules/split-workspaces unbinds and replaces these with per-monitor ones.
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(mainMod .. " + " .. key,         hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Cycle focus between monitors, dwm-style (comma = previous, period = next).
-- (Verified live: hyprctl dispatch takes a Lua expression under the Lua config
-- provider, not classic "dispatcher, args" syntax - hl.dsp.focus({monitor=...})
-- is the real native call, not a shell-out to `hyprctl dispatch focusmonitor`.)
hl.bind(mainMod .. " + comma",  hl.dsp.focus({ monitor = "-1" }))
hl.bind(mainMod .. " + period", hl.dsp.focus({ monitor = "+1" }))

-- Move the active window to the next/previous monitor, following it there.
-- Lands the window on whatever workspace is currently active on the target
-- monitor - the same place a mouse drag between monitors would put it.
local function move_window_to_monitor(offset)
    return function()
        local cur_mon = hl.get_active_monitor()
        if not cur_mon then return end

        local mons = hl.get_monitors()
        local idx
        for i, m in ipairs(mons) do
            if m.id == cur_mon.id then idx = i break end
        end
        if not idx then return end

        local target = mons[((idx - 1 + offset) % #mons) + 1]
        local target_ws = target.active_workspace
        if not target_ws then return end

        hl.dispatch(hl.dsp.window.move({ workspace = target_ws.name, follow = true }))
    end
end

hl.bind(mainMod .. " + SHIFT + comma",  move_window_to_monitor(-1))
hl.bind(mainMod .. " + SHIFT + period", move_window_to_monitor(1))

-- Special workspace (scratchpad)
hl.bind(mainMod .. " + S",         hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Multimedia keys (work on the lockscreen, repeat when held)
hl.bind("XF86AudioRaiseVolume",  hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume",  hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      { locked = true, repeating = true })
hl.bind("XF86AudioMute",         hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     { locked = true, repeating = true })
hl.bind("XF86AudioMicMute",      hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),   { locked = true, repeating = true })

-- Requires playerctl
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })

-- Lock and sleep
hl.bind(mainMod .. " + SHIFT + L",        hl.dsp.exec_cmd("hyprlock"))
hl.bind(mainMod .. " + SHIFT + CTRL + S", hl.dsp.exec_cmd("loginctl suspend"))
-- Toggle hypridle default/relaxed profile (screen off 20m, lock 45m, suspend 60m)
hl.bind(mainMod .. " + I", hl.dsp.exec_cmd(HOME .. "/.config/scripts/idle-toggle"))

-- Application launch
hl.bind(mainMod .. " + W", hl.dsp.exec_cmd("chromium"))

-- Screenshots
local shotDir = HOME .. "/Pictures/screenshots"
hl.bind("Print",               hl.dsp.exec_cmd([[grim -g "$(slurp)" -l 1 - | tee "]] .. shotDir .. [[/$(date +'%Y%m%d_%H%M%S').png" | wl-copy && notify-send "Success" "Screenshot saved and copied to clipboard"]]))
hl.bind("CTRL + Print",        hl.dsp.exec_cmd([[grim -g "$(slurp)" - | satty --filename - --copy-command wl-copy --output-filename "~/Pictures/screenshots/%Y%m%d_%H%M%S_edit.png" --actions-on-enter save-to-clipboard --actions-on-enter save-to-file --actions-on-enter exit]]))
hl.bind("CTRL + SHIFT + Print", hl.dsp.exec_cmd([[grim - | satty --filename - --copy-command wl-copy --output-filename "~/Pictures/screenshots/%Y%m%d_%H%M%S_edit.png" --actions-on-enter save-to-clipboard --actions-on-enter save-to-file --actions-on-enter exit]]))
hl.bind("SHIFT + Print",       hl.dsp.exec_cmd([[grim -l 1 - | tee "]] .. shotDir .. [[/$(date +'%Y%m%d_%H%M%S').png" | wl-copy && notify-send "Success" "Screenshot saved and copied to clipboard"]]))

-- MX Master 4 bindings
hl.bind("mouse:278",                       hl.dsp.focus({ workspace = "previous" }))
hl.bind(mainMod .. " + SHIFT + mouse:278", hl.dsp.window.close())

hl.bind("mouse:277", function()
    hl.dispatch(hl.dsp.window.cycle_next())
    hl.dispatch(hl.dsp.window.bring_to_top())
end)

hl.bind(mainMod .. " + mouse:277",         hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + mouse:277", hl.dsp.window.move({ workspace = "special:magic" }))

-- Show/Hide waybar
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd("killall -SIGUSR1 waybar"))
