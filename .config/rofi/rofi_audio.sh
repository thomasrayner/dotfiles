#!/bin/bash

# Dump PipeWire info
dumpfile="/tmp/pw-sinks.json"
pw-dump > "$dumpfile"

# Build list of sink info using node.name and node.description
mapfile -t sink_info < <(jq -r '
  .[] 
  | select(.type == "PipeWire:Interface:Node") 
  | select(.info.props."media.class" == "Audio/Sink") 
  | "\(.info.props."node.name")|\(.info.props."node.description")"
' "$dumpfile")

# Get default sink via pactl
default_sink=$(pactl info | grep 'Default Sink' | awk '{print $3}')

options=()
sinks=()

for info in "${sink_info[@]}"; do
    IFS='|' read -r sink_name sink_desc <<< "$info"
    [ -z "$sink_desc" ] && sink_desc="$sink_name"

    label="   $sink_desc"
    [ "$sink_name" = "$default_sink" ] && label="[✔️] $label"

    options+=("$label")
    sinks+=("$sink_name")
done

# Debug if empty
if [ ${#options[@]} -eq 0 ]; then
    echo "No audio outputs found." >&2
    cat "$dumpfile" >&2
    exit 1
fi

# Show Rofi menu
chosen=$(printf '%s\n' "${options[@]}" | rofi -dmenu -i -p "Select Audio Output")

# Match and switch
for i in "${!options[@]}"; do
    if [[ "${options[$i]}" == "$chosen" ]]; then
        pactl set-default-sink "${sinks[$i]}"
        break
    fi
done
