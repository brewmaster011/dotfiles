#!/bin/sh
# ABOUTME: dwmblocks brightness indicator
# ABOUTME: Uses brightnessctl so it works regardless of backlight device or scale

# brightnessctl -m prints: <device>,<class>,<current>,<percent>,<max>
BRIGHTNESS="$(brightnessctl -m i | cut -d, -f4)"

printf "󰃠  %s" "$BRIGHTNESS"

# Keyboard backlight, where the hardware has one (Framework)
KBD_DEVICE="chromeos::kbd_backlight"
if [ -d "/sys/class/leds/$KBD_DEVICE" ]; then
    KBD="$(brightnessctl -m -d "$KBD_DEVICE" i | cut -d, -f4)"
    printf "    %s" "$KBD"
fi
