#!/bin/sh
# ABOUTME: dwmblocks network indicator
# ABOUTME: Shows wifi signal strength, plus a lock icon when a VPN tunnel is up

# Wifi signal strength, or a "disconnected"/"disabled" icon
if [ "$(cat /sys/class/net/wlan0/operstate 2>/dev/null)" = 'up' ]; then
    wifiicon="$(awk '/^ wlan0/ { print "  ", int($3 * 100 / 70) "% " }' /proc/net/wireless)"
elif [ "$(cat /sys/class/net/w*/operstate 2>/dev/null)" = 'down' ]; then
    [ "$(cat /sys/class/net/w*/flags 2>/dev/null)" = '0x1003' ] && wifiicon="󰖪 " || wifiicon="❌ "
fi

# VPN tunnels
[ -d "/sys/class/net/Remote" ] && tunicon="🔒 "
[ -d "/sys/class/net/Home" ] && tunicon="🔒 "

printf "%s%s" "$tunicon" "$wifiicon"
