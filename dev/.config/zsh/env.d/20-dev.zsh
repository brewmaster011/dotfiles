# ABOUTME: dev's variables, sourced by common's .zshenv for every zsh

# pi coding agent: keep its config, sessions and credentials in
# ~/.config/pi/agent instead of its hardcoded ~/.pi/agent. pi only honours this
# variable, so it has to be set for every way pi can be started, not just
# interactive shells (hyprland's core/env.lua sets it for GUI launches).
export PI_CODING_AGENT_DIR="$HOME/.config/pi/agent"
