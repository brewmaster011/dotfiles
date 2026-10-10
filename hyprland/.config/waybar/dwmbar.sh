#!/bin/sh
# dwm's bar for waybar (hypr/core/tags.lua), per output:
#   dwmbar.sh tag N              print tag N as waybar JSON (custom/tag1..9)
#   dwmbar.sh tag N ACTION       click: view, toggleview, tag or toggletag on tag N
#   dwmbar.sh layout             print the layout symbol (custom/layout)
#   dwmbar.sh layout next|prev   click: cycle the layout
# core/tags.lua keeps "view occupied urgent layout" for each monitor in
# $XDG_RUNTIME_DIR/hypr-tags/<output> and sends waybar SIGRTMIN+8 on change.

click() {
    exec hyprctl eval "require('core.tags').click('$WAYBAR_OUTPUT_NAME', '$1', $2)" >/dev/null
}

read_state() {
    read -r view occupied urgent layout < "$XDG_RUNTIME_DIR/hypr-tags/$WAYBAR_OUTPUT_NAME" 2>/dev/null || exit 0
}

case $1 in
tag)
    n=$2
    [ -n "$3" ] && click "$3" "$n"
    read_state
    bit=$((1 << (n - 1)))

    # Like dwm, a tag that is neither viewed nor occupied isn't drawn.
    [ $(((view | occupied) & bit)) -eq 0 ] && exit 0

    class=
    [ $((view & bit)) -ne 0 ]     && class="$class\"selected\","
    [ $((occupied & bit)) -ne 0 ] && class="$class\"occupied\","
    [ $((urgent & bit)) -ne 0 ]   && class="$class\"urgent\","
    printf '{"text": "%s", "class": [%s]}\n' "$n" "${class%,}"
    ;;
layout)
    case $2 in
    next) click layout 1 ;;
    prev) click layout -1 ;;
    esac
    read_state
    [ "$layout" = - ] || printf '%s\n' "$layout"
    ;;
esac
