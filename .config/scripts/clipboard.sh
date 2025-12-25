#!/bin/bash

whatever=$(grep -oP '{\K[^}]+' ~/.config/clipse/clipboard_history.json | cut -d"," -f 1 | cut -d":" --complement -f1)

notify-send "cut -d":" --complement -f1 "$whatever""

grep -oP '{\K[^}]+' ~/.config/clipse/clipboard_history.json | awk -F'"value":' '{print $2}' | awk -F'recorded' '{print $1}' | awk '{print substr($0, 2, length($0)-4)}'

grep -oP '{\K[^}]+' ~/.config/clipse/clipboard_history.json | awk -F'"filePath":' '{print $2}' | awk -F'pinned' '{print $1}' | awk '{print substr($0, 2, length($0)-4)}' | dmenu -ip "" -is 160 -l 60
