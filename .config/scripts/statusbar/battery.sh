#!/bin/sh

STATUS=$(cat /sys/class/power_supply/axp20x-battery/status)
CHARGE=$(cat /sys/class/power_supply/axp20x-battery/capacity)

case $STATUS in
    "Charging")
        ICON="󰂄"
        ;;
    "Not")
        ICON="󱈑"
        #CHARGE=$(acpi | grep "Battery 0" | awk '{print $5}' | sed 's/\%,//g;s/%//g')
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
    "Full")
	ICON="󰁹"
	;;
    *)
        ;;
esac

echo "$ICON $CHARGE%"
