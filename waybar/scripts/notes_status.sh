#!/bin/bash

if pgrep -x "obsidian" > /dev/null; then
  echo '{"text":"     ", "class":"notes-active"}'
else
  echo '{"text":"     ", "class":"notes-inactive"}'
fi
