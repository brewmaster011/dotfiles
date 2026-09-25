-- Known screens and desk layouts, shared by every host.
-- A screen's own properties (EDID description, mode, scale, VRR) live in
-- M.screens once; where it sits (position, transform) depends on the desk and
-- lives in M.layouts. Screens are matched by EDID description, not DP-N, so
-- rules survive replugging. Confirm strings with `hyprctl monitors all`.
local M = {}

M.screens = {
    samsung = {
        desc = "Samsung Electric Company Odyssey G81SF HNBYA00203",
        mode = "3840x2160@240",
        scale = 1.25,
        vrr = 1,
        bitdepth = 10
    },
    lenovo  = {
        desc = "Lenovo Group Limited LEN T24i-20 VNA5MNX8",
        mode = "preferred",
        scale = 1
    },
}

M.layouts = {
    -- Lenovo (portrait, transform 3) on the left; Samsung to its right, starting
    -- at x=1080 - the Lenovo's logical width once rotated (1920x1080 native,
    -- scale 1, transform swaps it to 1080 wide x 1920 tall in layout coordinates).
    desk = {
        { "lenovo",  position = "0x0",   transform = 3 },
        { "samsung", position = "1080x0" },
    },
}

function M.desc(name)
    return "desc:" .. M.screens[name].desc
end

local function is_layout_screen(layout, monitor)
    local d = monitor.description or ""
    for _, entry in ipairs(layout) do
        local want = M.screens[entry[1]].desc
        if d:sub(1, #want) == want then return true end
    end
    return false
end

-- opts.layout:  name from M.layouts
-- opts.builtin: optional built-in panel, e.g. { output = "eDP-1", mode = ..., scale = ... }.
--               It is disabled while any screen of the layout is connected (docked)
--               and re-enabled when the last one goes away.
function M.setup(opts)
    local layout = M.layouts[opts.layout]

    for _, entry in ipairs(layout) do
        local screen = M.screens[entry[1]]
        hl.monitor({
            output    = "desc:" .. screen.desc,
            mode      = screen.mode,
            scale     = screen.scale,
            vrr       = screen.vrr,
            position  = entry.position,
            transform = entry.transform,
            bitdepth  = screen.bitdepth,
        })
    end

    -- Fallback for unknown monitors
    hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1 })

    local builtin = opts.builtin
    if not builtin then return end

    local docked
    local function apply(now_docked)
        if now_docked == docked then return end
        docked = now_docked
        local rule = { disabled = docked }
        for k, v in pairs(builtin) do rule[k] = v end
        hl.monitor(rule)
    end

    local function any_docked(except_id)
        for _, m in ipairs(hl.get_monitors()) do
            if m.id ~= except_id and is_layout_screen(layout, m) then return true end
        end
        return false
    end

    apply(any_docked())
    hl.on("monitor.added", function(monitor)
        if is_layout_screen(layout, monitor) then apply(true) end
    end)
    hl.on("monitor.removed", function(monitor)
        if is_layout_screen(layout, monitor) then apply(any_docked(monitor.id)) end
    end)
end

return M
