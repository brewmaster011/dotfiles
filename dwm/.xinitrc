#!/bin/sh

# Check and initialize ssh-agent
[ -z "$SSH_AUTH_SOCK" ] && eval $(ssh-agent)

# Set wallpaper
$HOME/.config/feh/wallpaper/fehbg

# Color calibration for framework laptop 14
xcalib -v $HOME/.config/color-calibration/BOE_CQ_______NE135FBM_N41_03.icm

# Autostart at login
xss-lock -- slock &
unclutter &
dwmblocks &
picom --config $HOME/.config/picom/picom.conf &
dunst &
nm-applet &
blueman-applet &
#
# To start pipewire-pulse and wireplumber add the following lines to:
# '/usr/share/pipewire/pipewire.conf'
#
# context.exec = [
#     { path = "/usr/bin/wireplumber" args = "" }
#     { path = "/usr/bin/pipewire" args = "-c pipewire-pulse.conf" }
# ]
#
pipewire &
pasystray &

# Misc settings
xset r rate 450 150
xset s off

# Keyboard Map
# xmodmap ~/.config/xmodmap/xmodmap

# Start dwm
while true; do
    dbus-launch --exit-with-session dwm 2> ~/.cache/$(date).dwm.error.log
done
