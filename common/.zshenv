#!/bin/zsh
# ABOUTME: Read by every zsh (login, interactive, scripts), before zshrc.
# ABOUTME: Only for variables that must reach processes no zshrc runs for.

# Variables from the other stow packages (dev, desktop, ...): each one drops a
# file in env.d, named NN-<package>.zsh so they load in layer order.
for f in ~/.config/zsh/env.d/*.zsh(N); do source "$f"; done
unset f
