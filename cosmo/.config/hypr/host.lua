-- cosmo desktop (Ryzen 9 9900X, RTX 5080 on nvidia-open): loaded by hyprland.lua via dofile.

hl.monitor({ output = "desc:Samsung Electric Company Odyssey G81SF HNBYA00203", mode = "3840x2160@240", position = "0x0", scale = 1.25, vrr = 1 })
-- Fallback for unknown monitors
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1 })

-- NVIDIA on Wayland, per https://wiki.hypr.land/Nvidia/
hl.env("LIBVA_DRIVER_NAME", "nvidia")
hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
hl.env("NVD_BACKEND", "direct")
