#!/usr/bin/env bash

WALLPAPER_DIR="$HOME/wallpapers/"
CURRENT_WALL=$(hyprctl hyprpaper listloaded)

# Get a random wallpaper that is not the current one
WALLPAPER=$(find "/home/liam/Pictures/wallpapers" -type f ! -name "$(basename "$CURRENT_WALL")" | shuf -n 1)

# Apply the selected wallpaper
hyprctl hyprpaper reload ,"$WALLPAPER"

wal -i $WALLPAPER

c1=$(grep "#" ~/.cache/wal/colors | sed -n '1p')
c2=$(grep "#" ~/.cache/wal/colors | sed -n '2p')
c3=$(grep "#" ~/.cache/wal/colors | sed -n '3p')
c4=$(grep "#" ~/.cache/wal/colors | sed -n '4p')
c5=$(grep "#" ~/.cache/wal/colors | sed -n '5p')
c6=$(grep "#" ~/.cache/wal/colors | sed -n '6p')
c7=$(grep "#" ~/.cache/wal/colors | sed -n '7p')
c8=$(grep "#" ~/.cache/wal/colors | sed -n '8p')
c9=$(grep "#" ~/.cache/wal/colors | sed -n '9p')
c10=$(grep "#" ~/.cache/wal/colors | sed -n '10p')
c11=$(grep "#" ~/.cache/wal/colors | sed -n '11p')
c12=$(grep "#" ~/.cache/wal/colors | sed -n '12p')
c13=$(grep "#" ~/.cache/wal/colors | sed -n '13p')
c14=$(grep "#" ~/.cache/wal/colors | sed -n '14p')
c15=$(grep "#" ~/.cache/wal/colors | sed -n '15p')
c16=$(grep "#" ~/.cache/wal/colors | sed -n '16p')



#BORDER=$(xrdb -query | grep '\*color1' | head -n1 | sed 's/.*#//')
#BORDER=$(grep '\*color1' ~/.Xresources | head -n1 | sed 's/.*#//')



if xrdb -query 2>/dev/null | grep -q '\*color1'; then
  BORDER=$(xrdb -query | grep '\*color1' | head -n1 | sed 's/.*#//')
fi

hyprctl keyword general:col.active_border "rgb($BORDER)"
#hyprctl keyword general:col.active_border "0xff$BORDER"
notify-send $WALLPAPER
notify-send 0xff$BORDER
