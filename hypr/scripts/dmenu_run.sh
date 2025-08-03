#!/bin/bash

# Find all .desktop files
desktop_files=$(find /usr/share/applications ~/.local/share/applications -name "*.desktop")

# Create a list of apps with names and Exec lines
choices=$(
    while IFS= read -r file; do
        name=$(grep -m1 '^Name=' "$file" | cut -d= -f2-)
        exec=$(grep -m1 '^Exec=' "$file" | cut -d= -f2- | sed 's/ *%[fFuUdDnNickvm]//g')
        [[ -n "$name" && -n "$exec" ]] && echo "$name|$exec"
    done <<< "$desktop_files"
)

# Show dmenu
selection=$(echo "$choices" | cut -d'|' -f1 | sort | dmenu -i -c -l 20)

# Run selected command
cmd=$(echo "$choices" | grep "^$selection|" | cut -d'|' -f2-)

[[ -n "$cmd" ]] && setsid $cmd >/dev/null 2>&1 &
