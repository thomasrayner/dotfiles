> Restore is super broken right now.

# dotfiles

Welcome to the sacred tomb of my Linux Mint config.

You know what a dotfiles repo is.

## 🧠 What This Does

- `./backup.sh` backups up:
  - `.config/` files for i3, Polybar, Rofi, Dunst, Picom, and more
  - Shell configs (`.zshrc`, `.Xresources`, `.Xmodmap`, etc.)
  - APT package list (`manual_install.txt`)
  - PPA sources + modern `.list`-style third-party APT sources
  - APT keyrings used by custom repos

- Includes:
  - Custom scripts for Rofi Bluetooth/audio control (some WIP)
  - Polybar integration and custom launchers
  - A background image I always forget
- Does *not* restore automatically. You must *choose violence* with `restore.sh`.

- Neovim:
  - This repo intentionally does not address my nvim config
  - My nvim config is a separate repo: [thomasrayner/nvim](https://github.com/thomasrayner/nvim)

## 🧾 Scripts

| Script         | Purpose                                                                 |
|----------------|-------------------------------------------------------------------------|
| `backup.sh`    | Syncs your current config state into the repo.                         |
| `restore.sh`   | Restores the backed-up state onto a new system. Use with caution.      |
| `manual_install.txt` | List of packages installed with `apt`, used for bulk reinstalls. |

## 🧟 Legacy Notes: Surface & Intune Portal

This repo contains **a bunch of cursed packages** needed to get:

- Microsoft Intune Portal working on Linux (don’t ask)
- Surface-specific kernel and driver tweaks (keyboard, touchscreen, webcam… yeah)

Some of these packages are mostly *orphaned* now. Your system may say they're installed, but you won't find them in modern repos. That's fine. Let them rest. Hopefully you can skip these.

> [!TIP]
> Future me: There's a page in your OneNote about setting up work stuff. Go there, not here, for that.

## 🧘‍♂️ Philosophy

This setup is intentionally lightweight, flexible, and semi-reckless. I don’t aim for distro-agnostic perfection—I aim for personal clarity and quick recovery when everything breaks. And everything *will* break. That's part of the fun.

## 🔥 Usage

To back up your current config:

```bash
./backup.sh
```

To restore a previous setup:

```bash
# only if you're sure
./restore.sh
```
