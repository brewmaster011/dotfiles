#!/bin/sh
# ABOUTME: dwmblocks volume indicator
# ABOUTME: Reads mute state and volume level from pamixer

[ "$(pamixer --get-mute)" = "true" ] && printf " " && exit 0

printf "   %s%%" "$(pamixer --get-volume)"
