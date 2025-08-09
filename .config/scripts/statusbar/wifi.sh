#!/bin/sh

# Show wifi 📶 and percent strength or 📡 if none.
# Show 🌐 if connected to ethernet or ❎ if none.
# Show 🔒 if a vpn connection is active

# Wifi
if [ "$(cat /sys/class/net/wlan0/operstate 2>/dev/null)" = 'up' ] ; then
	wifiicon="$(awk '/^ wlan0/ { print "  ", int($3 * 100 / 70) "% " }' /proc/net/wireless)"

elif [ "$(cat /sys/class/net/w*/operstate 2>/dev/null)" = 'down' ] ; then
	[ "$(cat /sys/class/net/w*/flags 2>/dev/null)" = '0x1003' ] && wifiicon="󰖪 " || wifiicon="❌ "

fi

# Ethernet
#[ "$(cat /sys/class/net/e*/operstate 2>/dev/null)" = 'up' ] && ethericon="󰒢" || ethericon="󰞃"

# TUN
[ -d "/sys/class/net/Remote" ] && tunicon="🔒 "
[ -d "/sys/class/net/Home" ] && tunicon="🔒 "

#printf "%s%s%s" "$wifiicon" "$ethericon" "$tunicon"
printf "%s%s" "$tunicon" "$wifiicon"
