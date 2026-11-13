# Linux-specific zshrc settings (sourced from rc.d by common's zshrc)

# Mozilla smooth scrolling with touchpad
export MOZ_USE_XINPUT2=1

# fzf-tab: systemd service preview
zstyle ':fzf-tab:complete:systemctl-*:*' fzf-preview 'SYSTEMD_COLORS=1 systemctl status $word'
