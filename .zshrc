eval "$(starship init zsh)"
export TERMINAL=wezterm
export TERM=xterm-256color
export PATH="$HOME/.local/bin:$PATH"

# I don't know why I need this, but ssh/git doesn't work without it
if [ -z "$SSH_AUTH_SOCK" ]; then
    eval "$(ssh-agent -s)" > /dev/null 2>&1
    ssh-add ~/.ssh/mint_github > /dev/null 2>&1
fi

#--- Aliases ---
alias backupconfig='~/personal/dotfiles/backup.sh'
alias code=code-insiders
alias ls='ls -a --color=auto'
alias ll='ls -la'
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

### End of Zinit's installer chunk
export PATH="$HOME/bin:$PATH"

#--- Fuzzy finding ---
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_CTRL_T_OPTS="
  --preview 'batcat --style=numbers --color=always {}' \
  --bind 'ctrl-/:change-preview-window(down|hidden)'"

cc() {
  local dir
  dir=$(find ~ -name '.*' -o -type d -maxdepth 7 2>/dev/null | fzf --preview 'ls -la {}') && cd "$dir"
}
ci() {
  local dir
  dir=$(find ./ -name '.*' -o -type d -maxdepth 7 2>/dev/null | fzf --preview 'ls -la {}') && cd "$dir"
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

