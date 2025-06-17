#!/bin/bash

# Start scanning and gather live results
scan_output=$(mktemp)

# Run bluetoothctl in background to collect scan results
stdbuf -oL bluetoothctl <<EOF > "$scan_output" &
power on
scan on
EOF

# Let it scan for a few seconds
sleep 8

# Stop scanning
echo -e 'scan off\nexit\n' | bluetoothctl

# Extract newly discovered device names + MACs
mapfile -t new_devices < <(grep -Eo "Device ([A-F0-9:]{17}) .+" "$scan_output" | sort | uniq)

# Filter out already paired devices
mapfile -t paired_macs < <(echo "paired-devices" | bluetoothctl | grep ^Device | awk '{print $2}')

unpaired_devices=()
macs=()
names=()

for device in "${new_devices[@]}"; do
    mac=$(echo "$device" | awk '{print $2}')
    name=$(echo "$device" | cut -d ' ' -f3-)
    
    if [[ ! " ${paired_macs[*]} " =~ " $mac " ]]; then
        label="  $name"
        unpaired_devices+=("$label")
        macs+=("$mac")
        names+=("$name")
    fi
done

# Bail if no unpaired devices
if [[ ${#unpaired_devices[@]} -eq 0 ]]; then
    notify-send "Bluetooth" "No new devices found"
    exit 0
fi

# Show Rofi
chosen=$(printf '%s\n' "${unpaired_devices[@]}" | rofi -dmenu -p "Pair New Device")

# Match and pair/trust/connect
for i in "${!unpaired_devices[@]}"; do
    if [[ "${unpaired_devices[$i]}" == "$chosen" ]]; then
        mac="${macs[$i]}"
        name="${names[$i]}"
        
        (
            echo "pair $mac"
            sleep 2
            echo "trust $mac"
            sleep 1
            echo "connect $mac"
            sleep 2
        ) | bluetoothctl

        notify-send "Bluetooth" "Paired and connected to $name"
        break
    fi
done
