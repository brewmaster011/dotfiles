-- Swallow F24 emitted by kanata's home row mod workaround so it never reaches apps.
-- Home row mods are: lsft/rsft, lalt/ralt, lmet/rmet, lctl/rctl — cover all 16
-- modifier combinations (2^4) so that MOD+F24 is also consumed at the compositor.
local M = {}

function M.setup()
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

return M
