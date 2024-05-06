#!/bin/sh

LOGFILE=/mnt/SDCARD/Logs/BGM.log
SCRIPTNAME=$(basename "$0")
echo "$(date): Running $SCRIPTNAME" >> $LOGFILE


THEMEPATH=/mnt/UDISK/system.json
SDCARDPATH=/mnt/SDCARD/


#Grab current running theme
#Theme value is -> mnt/SDCARD/Themes/xxx/
theme_value=$(grep '"theme"' $THEMEPATH | cut -d ':' -f 2 | tr -d ' ",}' | sed 's:/*$::')/
theme_value=$(echo "$theme_value" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
echo "Current Theme: $theme_value" >> "$LOGFILE"

#If theme is Default, Theme value is -> ../res/ 
#Default sound is from /usr/trimui/res/sound/
if echo "$theme_value" | grep -q "/res/"; then
	echo "Using Default Theme" >> $LOGFILE
	theme_value="/usr/trimui/res/"
fi


#Swap sound from Root of SDCARD /mnt/SDCARD/bgm.mp3 if present
#Note this will also replace sound based on whichever theme you are using. (default as well)
if [ -f "${SDCARDPATH}bgm.mp3" ]; then
	cd "${theme_value}sound"	
	mv "bgm.mp3" "${theme_value}sound/bgm-bak.mp3"
	echo "Current bgm from ${theme_value} backup as bgm-bak.mp3" >> $LOGFILE

	cp "${SDCARDPATH}bgm.mp3" "${theme_value}sound/bgm.mp3"
	echo "Theme: $theme_value, BGM Swapped" >> $LOGFILE

#BGM not found
else 
	echo "BGM file not found in $SDCARDPATH. please make sure the song is titled bgm.mp3" >> $LOGFILE

fi
