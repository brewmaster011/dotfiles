-- See https://wiki.hypr.land/Configuring/Binds/
local HOME = os.getenv("HOME")
local tile    = require("core.tile")
local layouts = require("core.layouts")
local tags    = require("core.tags")

local mainMod     = "SUPER"
local terminal    = "alacritty"
local fileManager = "nautilus"
local menu        = "wofi --show run,drun"

hl.bind(mainMod .. " + Return",           hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + SHIFT + C",        hl.dsp.window.close())
hl.bind(mainMod .. " + SHIFT + CTRL + M", hl.dsp.exit())
hl.bind(mainMod .. " + E",                hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + V",                hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + SHIFT + SPACE",    hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + P",                hl.dsp.exec_cmd(menu))

-- Per-workspace layouts, dwm-style (core/layouts.lua): Space swaps back to the
-- previous one.
hl.bind(mainMod .. " + T",     layouts.setlayout("tile"))
hl.bind(mainMod .. " + F",     layouts.setlayout("float"))
hl.bind(mainMod .. " + M",     layouts.setlayout("monocle"))
hl.bind(mainMod .. " + SPACE", layouts.setlayout())

-- View / send the window's tags one tag over, no wrapping (dwm
-- focusadjacenttag; only while viewing a single tag).
hl.bind(mainMod .. " + left",          tags.viewadjacent(-1))
hl.bind(mainMod .. " + right",         tags.viewadjacent(1))
hl.bind(mainMod .. " + SHIFT + left",  tags.tagadjacent(-1))
hl.bind(mainMod .. " + SHIFT + right", tags.tagadjacent(1))

-- dwm tile layout (core/tile.lua): J/K walk the stack, H/L size the master
-- area, I/D add/remove masters, Shift + Return zooms to master.
hl.bind(mainMod .. " + j",              tile.focusstack(1))
hl.bind(mainMod .. " + k",              tile.focusstack(-1))
hl.bind(mainMod .. " + SHIFT + j",      hl.dsp.layout("movestack +1"))
hl.bind(mainMod .. " + SHIFT + k",      hl.dsp.layout("movestack -1"))
hl.bind(mainMod .. " + h",              hl.dsp.layout("mfact -0.05"), { repeating = true })
hl.bind(mainMod .. " + l",              hl.dsp.layout("mfact +0.05"), { repeating = true })
hl.bind(mainMod .. " + i",              hl.dsp.layout("incnmaster +1"))
hl.bind(mainMod .. " + d",              hl.dsp.layout("incnmaster -1"))
hl.bind(mainMod .. " + SHIFT + Return", hl.dsp.layout("zoom"))

-- dwm tags (core/tags.lua), per monitor: each of workspaces 1-9 is a tag.
--   Super + 1-9                 view that tag
--   Super + Ctrl + 1-9          add/remove the tag from the view
--   Super + Shift + 1-9         put the window on that tag only
--   Super + Ctrl + Shift + 1-9  add/remove the tag from the window
--   Super + 0                   view every tag
--   Super + Shift + 0           put the window on every tag (it follows you)
--   Super + Tab                 back to the previous view
for i = 1, 9 do
    local mask = tags.bit(i)
    hl.bind(mainMod .. " + " .. i,                tags.view(mask))
    hl.bind(mainMod .. " + CTRL + " .. i,         tags.toggleview(mask))
    hl.bind(mainMod .. " + SHIFT + " .. i,        tags.tag(mask))
    hl.bind(mainMod .. " + CTRL + SHIFT + " .. i, tags.toggletag(mask))
end
hl.bind(mainMod .. " + 0",         tags.view(tags.ALL))
hl.bind(mainMod .. " + SHIFT + 0", tags.tag(tags.ALL))
hl.bind(mainMod .. " + TAB",       tags.view(0))

-- Cycle focus between monitors, dwm-style (comma = previous, period = next).
-- (Verified live: hyprctl dispatch takes a Lua expression under the Lua config
-- provider, not classic "dispatcher, args" syntax - hl.dsp.focus({monitor=...})
-- is the real native call, not a shell-out to `hyprctl dispatch focusmonitor`.)
hl.bind(mainMod .. " + comma",  hl.dsp.focus({ monitor = "-1" }))
hl.bind(mainMod .. " + period", hl.dsp.focus({ monitor = "+1" }))

-- Send the active window to the next/previous monitor, onto the tags it is
-- viewing (dwm tagmon), following it there.
hl.bind(mainMod .. " + SHIFT + comma",  tags.tagmon(-1))
hl.bind(mainMod .. " + SHIFT + period", tags.tagmon(1))

-- Special workspace (scratchpad)
hl.bind(mainMod .. " + S",         hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })
hl.bind(mainMod .. " + mouse:274", hl.dsp.window.float({ action = "toggle" }))

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
-- Toggle hypridle between its default and relaxed profile (timeouts in hypridle*.conf)
hl.bind(mainMod .. " + SHIFT + I", hl.dsp.exec_cmd(HOME .. "/.config/scripts/idle-toggle"))
-- Toggle the blue-light filter (hyprsunset); also un-sticks a blanked screen
hl.bind(mainMod .. " + N",         hl.dsp.exec_cmd(HOME .. "/.config/scripts/sunset-toggle"))

-- Application launch
hl.bind(mainMod .. " + W", hl.dsp.exec_cmd("chromium"))

-- Screenshots
local shotDir = HOME .. "/Pictures/screenshots"
hl.bind("Print",               hl.dsp.exec_cmd([[grim -g "$(slurp)" -l 1 - | tee "]] .. shotDir .. [[/$(date +'%Y%m%d_%H%M%S').png" | wl-copy && notify-send "Success" "Screenshot saved and copied to clipboard"]]))
hl.bind("CTRL + Print",        hl.dsp.exec_cmd([[grim -g "$(slurp)" - | satty --filename - --copy-command wl-copy --output-filename "~/Pictures/screenshots/%Y%m%d_%H%M%S_edit.png" --actions-on-enter save-to-clipboard --actions-on-enter save-to-file --actions-on-enter exit]]))
hl.bind("CTRL + SHIFT + Print", hl.dsp.exec_cmd([[grim - | satty --filename - --copy-command wl-copy --output-filename "~/Pictures/screenshots/%Y%m%d_%H%M%S_edit.png" --actions-on-enter save-to-clipboard --actions-on-enter save-to-file --actions-on-enter exit]]))
hl.bind("SHIFT + Print",       hl.dsp.exec_cmd([[grim -l 1 - | tee "]] .. shotDir .. [[/$(date +'%Y%m%d_%H%M%S').png" | wl-copy && notify-send "Success" "Screenshot saved and copied to clipboard"]]))

-- MX Master 4 bindings
hl.bind("mouse:278",                       tags.view(0))
hl.bind(mainMod .. " + SHIFT + mouse:278", hl.dsp.window.close())

hl.bind("mouse:277", function()
    hl.dispatch(hl.dsp.window.cycle_next())
    hl.dispatch(hl.dsp.window.bring_to_top())
end)

hl.bind(mainMod .. " + mouse:277",         hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + mouse:277", hl.dsp.window.move({ workspace = "special:magic" }))

-- Show/Hide waybar
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd("killall -SIGUSR1 waybar"))
