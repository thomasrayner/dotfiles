#!/bin/bash

DUNSTSTATUS=$(dunstctl is-paused)

if [[ "$DUNSTSTATUS" = "true" ]]; then
    echo "%{F#ff0000}%{F-}"
else
    echo "%{F#22b622}%{F-}"
fi
