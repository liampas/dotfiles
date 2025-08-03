#!/bin/bash

APP_DIR="/usr/share/applications"
current_dir="$APP_DIR"

while true; do
    # Build list: folder names + .desktop file names
    options=$(
        for f in "$current_dir"/*; do
            if [[ -d "$f" ]]; then
                echo "[${f##*/}]"
            elif [[ "$f" == *.desktop ]]; then
                name=$(grep -m1 '^Name=' "$f" | cut -d= -f2-)
                exec=$(grep -m1 '^Exec=' "$f" | cut -d= -f2- | sed 's/ *%[fFuUdDnNickvm]//g')
                [[ -n "$name" && -n "$exec" ]] && echo "$name|$exec"
            fi
        done
    )

    selection=$(echo "$options" | cut -d'|' -f1 | dmenu -i -l 20)

    [[ -z "$selection" ]] && exit 0

    if [[ "$selection" == \[*\] ]]; then
        folder_name="${selection:1:-1}"
        current_dir="$current_dir/$folder_name"
    else
        cmd=$(echo "$options" | grep "^$selection|" | cut -d'|' -f2-)
        [[ -n "$cmd" ]] && setsid $cmd >/dev/null 2>&1 &
        exit 0
    fi
done
