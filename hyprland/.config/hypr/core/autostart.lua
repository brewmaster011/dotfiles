local HOME = os.getenv("HOME")

-- hl.exec_cmd spawns detached, so no trailing & is needed.
hl.on("hyprland.start", function()
    hl.exec_cmd("pipewire")
    hl.exec_cmd("dunst")
    -- waybar is started per monitor by core/bar.lua
    hl.exec_cmd("hyprpaper")
    hl.exec_cmd("hypridle")
    -- No config file on purpose: a profile would be re-applied daily at its time,
    -- resetting gamma (un-blanking an idle screen); --identity starts neutral.
    hl.exec_cmd("hyprsunset --identity") -- blue-light toggle + hypridle's screen blanking
    hl.exec_cmd("/usr/lib/hyprpolkitagent/hyprpolkitagent")

    -- SSH Agent setup
    hl.exec_cmd("runsvdir " .. HOME .. "/.config/runit/runsvdir/current")
    hl.exec_cmd(HOME .. "/.config/scripts/ssh-load-keys")
end)
