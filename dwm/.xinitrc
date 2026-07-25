#!/bin/sh
# ABOUTME: X session startup for dwm
# ABOUTME: Starts the SSH agent, autostart services, then dwm in a restart loop

# SSH agent socket (matches the path exported by common/.config/zsh/zshrc).
# Prefer the runit-managed service; fall back to a plain agent on the same socket.
export SSH_AUTH_SOCK="$HOME/.ssh/ssh_auth_sock"
if command -v runsvdir >/dev/null 2>&1; then
    runsvdir "$HOME/.config/runit/runsvdir/current" &
elif [ ! -S "$SSH_AUTH_SOCK" ]; then
    rm -f "$SSH_AUTH_SOCK"
    ssh-agent -a "$SSH_AUTH_SOCK" >/dev/null
fi

# Device-specific X setup (display rotation, colour calibration, ...).
# Provided by the framework/ and uconsole/ stow packages.
[ -f "$HOME/.config/x11/xinitrc.local" ] && . "$HOME/.config/x11/xinitrc.local"

# Set wallpaper
"$HOME/.config/feh/wallpaper/fehbg"

# Autostart at login
xss-lock -- slock &
unclutter &
dwmblocks &
picom --config "$HOME/.config/picom/picom.conf" &
dunst &

# To start pipewire-pulse and wireplumber add the following lines to
# '/usr/share/pipewire/pipewire.conf':
#
# context.exec = [
#     { path = "/usr/bin/wireplumber" args = "" }
#     { path = "/usr/bin/pipewire" args = "-c pipewire-pulse.conf" }
# ]
#
pipewire &

# Misc settings
xset r rate 450 150
xset s off

# Start dwm
while true; do
    dbus-launch --exit-with-session dwm 2> "$HOME/.cache/dwm-$(date +%F).error.log"
done
