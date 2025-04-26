#!/bin/bash

if hyprctl clients -j | jq -e '.[] | select(.class == "info")' > /dev/null; then
  echo '{"text":"     ", "class":"info-active"}'
else
  echo '{"text":"     ", "class":"info-inactive"}'
fi
