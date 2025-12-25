#!/bin/bash

APP_DIR="/home/liam/Pictures/wallpap"
DMENU=(dmenu -i)

# Parse flags
while [[ "$1" =~ ^- ]]; do
    if [[ "$1" == "--dir" ]]; then
        shift
        APP_DIR="$1"
        shift
    else
        DMENU+=("$1")
        shift
        [[ "$1" =~ ^[0-9]+$ ]] && DMENU+=("$1") && shift
    fi
done

current_dir="$APP_DIR"

while true; do
    options=$(
        for f in "$current_dir"/*; do
            if [[ -d "$f" ]]; then
                echo "[${f##*/}]"
            elif [[ "$f" == *.jpg ]]; then
                #echo "$f"
                echo "${f##*/}"
                
            fi
        done
    )

    selection=$(echo "$options" | cut -d'|' -f1 | "${DMENU[@]}")

    [[ -z "$selection" ]] && exit 0

    #folder
    if [[ "$selection" == \[*\] ]]; then
        folder_name="${selection:1:-1}"
        current_dir="$current_dir/$folder_name"
        continue
    fi

    #image file
    if [[ "$selection" == amogus.jpg ]]; then

    echo amogus
    exit 0
    else
        #if you entered something not from the list
echo "$selection"
        hyprctl hyprpaper reload , "$current_dir/$selection"
        echo "$current_dir"
        exit 0
    fi
        
done
