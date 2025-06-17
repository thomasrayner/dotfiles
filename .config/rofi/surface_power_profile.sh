#!/bin/bash

current_profile=$(surface profile get 2>/dev/null)
profiles=("low-power" "balanced" "balanced-performance" "performance")

menu=$(for profile in "${profiles[@]}"; do
    if [[ "$profile" == "$current_profile" ]]; then
        echo "$profile ✅"
    else
        echo "$profile"
    fi
done | rofi -dmenu -p "Power Profile")

selected=$(echo "$menu" | sed 's/ ✅//')

if [[ " ${profiles[*]} " == *" $selected "* ]]; then
    sudo surface profile set "$selected"
    sleep 0.1
    new_profile=$(surface profile get 2>/dev/null)
    notify-send "Power Profile Changed" "Now using: $new_profile"
fi
