#!/bin/bash
set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "🔄 Backing up dotfiles to $DOTFILES_DIR..."

# Dotfiles in ~
cp -v ~/.zshrc "$DOTFILES_DIR/.zshrc"
cp -v ~/.Xresources "$DOTFILES_DIR/.Xresources"
cp -v ~/.Xmodmap "$DOTFILES_DIR/.Xmodmap"
cp -v ~/.config/starship.toml "$DOTFILES_DIR/.config/starship.toml"
cp -v ~/.config/mimeapps.list "$DOTFILES_DIR/mimeapps.list"

# App-specific config directories
rsync -av --delete ~/.config/i3/ "$DOTFILES_DIR/.config/i3/"
rsync -av --delete ~/.config/rofi/ "$DOTFILES_DIR/.config/rofi/"
rsync -av --delete ~/.config/polybar/ "$DOTFILES_DIR/.config/polybar/"
rsync -av --delete ~/.config/picom/ "$DOTFILES_DIR/.config/picom/"
rsync -av --delete ~/.config/dunst/ "$DOTFILES_DIR/.config/dunst/"

# Local applications (desktop entries)
rsync -av --delete ~/.local/share/applications/ "$DOTFILES_DIR/.local/share/applications/"

# Background image (if it exists)
[ -f ~/personal/bg.png ] && cp -v ~/personal/bg.png "$DOTFILES_DIR/bg.png"

echo "✅ Dotfiles backup complete."

echo "📦 Saving manually installed APT packages..."
comm -23 <(apt-mark showmanual | sort) <(gzip -dc /var/log/installer/initial-status.gz | awk '/^Package: / { print $2 }' | sort) > "$DOTFILES_DIR/manual_install.txt"

echo "📜 Backing up all custom APT sources..."

mkdir -p "$DOTFILES_DIR/apt-sources"
cp -rv /etc/apt/sources.list.d "$DOTFILES_DIR/apt-sources/"
cp -v /etc/apt/sources.list "$DOTFILES_DIR/apt-sources/sources.list"

# Also copy any apt keyrings used
mkdir -p "$DOTFILES_DIR/apt-keyrings"
find /etc/apt/keyrings -type f -exec cp -v {} "$DOTFILES_DIR/apt-keyrings/" \;
