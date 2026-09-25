-- Ref https://wiki.hypr.land/Configuring/Workspace-Rules/ and
-- https://wiki.hypr.land/Configuring/Code-Snippets/#smart-gaps
-- "Smart gaps" / "No gaps when only" - the s[false] selector excludes special
-- workspaces (our scratchpad) so a lone scratchpad window keeps its border/gaps.
hl.workspace_rule({ workspace = "w[tv1]s[false]", gaps_out = 0, gaps_in = 0 })
hl.workspace_rule({ workspace = "f[1]s[false]",   gaps_out = 0, gaps_in = 0 })
hl.window_rule({ name = "no-gaps-wtv1", match = { float = false, workspace = "w[tv1]s[false]" }, border_size = 0, rounding = 0 })
hl.window_rule({ name = "no-gaps-f1",   match = { float = false, workspace = "f[1]s[false]" },   border_size = 0, rounding = 0 })

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
