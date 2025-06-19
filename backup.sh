#!/bin/bash
set -e
VERBOSE=0

if [[ "$1" == "-verbose" ]]; then
    VERBOSE=1
fi

run() {
    if [[ $VERBOSE -eq 1 ]]; then
        "$@"
    else
        "$@" >/dev/null 2>&1
    fi
}

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "🔄 Backing up dotfiles to $DOTFILES_DIR..."

# Dotfiles in ~
run cp -v ~/.zshrc "$DOTFILES_DIR/.zshrc"
run cp -v ~/.Xresources "$DOTFILES_DIR/.Xresources"
run cp -v ~/.Xmodmap "$DOTFILES_DIR/.Xmodmap"
run cp -v ~/.config/starship.toml "$DOTFILES_DIR/.config/starship.toml"
run cp -v ~/.config/mimeapps.list "$DOTFILES_DIR/mimeapps.list"

# App-specific config directories
run rsync -av --delete ~/.config/i3/ "$DOTFILES_DIR/.config/i3/"
run rsync -av --delete ~/.config/rofi/ "$DOTFILES_DIR/.config/rofi/"
run rsync -av --delete ~/.config/polybar/ "$DOTFILES_DIR/.config/polybar/"
run rsync -av --delete ~/.config/picom/ "$DOTFILES_DIR/.config/picom/"
run rsync -av --delete ~/.config/dunst/ "$DOTFILES_DIR/.config/dunst/"
run rsync -av --delete ~/.config/wezterm/ "$DOTFILES_DIR/.config/wezterm/"
run rsync -av --delete ~/.zinit/ "$DOTFILES_DIR/.zinit/"

# Local applications (desktop entries)
run rsync -av --delete ~/.local/share/applications/ "$DOTFILES_DIR/.local/share/applications/"

# Background image (if it exists)
[ -f ~/personal/bg.png ] && run cp -v ~/personal/bg.png "$DOTFILES_DIR/bg.png"

echo "📦 Saving manually installed APT packages..."
run comm -23 <(apt-mark showmanual | sort) <(gzip -dc /var/log/installer/initial-status.gz | awk '/^Package: / { print $2 }' | sort) > "$DOTFILES_DIR/manual_install.txt"

echo "📜 Backing up all custom APT sources..."

run mkdir -p "$DOTFILES_DIR/apt-sources"
run cp -rv /etc/apt/sources.list.d "$DOTFILES_DIR/apt-sources/"
run cp -v /etc/apt/sources.list "$DOTFILES_DIR/apt-sources/sources.list"

# Also copy any apt keyrings used
run mkdir -p "$DOTFILES_DIR/apt-keyrings"
run find /etc/apt/keyrings -type f -exec cp -v {} "$DOTFILES_DIR/apt-keyrings/" \;

echo "✅ Backup complete."

echo "❓ Changes:"
git -C "$DOTFILES_DIR" status -s --ahead-behind
