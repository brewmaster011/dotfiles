-- #######################################################################################
-- HYPRLAND CONFIG (Lua, Hyprland >= 0.55)
-- Migrated from hyprland.conf; the hyprlang format is deprecated since 0.55.
-- API reference: /usr/share/hypr/stubs/hl.meta.lua and https://wiki.hypr.land/Configuring/
-- #######################################################################################

local HOME = os.getenv("HOME")

----------------
--- MONITORS ---
----------------

-- Monitor layout is per machine: see host.lua in the host stow package
-- (framework/, cosmo/). It is loaded at the end of this file.


-------------------
--- MY PROGRAMS ---
-------------------

local terminal    = "alacritty"
local fileManager = "nautilus"
local menu        = "wofi --show run,drun"


-----------------
--- AUTOSTART ---
-----------------

-- hl.exec_cmd spawns detached, so no trailing & is needed.
hl.on("hyprland.start", function()
    hl.exec_cmd("pipewire")
    hl.exec_cmd("dunst")
    -- waybar races pipewire-pulse at session start; gate it on the pulse socket.
    hl.exec_cmd([[bash -c 'until [ -S "$XDG_RUNTIME_DIR/pulse/native" ]; do sleep 0.25; done; waybar']])
    hl.exec_cmd("hyprpaper")
    hl.exec_cmd("hypridle")
    hl.exec_cmd("/usr/lib/hyprpolkitagent/hyprpolkitagent")

    -- SSH Agent setup
    hl.exec_cmd("runsvdir " .. HOME .. "/.config/runit/runsvdir/current")
    hl.exec_cmd(HOME .. "/.config/scripts/ssh-load-keys")
end)


-----------------------------
--- ENVIRONMENT VARIABLES ---
-----------------------------

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

hl.env("SSH_AUTH_SOCK", HOME .. "/.ssh/ssh_auth_sock")
hl.env("SSH_ASKPASS", HOME .. "/.config/scripts/ssh-askpass-wofi")
hl.env("SSH_ASKPASS_REQUIRE", "prefer")

hl.env("GRIM_DEFAULT_DIR", HOME .. "/Pictures/screenshots")

-- GTK Theme
hl.env("GTK_THEME", "Sweet-mars")
hl.env("ICON_THEME", "Papirus-Dark")

-- Per-monitor compositor scale is the single source of truth for scaling;
-- Wayland-native GTK/Qt follow it automatically (no GDK_SCALE/QT_SCALE_FACTOR).
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "wayland")


-------------------
--- PERMISSIONS ---
-------------------

-- hl.config({ ecosystem = { enforce_permissions = true } })
-- hl.permission({ binary = "/usr/(bin|local/bin)/grim", type = "screencopy", mode = "allow" })
-- hl.permission({ binary = "/usr/(lib|libexec|lib64)/xdg-desktop-portal-hyprland", type = "screencopy", mode = "allow" })
-- hl.permission({ binary = "/usr/(bin|local/bin)/hyprpm", type = "plugin", mode = "allow" })


---------------------
--- LOOK AND FEEL ---
---------------------

hl.config({
    general = {
        gaps_in  = 3,
        gaps_out = 5,

        border_size = 0,

        col = {
            -- active_border = { colors = { "rgba(33ccffee)", "rgba(00ff99ee)" }, angle = 45 },
            active_border   = "rgb(a89984)",
            inactive_border = "rgba(595959aa)",
        },

        resize_on_border = false,

        allow_tearing = false,

        layout = "master",
    },

    decoration = {
        rounding       = 5,
        rounding_power = 2,

        active_opacity   = 1.0,
        inactive_opacity = 0.95,

        shadow = {
            enabled      = true,
            range        = 4,
            render_power = 3,
            color        = "rgba(1a1a1aee)",
        },

        blur = {
            enabled  = true,
            size     = 3,
            passes   = 1,

            vibrancy = 0.1696,
        },
    },

    animations = {
        enabled = true,
    },
})

-- Default curves, see https://wiki.hypr.land/Configuring/Animations/#curves
hl.curve("easeOutQuint",   { type = "bezier", points = { { 0.23, 1 },    { 0.32, 1 } } })
hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.65, 0.05 }, { 0.36, 1 } } })
hl.curve("linear",         { type = "bezier", points = { { 0, 0 },       { 1, 1 } } })
hl.curve("almostLinear",   { type = "bezier", points = { { 0.5, 0.5 },   { 0.75, 1 } } })
hl.curve("quick",          { type = "bezier", points = { { 0.15, 0 },    { 0.1, 1 } } })

