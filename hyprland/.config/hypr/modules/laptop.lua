-- Built-in touchpad, gestures and backlight keys.
local M = {}

function M.setup()
    hl.config({
        input = {
            touchpad = {
                natural_scroll = false,
            },
        },
    })

    -- See https://wiki.hypr.land/Configuring/Gestures
    hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })

    -- LCD brightness keys (work on the lockscreen, repeat when held)
    hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
    hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })
end

return M
