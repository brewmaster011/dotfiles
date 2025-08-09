#!/bin/sh

MUTE="$(pamixer --get-mute)"
[ $MUTE = "true" ] && printf " " && exit

VOLUME="$(pamixer --get-volume)"
printf "   %s" "$VOLUME%"


