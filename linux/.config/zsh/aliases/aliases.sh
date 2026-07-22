#!/bin/sh
# Linux-specific aliases

# Laptop battery control and thermal profiles
alias performance="sudo smbios-thermal-ctl --set-thermal-mode=Performance && powerprofilesctl set performance"
alias balanced="sudo smbios-thermal-ctl --set-thermal-mode=Balanced && powerprofilesctl set balanced"
alias cool-bottom="sudo smbios-thermal-ctl --set-thermal-mode=Cool-Bottom && powerprofilesctl set power-saver"
alias quiet="sudo smbios-thermal-ctl --set-thermal-mode=Quiet && powerprofilesctl set power-saver"

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
