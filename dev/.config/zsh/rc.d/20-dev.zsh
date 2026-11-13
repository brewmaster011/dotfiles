# ABOUTME: dev's zsh settings (toolchains, project jump), sourced from rc.d by
# ABOUTME: common's zshrc

# Toolchains: Go (Linux manual install; macOS uses Homebrew's go), opencode
# (install script), cargo, .NET. ~/.local/bin stays first.
path=("$HOME/.local/bin" /usr/local/go/bin "$HOME/.opencode/bin" "$HOME/.cargo/bin"
      "$HOME/.cache/dotnet" "$HOME/.cache/dotnet/tools" $path)
export DOTNET_ROOT="$HOME/.cache/dotnet"

# fzf_cd: fuzzy find a project directory, then pick a git worktree if available
fzf_cd() {

  local repo wt_list wt

  repo=$(
    fd --type d --max-depth 1 '' "${PROJECTS_DIR:-$HOME/Documents/source}" \
      | fzf --prompt "Select Directory"
  )

  if [[ -z $repo ]]; then
      zle reset-prompt
      return 1
  fi

  wt_list=(
    ${(f)"$(git -C "${repo}" worktree list --porcelain 2>/dev/null)"}
  )

  if (( ${#wt_list[@]} )); then
    wt=$(
      printf "%s\n" "${wt_list[@]}" \
        | awk '/^worktree / { print $2 }' \
        | fzf --prompt="Select Worktree (esc = master/main)> "
    )
  fi

  if [[ -n $wt ]]; then
    cd -- "$wt"
  else
    cd -- "$repo"
    cd main 2>/dev/null || cd master 2>/dev/null || true
  fi

  zle reset-prompt
  return 0
}

zle -N fzf_cd
bindkey '^g' fzf_cd
