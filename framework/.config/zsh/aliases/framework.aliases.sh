#!/bin/sh
# Framework laptop aliases

# Laptop battery control and thermal profiles
alias performance="sudo smbios-thermal-ctl --set-thermal-mode=Performance && powerprofilesctl set performance"
alias balanced="sudo smbios-thermal-ctl --set-thermal-mode=Balanced && powerprofilesctl set balanced"
alias cool-bottom="sudo smbios-thermal-ctl --set-thermal-mode=Cool-Bottom && powerprofilesctl set power-saver"
alias quiet="sudo smbios-thermal-ctl --set-thermal-mode=Quiet && powerprofilesctl set power-saver"
