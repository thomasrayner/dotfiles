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
alias ls='ls --color=auto'
alias ll='ls -la'
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
