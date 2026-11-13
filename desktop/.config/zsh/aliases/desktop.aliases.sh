#!/bin/sh
# Linux desktop aliases (both desktops; laptop-only ones are in framework)

# Wireguard shortcuts
alias connect_main="wg-quick up wg0"
alias disconnect_main="wg-quick down wg0"

# Flatpak run application
alias Spotify="flatpak run com.Spotify.Client"

# Get wifi password
alias wifipass="nmcli dev wifi show-password"

alias urxvt='alacritty'
