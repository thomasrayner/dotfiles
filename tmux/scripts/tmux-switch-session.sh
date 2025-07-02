#!/usr/bin/env bash

sessions=$(tmux list-sessions -F "#{session_name}")
choice=$(printf "%s\n" $sessions | fzf-tmux -p --reverse) || exit

tmux switch-client -t "$choice"
