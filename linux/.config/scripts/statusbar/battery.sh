#!/bin/sh
# ABOUTME: dwmblocks battery indicator
# ABOUTME: Auto-detects the first battery under /sys/class/power_supply

# Framework reports BAT1, the uConsole reports axp20x-battery, so find the
# battery rather than hardcoding a device name.
for supply in /sys/class/power_supply/*/; do
    [ -r "$supply/type" ] || continue
    [ "$(cat "$supply/type")" = "Battery" ] || continue
    BATTERY="$supply"
    break
done

# No battery (desktop) - print nothing
[ -n "$BATTERY" ] || exit 0

STATUS="$(cat "$BATTERY/status")"
CHARGE="$(cat "$BATTERY/capacity")"

case "$STATUS" in
    "Charging")
        ICON="󰂄"
        ;;
    "Not charging")
        ICON="󱈑"
        ;;
    "Full")
        ICON="󰁹"
        ;;
    "Discharging")
        [ "$CHARGE" -ge 95 ] && ICON="󰁹"
        [ "$CHARGE" -lt 95 ] && [ "$CHARGE" -ge 90 ] && ICON="󰂂"
        [ "$CHARGE" -lt 90 ] && [ "$CHARGE" -ge 80 ] && ICON="󰂁"
        [ "$CHARGE" -lt 80 ] && [ "$CHARGE" -ge 70 ] && ICON="󰂀"
        [ "$CHARGE" -lt 70 ] && [ "$CHARGE" -ge 60 ] && ICON="󰁿"
        [ "$CHARGE" -lt 60 ] && [ "$CHARGE" -ge 50 ] && ICON="󰁿"
        [ "$CHARGE" -lt 50 ] && [ "$CHARGE" -ge 40 ] && ICON="󰁽"
        [ "$CHARGE" -lt 40 ] && [ "$CHARGE" -ge 30 ] && ICON="󰁼"
        [ "$CHARGE" -lt 30 ] && [ "$CHARGE" -ge 20 ] && ICON="󰁻"
        [ "$CHARGE" -lt 20 ] && [ "$CHARGE" -ge 15 ] && ICON="󰁺"
        [ "$CHARGE" -lt 15 ] && ICON="󰂃"
        ;;
    *)
        ICON="󰁽"
        ;;
esac

printf "%s %s%%" "$ICON" "$CHARGE"
