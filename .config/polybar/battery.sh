#!/bin/bash

capacity=$(< /sys/class/power_supply/BAT1/capacity)
status=$(< /sys/class/power_supply/BAT1/status)

icon=""
if [[ "$status" == "Charging" ]]; then
    icon=""
elif (( capacity <= 20 )); then
    icon=""
elif (( capacity <= 40 )); then
    icon=""
elif (( capacity <= 60 )); then
    icon=""
elif (( capacity <= 80 )); then
    icon=""
else
    icon=""
fi

echo "$icon ${capacity}%"
