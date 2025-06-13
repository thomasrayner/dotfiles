#!/bin/bash

# Arrays for tracking
ssid_list=()
menu_list=()

# Populate the arrays
while IFS=: read -r ssid security signal; do
  [[ -z "$ssid" ]] && continue

  # Signal bars
  if (( signal >= 80 )); then bars="▂▄▆█"
  elif (( signal >= 60 )); then bars="▂▄▆_"
  elif (( signal >= 40 )); then bars="▂▄__"
  elif (( signal >= 20 )); then bars="▂___"
  else bars="_"
  fi

  # Lock icon
  [[ "$security" != "--" ]] && lock="🔐" || lock=" "

  # Add entries
  ssid_list+=("$ssid")
  menu_list+=("${ssid}  [${lock} ${bars}]")
done < <(nmcli -t -f SSID,SECURITY,SIGNAL dev wifi list)

# Show menu, get index
choice_index=$(printf '%s\n' "${menu_list[@]}" | rofi -dmenu -format i -p "Wi-Fi" -theme-str 'window { width: 30%; }')
[[ -z "$choice_index" ]] && exit

ssid="${ssid_list[$choice_index]}"

# Try saved connection
if nmcli connection up "$ssid" 2>/dev/null; then
  exit
fi

# Prompt for password
pass=$(rofi -dmenu -p "Password for $ssid" -password)
[[ -z "$pass" ]] && exit

nmcli dev wifi connect "$ssid" password "$pass"

