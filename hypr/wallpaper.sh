#!/usr/bin/env bash

WALLPAPER_DIR="$HOME/wallpapers/"
CURRENT_WALL=$(hyprctl hyprpaper listloaded)

# Get a random wallpaper that is not the current one
WALLPAPER=$(find "/home/liam/Pictures/wallpapers" -type f ! -name "$(basename "$CURRENT_WALL")" | shuf -n 1)

# Apply the selected wallpaper
hyprctl hyprpaper reload ,"$WALLPAPER"

wal -i $WALLPAPER

#BORDER=$(xrdb -query | grep '\*color1' | head -n1 | sed 's/.*#//')
#BORDER=$(grep '\*color1' ~/.Xresources | head -n1 | sed 's/.*#//')



if xrdb -query 2>/dev/null | grep -q '\*color1'; then
  BORDER=$(xrdb -query | grep '\*color1' | head -n1 | sed 's/.*#//')
fi

hyprctl keyword general:col.active_border "rgb($BORDER)"
#hyprctl keyword general:col.active_border "0xff$BORDER"
notify-send $WALLPAPER
notify-send 0xff$BORDER
