#!/usr/bin/env bash

folder=$HOME/Nextcloud/notes/
TERMINAL=$'kitty --class note'
TERMINAL_daily=$'kitty --class daily'
editor=nvim

#TODO
#- make the ssh connection a variable
#- put the folder on remote in a variable
#- remove what is not needed

today=$(date +"%Y-%m-%d")
selected() {
	choice=$(echo -e "Server search\nbash\n$(
		cd "$folder" || exit
		find . -type f -print0 \
			| while IFS= read -r -d '' file; do
		#skip dotfiles 
		[[ "$file" =~ /\. ]] && continue
		mtime=$(stat -c '%Y' "$file")
		echo "$mtime $file"
	done \
		| sort -nr \
		| cut -d' ' -f2- \
		| sed 's|^\./||'
	)" | dmenu -c -l 15 -i -p "Choose note or create new:" )

	case "$choice" in
		Daily) setsid -f $TERMINAL ssh -p 54991 liam@207.164.238.196 -t "$editor" "~//notes/daily-notes/$today.md" ;;
		"Server search") setsid -f alacritty -e ssh -p 54991 liam@207.164.238.196 -t bash ~/vault/open.sh ;;
		"test") setsid -f $TERMINAL ssh -p 54991 liam@207.164.238.196 -t -v "tmux" ;;
		"bash") setsid -f alacritty -e ssh -p 54991 liam@207.164.238.196 -t "bash" ;;
		*.md) setsid -f $TERMINAL ssh -p 54991 liam@207.164.238.196 -t "$editor" "~/notes/$choice" ;;
	esac
}

selected
