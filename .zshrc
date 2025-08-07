eval "$(starship init zsh)"

function starship_transient_prompt_func() {
  starship module character  # Minimal prompt for past commands
}

function set_full_prompt() {
  PROMPT="$(starship prompt)"
  zle && zle .reset-prompt  # Only reset prompt if ZLE is active
}

function set_transient_prompt() {
  PROMPT="$(starship_transient_prompt_func)"
  zle && zle .reset-prompt  # Only reset prompt if ZLE is active
}

# Ensure add-zle-hook-widget is available
autoload -Uz add-zle-hook-widget

# Register ZLE hooks
add-zle-hook-widget line-init set_full_prompt
add-zle-hook-widget line-finish set_transient_prompt

# I don't know why I need this, but ssh/git doesn't work without it
if [ -z "$SSH_AUTH_SOCK" ]; then
    eval "$(ssh-agent -s)" > /dev/null 2>&1
    ssh-add ~/.ssh/mint_github > /dev/null 2>&1
fi

#--- Aliases ---
alias backupconfig='~/personal/dotfiles/backup.sh'
alias code=code-insiders
alias ls='ls -a --color=auto'
alias ll='ls -lah'
alias lc='ls -la | lolcat'
alias vim='nvim'

#--- History ---
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt share_history
setopt inc_append_history
setopt hist_ignore_dups
setopt hist_reduce_blanks

#--- Zinit Setup ---
source "$HOME/.zinit/bin/zinit.zsh"

zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light Aloxaf/fzf-tab

#--- Completion Tuning ---
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
autoload -Uz compinit
compinit
zstyle ':completion:*' menu select
zstyle ':fzf-tab:*' fzf-preview 'echo {}'

#--- Smart History Search ---
bindkey '^R' history-incremental-search-backward

# Created by `pipx` on 2025-06-13 16:58:23
export PATH="$PATH:/home/thomas/.local/bin"

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust


#--- Path additions ---
export PATH="$HOME/bin:$PATH"
export PATH="$(go env GOPATH)/bin:$PATH"

#--- Fuzzy finding ---
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_CTRL_T_OPTS="
  --preview 'batcat --style=numbers --color=always {}' \
  --bind 'ctrl-/:change-preview-window(down|hidden)'"

cc() {
  local dir
  dir=$(find ~ /mnt -name '.*' -path '*/.git' -prune -o -type d -maxdepth 7 2>/dev/null | fzf --preview 'ls -la {}') && cd "$dir"
}
ci() {
  local dir
  dir=$(find ./ -name '.*' -path '*/.git' -prune -o -type d -maxdepth 7 2>/dev/null | fzf --preview 'ls -la {}') && cd "$dir"
}

yolo() {
  echo -n "🔧 Commit message: "
  read msg
  if [ -z "$msg" ]; then
    echo "🚫 Empty commit message. Aborted."
    return 1
  fi
  git add -A && git commit -m "$msg" && git push
}
#
# opencode
export PATH=/home/thomas/.opencode/bin:$PATH

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
