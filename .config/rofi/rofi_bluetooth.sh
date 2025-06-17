#!/bin/bash

# Get clean list of paired devices
mapfile -t lines < <(echo "devices" | bluetoothctl | grep ^Device)

options=()
macs=()
names=()
states=()

for line in "${lines[@]}"; do
    mac=$(echo "$line" | awk '{print $2}')
    name=$(echo "$line" | cut -d ' ' -f3-)
    [ -z "$name" ] && name="$mac"

    info=$(echo "info $mac" | bluetoothctl)
    connected=$(echo "$info" | grep "Connected: yes")

    if [[ -n "$connected" ]]; then
        label="  $name (Connected)"
        states+=("connected")
    else
        label="  $name"
        states+=("disconnected")
    fi

    options+=("$label")
    macs+=("$mac")
    names+=("$name")
done

# Display Rofi
chosen=$(printf '%s\n' "${options[@]}" | rofi -dmenu -p "Bluetooth Devices")

# Toggle connection
for i in "${!options[@]}"; do
    if [[ "${options[$i]}" == "$chosen" ]]; then
        mac="${macs[$i]}"
        state="${states[$i]}"
        if [[ "$state" == "connected" ]]; then
            echo "disconnect $mac" | bluetoothctl && notify-send "Bluetooth" "Disconnected from ${names[$i]}"
        else
            echo "connect $mac" | bluetoothctl && notify-send "Bluetooth" "Connected to ${names[$i]}"
        fi
        break
    fi
done
