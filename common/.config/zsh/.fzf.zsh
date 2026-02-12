# Setup fzf
# ---------
if [[ ! "$PATH" == *$HOME/Documents/repos/fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}$HOME/Documents/repos/fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "$HOME/Documents/repos/fzf/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
source "$HOME/Documents/repos/fzf/shell/key-bindings.zsh"

eval $(fzf --zsh)
