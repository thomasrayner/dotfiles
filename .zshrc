eval "$(starship init zsh)"
export TERMINAL=wezterm
export TERM=xterm-256color
export PATH="$HOME/.local/bin:$PATH"

if [ -z "$SSH_AUTH_SOCK" ]; then
    eval "$(ssh-agent -s)"
    ssh-add ~/.ssh/mint_github 2> /dev/null
fi

alias backupconfig='~/personal/dotfiles/backup.sh'
# Created by `pipx` on 2025-06-13 16:58:23
export PATH="$PATH:/home/thomas/.local/bin"
