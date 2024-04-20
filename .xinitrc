#!/bin/sh

# Check and initialize ssh-agent
[ -z "$SSH_AUTH_SOCK" ] && eval $(ssh-agent)

# Set wallpaper
/home/bshtrepi/.config/feh/wallpaper/fehbg

# Color calibration
xcalib -v /home/bshtrepi/.config/color-calibration/BOE_CQ_______NE135FBM_N41_03.icm

# Autostart at login
xss-lock -- slock &
unclutter &
dwmblocks &
picom --config /home/bshtrepi/.config/picom/picom.conf &
dunst &
nm-applet &
blueman-applet &
pipewire &
wireplumber &

# Delayed start
sleep 2 &&\
pipewire-pulse &
sleep 2 &&\
pasystray &

# Misc settings
xset r rate 450 150
xset s off

# Start dwm
while true; do
    dbus-launch --exit-with-session dwm 2> ~/.cache/$(date +%N)-dwm.error.log
done