-- Default animations, see https://wiki.hypr.land/Configuring/Animations/
hl.animation({ leaf = "global",        enabled = true, speed = 10,   bezier = "default" })
hl.animation({ leaf = "border",        enabled = true, speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows",       enabled = true, speed = 4.79, bezier = "easeOutQuint" })
hl.animation({ leaf = "windowsIn",     enabled = true, speed = 4.1,  bezier = "easeOutQuint", style = "popin 87%" })
hl.animation({ leaf = "windowsOut",    enabled = true, speed = 1.49, bezier = "linear",       style = "popin 87%" })
hl.animation({ leaf = "fadeIn",        enabled = true, speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut",       enabled = true, speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade",          enabled = true, speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers",        enabled = true, speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn",      enabled = true, speed = 4,    bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut",     enabled = true, speed = 1.5,  bezier = "linear",       style = "fade" })
hl.animation({ leaf = "fadeLayersIn",  enabled = true, speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces",    enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesIn",  enabled = true, speed = 1.21, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "zoomFactor",    enabled = true, speed = 7,    bezier = "quick" })

-- Ref https://wiki.hypr.land/Configuring/Workspace-Rules/ and
-- https://wiki.hypr.land/Configuring/Code-Snippets/#smart-gaps
-- "Smart gaps" / "No gaps when only" - the s[false] selector excludes special
-- workspaces (our scratchpad) so a lone scratchpad window keeps its border/gaps.
hl.workspace_rule({ workspace = "w[tv1]s[false]", gaps_out = 0, gaps_in = 0 })
hl.workspace_rule({ workspace = "f[1]s[false]",   gaps_out = 0, gaps_in = 0 })
hl.window_rule({ name = "no-gaps-wtv1", match = { float = false, workspace = "w[tv1]s[false]" }, border_size = 0, rounding = 0 })
hl.window_rule({ name = "no-gaps-f1",   match = { float = false, workspace = "f[1]s[false]" },   border_size = 0, rounding = 0 })

-- Applies when switching to dwindle via mainMod+CTRL+SHIFT+SPACE
-- (pseudotile option was removed in Hyprland 0.55; the pseudo dispatcher remains)
hl.config({
    dwindle = {
        preserve_split = true,
    },

    master = {
        new_status = "master",
    },

    misc = {
        font_family             = "Inconsolata Nerd Font",
        force_default_wallpaper = 0,    -- Set to 0 or 1 to disable the anime mascot wallpapers
        disable_hyprland_logo   = true, -- If true disables the random hyprland logo / anime girl background. :(
    },
})


-------------
--- INPUT ---
-------------

hl.config({
    input = {
        kb_layout  = "us",
        kb_variant = "",
        kb_model   = "",
        kb_options = "",
        kb_rules   = "",

        follow_mouse = 1,

        sensitivity = 0, -- -1.0 - 1.0, 0 means no modification.
    },
})

-- Example per-device config
-- See https://wiki.hypr.land/Configuring/Keywords/#per-device-input-configs for more
hl.device({ name = "epic-mouse-v1", sensitivity = -0.5 })


-------------------
--- KEYBINDINGS ---
-------------------

local mainMod = "SUPER" -- Sets "Windows" key as main modifier

-- split-monitor-workspaces gives each monitor its own independent set of
-- numbered workspaces (dwm-tags-style) instead of Hyprland's global numbering.
-- Git submodule at hyprland/.config/hypr/plugins/split-monitor-workspaces.
package.path = package.path .. ";" .. HOME .. "/.config/hypr/plugins/split-monitor-workspaces/lua/?.lua"
local smw_ok, smw = pcall(require, "split-monitor-workspaces")
if smw_ok then
    smw.setup({
        workspace_count = 9,
        -- Matched by EDID description prefix, so workspace ranges (and the
        -- waybar 10-18 map) survive port renumbering. First = ids 1-9, second = 10-18.
        -- Monitors not listed get the next free range in the order Hyprland reports them.
        monitor_priority = {
            "desc:Samsung Electric Company Odyssey G81SF",
            "desc:Lenovo Group Limited LEN T24i-20",
        },
        -- The library's own default is true (all 9 tags always shown per monitor,
        -- dwm-tag-bar style). We want the old Hyprland behavior back instead:
        -- only show workspaces that actually exist/have windows.
        enable_persistent_workspaces = false,
    })
else
    -- Submodule not checked out: fall back to plain global workspaces so the
    -- rest of the config (and every bind below) still loads.
    hl.notification.create({ text = "split-monitor-workspaces missing: git submodule update --init", duration = 10000, icon = "warning" })
end

-- Swallow F24 emitted by kanata's home row mod workaround so it never reaches apps.
-- Home row mods are: lsft/rsft, lalt/ralt, lmet/rmet, lctl/rctl — cover all 16
-- modifier combinations (2^4) so that MOD+F24 is also consumed at the compositor.
do
    local mods = { "SHIFT", "ALT", "SUPER", "CTRL" }
    for mask = 0, 15 do
        local parts = {}
        for i, mod in ipairs(mods) do
            if mask & (1 << (i - 1)) ~= 0 then
                parts[#parts + 1] = mod
            end
        end
        parts[#parts + 1] = "F24"
        hl.bind(table.concat(parts, " + "), hl.dsp.no_op())
    end
end

-- See https://wiki.hypr.land/Configuring/Binds/ for more
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

-- Switch to the Nth workspace ON THE CURRENTLY FOCUSED MONITOR (dwm-tags-style,
-- via split-monitor-workspaces) with mainMod + [0-9].
-- Move active window to the Nth workspace on its monitor with mainMod + SHIFT + [0-9].
if smw_ok then
    for i = 1, smw.get_amount_of_workspaces() do
        local key = tostring(i % 10) -- 10 maps to key 0
        hl.bind(mainMod .. " + " .. key,         smw.workspace(key))
        hl.bind(mainMod .. " + SHIFT + " .. key, smw.move_to_workspace_silent(key))
    end
else
    for i = 1, 10 do
        local key = i % 10
        hl.bind(mainMod .. " + " .. key,         hl.dsp.focus({ workspace = i }))
        hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
    end
end

-- Cycle focus between monitors, dwm-style (comma = previous, period = next).
-- (Verified live: hyprctl dispatch takes a Lua expression under the Lua config
-- provider, not classic "dispatcher, args" syntax - hl.dsp.focus({monitor=...})
-- is the real native call, not a shell-out to `hyprctl dispatch focusmonitor`.)
hl.bind(mainMod .. " + comma",  hl.dsp.focus({ monitor = "-1" }))
hl.bind(mainMod .. " + period", hl.dsp.focus({ monitor = "+1" }))

-- Move the active window to the next/previous monitor, following it there.
-- The plugin has no monitor-move call (it's workspace-based, not monitor-based),
-- so this lands the window on whatever workspace is currently active on the
-- target monitor - the same place a mouse drag between monitors would put it.
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


------------------------------
--- WINDOWS AND WORKSPACES ---
------------------------------

-- Ignore maximize requests from apps. You'll probably like this.
hl.window_rule({ name = "suppress-maximize", match = { class = ".*" }, suppress_event = "maximize" })

-- Ueberzugpp image preview overlay
hl.window_rule({
    name  = "ueberzugpp-overlay",
    match = { class = "ueberzugpp.*" },

    float       = true,
    no_focus    = true,
    border_size = 0,
    rounding    = 0,
    no_anim     = true,
})

-- Fix some dragging issues with XWayland
-- hl.window_rule({
--     name  = "fix-xwayland-drags",
--     match = { class = "^$", title = "^$", xwayland = true, float = true, fullscreen = false, pin = false },
--     no_focus = true,
-- })

-- Steam: keep the main client window tiled, but float all secondary popups
-- (Friends List, chat windows, Settings, etc). Steam's chat windows just use
-- the friend's name as the title, so there's no title pattern that reliably
-- catches "any popup" - instead float the whole class, then re-tile only the
-- exact main-window title. (Verified live via hyprctl: rule ordering lets a
-- later, more specific match override an earlier broader one.)
hl.window_rule({ name = "steam-float-popups", match = { class = "^(steam)$" }, float = true })
hl.window_rule({ name = "steam-tile-main",    match = { class = "^(steam)$", title = "^(Steam)$" }, float = false })

-- pavucontrol wasn't built with tiling in mind - way too much dead space.
-- persistent_size remembers whatever size you last resized it to (per
-- Hyprland session) and reopens it at that size instead of its small default.
hl.window_rule({ name = "pavucontrol-float", match = { class = "^(org\\.pulseaudio\\.pavucontrol)$" }, float = true })
hl.window_rule({ name = "pavucontrol-persist-size", match = { class = "^(org\\.pulseaudio\\.pavucontrol)$" }, persistent_size = true })

-- Chromium notification/utility popups (e.g. web push notifications rendered
-- as their own toplevel) ship with no app_id/title set at all - class and
-- title both come through blank. That's the only signal Hyprland gets for
-- them, so match on blank class + blank title.
hl.window_rule({ name = "blank-popup-float", match = { class = "^$", title = "^$" }, float = true })


------------------------
--- PER-HOST OVERRIDES ---
------------------------

-- Machine-specific config (monitors, laptop keys, GPU env) lives in the host
-- stow package and is linked to ~/.config/hypr/host.lua. Missing file is fine.
do
    local hostConf = HOME .. "/.config/hypr/host.lua"
    local f = io.open(hostConf, "r")
    if f then
        f:close()
        dofile(hostConf)
    end
end
