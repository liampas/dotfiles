folder=$HOME/Nextcloud/Vault/  

today=$(date +"%Y-%m-%d")                                                                     
time=$(date +"(%H:%M) ")
dailypath="${folder}daily-notes/${today}.md"                                                  

if [[ ! -f $dailypath ]]; then                                                                
	notify-send "no daily note found"
	notify-send $dailypath
	exit
fi                                                                                            

note="$(echo "" | dmenu -b -sb "#8A5CF5" -nf "#d8dee9" -p "$time" <&-)" || exit 0

#determine where to put the note in the file
line=$(awk '/# Journal/{ print NR; exit }' $dailypath)
line=$(($line-4))
empty=$(sed -n "${line}p" "$dailypath")
while [[ $empty ]]
do
	line=$(($line+1))
	empty=$(sed -n "${line}p" "$dailypath")
done

time=$(date +"(%H:%M) ")

#if the last line had a the same time, it wont rewrite it
prev_line=$(($line-1))
previous=$(sed -n "${prev_line}p" "$dailypath")
case "$previous" in
	*$time* )
		note="$(echo $note)"
		;;
	*)
		note="$(echo $time$note)"
		;;
esac

#inserts the note in the file
sed -i "$line i $note" $dailypath
