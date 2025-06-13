#!/bin/bash

emoji=$(cat ~/.config/rofi/emoji-rofi.txt | rofi -dmenu -i -p "Pick Emoji" | cut -d ' ' -f1)

if [ -n "$emoji" ]; then
    echo -n "$emoji" | xclip -selection clipboard
    notify-send "Emoji copied!" "$emoji"
fi
