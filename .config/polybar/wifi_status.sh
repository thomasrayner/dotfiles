#!/bin/bash

# Get line for active interface
wifi_line=$(grep "wlp0s20f3" /proc/net/wireless)

if [[ -z "$wifi_line" ]]; then
    echo "󰤮"  # Disconnected
    exit
fi

# Extract link quality (1st number after the colon, field 3)
link_quality=$(echo "$wifi_line" | awk '{print int($3)}')

# Scale to percent (out of 70)
strength=$(( link_quality * 100 / 70 ))

# Pick glyph
if (( strength < 30 )); then
    echo "󰤟"
elif (( strength < 60 )); then
    echo "󰤢"
elif (( strength < 80 )); then
    echo "󰤥"
else
    echo "󰤨"
fi

