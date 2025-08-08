#!/bin/bash

APP_DIR="/usr/share/applications"
current_dir="$APP_DIR"
DMENU=(dmenu)

#flags thing
while [[ "$1" =~ ^- ]]; do
    DMENU+=("$1")
    shift
    if [[ "$1" =~ ^[0-9]+$ ]]; then
        DMENU+=("$1")
        shift
    fi
done

while true; do
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

    selection=$(echo "$options" | cut -d'|' -f1 | "${DMENU[@]}")

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
