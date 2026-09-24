local HOME = os.getenv("HOME")

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
