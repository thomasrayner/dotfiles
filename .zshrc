# Basics / sanity
setopt prompt_subst
setopt interactive_comments

# Delete key
bindkey "${terminfo[kdch1]}" delete-char

# PATH
export PATH="$HOME/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH" # pipx etc.
export PATH="$(go env GOPATH 2>/dev/null)/bin:$PATH"
export PATH="$HOME/.opencode/bin:$PATH"

# NVM (keep before compinit so it can add completions if it wants)
export NVM_DIR="$HOME/.nvm"
[[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh"

# Zinit
source "$HOME/.zinit/bin/zinit.zsh"

# Annexes
zinit light-mode for \
  zdharma-continuum/zinit-annex-as-monitor \
  zdharma-continuum/zinit-annex-bin-gem-node \
  zdharma-continuum/zinit-annex-patch-dl \
  zdharma-continuum/zinit-annex-rust

# Completion system
autoload -Uz compinit
# Use a cached compdump - speeds startup and reduces flakiness
compinit -d "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/compdump"

# More permissive matching
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' menu select

# Plugins
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-syntax-highlighting

# fzf-tab
zinit light Aloxaf/fzf-tab
zstyle ':fzf-tab:*' fzf-preview 'echo {}'

# Autosuggestions expansion
zinit light zsh-users/zsh-autosuggestions

# Set autosuggest strategy explicitly
typeset -gA _l_AUTOSUGGEST
_l_AUTOSUGGEST[strategy]=history
ZSH_AUTOSUGGEST_STRATEGY=history

# Re-run compinit now that zsh-completions is on $fpath
compinit -C -d "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/compdump"

# History
HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000
setopt share_history
setopt inc_append_history
setopt hist_ignore_dups
setopt hist_reduce_blanks

# Keybinds
bindkey '^R' history-incremental-search-backward
bindkey "^[^H" backward-kill-word

# Starship prompt
eval "$(starship init zsh)"

autoload -Uz add-zle-hook-widget

_l_full_prompt() {
  PROMPT="$(starship prompt)"
}

_l_transient_prompt() {
  PROMPT="$(starship module character)"
}

# - When a new line starts: full prompt
# - When you accept the line: replace previous prompt with transient
_l_line_init()   { _l_full_prompt; zle reset-prompt; }
_l_line_finish() { _l_transient_prompt; zle reset-prompt; }

add-zle-hook-widget line-init   _l_line_init
add-zle-hook-widget line-finish _l_line_finish


# FZF
[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh
export FZF_CTRL_T_OPTS="
  --preview 'batcat --style=numbers --color=always {}' \
  --bind 'ctrl-/:change-preview-window(down|hidden)'"

# Aliases
alias code=code-insiders
alias ls='ls -a --color=auto'
alias ll='ls -lah'
alias lc='ls -la | lolcat'
alias vim='nvim'

# Functions
cc() {
  local dir
  dir=$(find ~ /mnt -name '.*' -path '*/.git' -prune -o -type d -maxdepth 7 2>/dev/null \
    | fzf --preview 'ls -la {}') && cd "$dir"
}

ci() {
  local dir
  dir=$(find ./ -name '.*' -path '*/.git' -prune -o -type d -maxdepth 7 2>/dev/null \
    | fzf --preview 'ls -la {}') && cd "$dir"
}

yolo() {
  echo -n "🔧 Commit message: "
  read -r msg
  [[ -z "$msg" ]] && { echo "🚫 Empty commit message. Aborted."; return 1; }
  git add -A && git commit -m "$msg" && git push
}

# Autosuggest toggles
autosuggest_on()  { ZSH_AUTOSUGGEST_MANUAL_REBIND=1; _zsh_autosuggest_start; }
autosuggest_off() { _zsh_autosuggest_stop; }

autosuggest_toggle() {
  if (( ${+ZSH_AUTOSUGGEST_ACTIVE} )) && [[ "$ZSH_AUTOSUGGEST_ACTIVE" == "1" ]]; then
    autosuggest_off
    echo "🧠 autosuggest: OFF"
  else
    autosuggest_on
    echo "🧠 autosuggest: ON"
  fi
}

# Toggle what autosuggestions are sourced from:
# - history: only past commands
# - completion: suggest based on completion engine
# - (optional) both: history completion
autosuggest_source_history() {
  ZSH_AUTOSUGGEST_STRATEGY=history
  _l_AUTOSUGGEST[strategy]=history
  echo "🧠 autosuggest source: HISTORY"
}

autosuggest_source_completion() {
  ZSH_AUTOSUGGEST_STRATEGY=completion
  _l_AUTOSUGGEST[strategy]=completion
  echo "🧠 autosuggest source: COMPLETION"
}

autosuggest_source_both() {
  ZSH_AUTOSUGGEST_STRATEGY=(history completion)
  _l_AUTOSUGGEST[strategy]=both
  echo "🧠 autosuggest source: HISTORY+COMPLETION"
}

# Auto-start tmux (last-ish)
if [[ -z "$TMUX" && -t 1 ]]; then
  tmux attach-session -t main 2>/dev/null || tmux new-session -s main
fi

# The hotness
fastfetch
