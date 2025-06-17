#!/bin/bash

# Only touch known-safe sensor data
TEMP=$(sensors | grep 'Package id 0:' | awk '{print $4}' | sed 's/+//g' | sed 's/°C//g')

if [[ -n "$TEMP" ]]; then
    echo " ${TEMP}°C"
else
    echo " --°C"
fi
