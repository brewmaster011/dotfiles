#!/usr/bin/env bash
#  ---------------------------------------------------------------------------
#
#  Description:  This file holds all general BASH aliases
#
#  For your own benefit, we won't load all aliases in the general, we will
#  keep the very generic command here and enough for daily basis tasks.
#
#  If you are looking for the more sexier aliases, we suggest you take a look
#  into other core alias files which installed by default.
#
#  ---------------------------------------------------------------------------

#   -----------------------------
#   1.  MAKE TERMINAL BETTER
#   -----------------------------

alias cp='cp -iv'                           # Preferred 'cp' implementation
alias mv='mv -iv'                           # Preferred 'mv' implementation
alias mkdir='mkdir -pv'                     # Preferred 'mkdir' implementation
alias ll='ls -lAFh'                         # Preferred 'ls' implementation
alias less='less -FSRXc'                    # Preferred 'less' implementation
alias wget='wget -c'                        # Preferred 'wget' implementation (resume download)
alias c='clear'                             # c:            Clear terminal display
alias path='echo -e ${PATH//:/\\n}'         # path:         Echo all executable Paths
alias show_options='shopt'                  # Show_options: display bash options settings
alias fix_stty='stty sane'                  # fix_stty:     Restore terminal settings when screwed up
alias fix_term='echo -e "\033c"'            # fix_term:     Reset the conosle.  Similar to the reset command
alias cic='set completion-ignore-case On'   # cic:          Make tab-completion case-insensitive
alias src='source ~/.zshrc'                # src:          Reload .bashrc file
alias vim='nvim'
alias grep='grep --color=auto'
alias diff='diff --color=auto'
alias df='df -h'
alias du='du -h'
alias free='free -h'
alias urxvt='alacritty'
alias pretty=$'jq -R \'. as $line | try (fromjson) catch $line\''   # ZSH SPECIFIC!! Pretty print JSON logs

# Laptop battery control and thermal profiles
# alias cctk="cd /opt/dell/dcc && sudo ./cctk"
alias performance="sudo smbios-thermal-ctl --set-thermal-mode=Performance && powerprofilesctl set performance"
alias balanced="sudo smbios-thermal-ctl --set-thermal-mode=Balanced && powerprofilesctl set balanced"
alias cool-bottom="sudo smbios-thermal-ctl --set-thermal-mode=Cool-Bottom && powerprofilesctl set power-saver"
alias quiet="sudo smbios-thermal-ctl --set-thermal-mode=Quiet && powerprofilesctl set power-saver"

# Wireguard shortcuts
alias connect_main="wg-quick up wg0"
alias disconnect_main="wg-quick down wg0"

# Flatpak run application
alias Spotify="flatpak run com.Spotify.Client"

# Kubernetes aliases
alias k="kubectl"
alias ke="kubens"
alias kc="kubectx"

# Get wifi password
alias wifipass="nmcli dev wifi show-password"
