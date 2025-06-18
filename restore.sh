#!/bin/bash
set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles_backup_$(date +%s)"

echo "🧯 Creating backup at $BACKUP_DIR..."
mkdir -p "$BACKUP_DIR"

# List of individual files to restore
dotfiles=(.zshrc .Xresources .Xmodmap)
for file in "${dotfiles[@]}"; do
    if [ -f "$HOME/$file" ] && [ ! -L "$HOME/$file" ]; then
        echo "📦 Backing up $file"
        cp "$HOME/$file" "$BACKUP_DIR/"
    fi
    ln -sf "$DOTFILES_DIR/$file" "$HOME/$file"
done

# zinit
mkdir -p ~/.zinit
cp -r "$DOTFILES_DIR/.zinit/bin" ~/.zinit/ 

# Restore config files
mkdir -p ~/.config
config_files=(starship.toml mimeapps.list)
for file in "${config_files[@]}"; do
    if [ -f "$HOME/.config/$file" ] && [ ! -L "$HOME/.config/$file" ]; then
        echo "📦 Backing up ~/.config/$file"
        cp "$HOME/.config/$file" "$BACKUP_DIR/"
    fi
    ln -sf "$DOTFILES_DIR/.config/$file" ~/.config/$file
done

# Restore config directories
config_dirs=(i3 rofi polybar picom dunst wezterm)
for dir in "${config_dirs[@]}"; do
    if [ -d "$HOME/.config/$dir" ] && [ ! -L "$HOME/.config/$dir" ]; then
        echo "📦 Backing up ~/.config/$dir"
        mv "$HOME/.config/$dir" "$BACKUP_DIR/"
    fi
    ln -snf "$DOTFILES_DIR/.config/$dir" ~/.config/$dir
done

# Restore .desktop entries
mkdir -p ~/.local/share/applications
rsync -av --backup --suffix=".bak" "$DOTFILES_DIR/.local/share/applications/" ~/.local/share/applications/

# Background image
if [ -f "$DOTFILES_DIR/bg.png" ]; then
    mkdir -p ~/Pictures
    cp -v "$DOTFILES_DIR/bg.png" ~/Pictures/bg.png
fi

echo "📦 Restoring APT custom sources..."
# Restore keyrings
if [ -d "$DOTFILES_DIR/apt-keyrings" ]; then
    sudo mkdir -p /etc/apt/keyrings
    sudo cp -v "$DOTFILES_DIR/apt-keyrings/"* /etc/apt/keyrings/
fi
# Restore source lists
if [ -d "$DOTFILES_DIR/apt-sources" ]; then
    sudo cp -v "$DOTFILES_DIR/apt-sources/sources.list" /etc/apt/sources.list
    sudo cp -v "$DOTFILES_DIR/apt-sources/"*.list /etc/apt/sources.list.d/
fi

sudo apt update

echo "📦 Restoring APT packages from manual_install.txt..."
xargs -a "$DOTFILES_DIR/apt-packages.txt" sudo apt install -y

echo "✅ Restore complete. Backups saved at $BACKUP_DIR"
