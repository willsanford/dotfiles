#!/usr/bin/env bash

# Set the background
feh --bg-fill ~/.config/awesome/backgrounds/1.png

# Run startup apps
killall -9 conky
conky
