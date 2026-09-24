-- NVIDIA on Wayland, per https://wiki.hypr.land/Nvidia/
local M = {}

function M.setup()
    hl.env("LIBVA_DRIVER_NAME", "nvidia")
    hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
    hl.env("NVD_BACKEND", "direct")
end

return M
