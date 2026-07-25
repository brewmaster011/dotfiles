#!/bin/sh
# Linux-specific aliases

# Wireguard shortcuts
alias connect_main="wg-quick up wg0"
alias disconnect_main="wg-quick down wg0"

# Flatpak run application
alias Spotify="flatpak run com.Spotify.Client"

# Get wifi password
alias wifipass="nmcli dev wifi show-password"

# System memory
alias free='free -h'

# File permissions (GNU stat)
alias perm='stat --printf "%a %n \n "'
