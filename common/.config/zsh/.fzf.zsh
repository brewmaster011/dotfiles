# Setup fzf
# ---------
if [[ ! "$PATH" == */home/bshtrepi/Documents/repos/fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/home/bshtrepi/Documents/repos/fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/home/bshtrepi/Documents/repos/fzf/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
source "/home/bshtrepi/Documents/repos/fzf/shell/key-bindings.zsh"

eval $(fzf --zsh)
