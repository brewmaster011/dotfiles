local HOME = os.getenv("HOME")

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

-- Permissions
-- hl.config({ ecosystem = { enforce_permissions = true } })
-- hl.permission({ binary = "/usr/(bin|local/bin)/grim", type = "screencopy", mode = "allow" })
-- hl.permission({ binary = "/usr/(lib|libexec|lib64)/xdg-desktop-portal-hyprland", type = "screencopy", mode = "allow" })
-- hl.permission({ binary = "/usr/(bin|local/bin)/hyprpm", type = "plugin", mode = "allow" })
