#!/bin/bash

if hyprctl clients -j | jq -e '.[] | select(.class == "achievements")' > /dev/null; then
  echo '{"text":"     ", "class":"achievements-active"}'
else
  echo '{"text":"     ", "class":"achievements-inactive"}'
fi
