# ABOUTME: dwm's zsh settings, sourced from rc.d by common's zshrc

# Start X (.xinitrc runs dwm) when logging in on TTY1
if [[ -z $DISPLAY && $XDG_VTNR == 1 ]]; then
    exec startx
fi
