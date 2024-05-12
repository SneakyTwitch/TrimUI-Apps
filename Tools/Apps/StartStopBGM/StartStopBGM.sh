#!/bin/sh

LOGFILE=/mnt/SDCARD/Logs/BGM.log
SCRIPTNAME=$(basename "$0")
echo "$(date): Running $SCRIPTNAME" >> $LOGFILE

THEMEPATH=/mnt/UDISK/system.json

#Grab current running theme
#Theme value is -> mnt/SDCARD/Themes/xxx/
theme_value=$(grep '"theme"' $THEMEPATH | cut -d ':' -f 2 | tr -d '",}' | sed 's:/*$::')/
theme_value=$(echo "$theme_value" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
echo "Current Theme: $theme_value" >> $LOGFILE


#If theme is Default, Theme value is -> ../res/ 
#Default sound is from /usr/trimui/res/sound/
if echo "$theme_value" | grep -q "/res/"; then
	echo "Using Default Theme" >> $LOGFILE
	theme_value="/usr/trimui/res/"
fi

#Turn OFF BGM if its on
if [ -f "${theme_value}sound/bgm.mp3" ]; then
	cd "${theme_value}sound"
	mv "bgm.mp3" "./bgm-off.mp3"
	echo "Theme: $theme_value, BGM is turned OFF" >> $LOGFILE

#Turn ON BGM if its off
elif [ -f "${theme_value}sound/bgm-off.mp3" ]; then
	cd "${theme_value}sound"
	mv "bgm-off.mp3" "./bgm.mp3"
	echo "Theme: $theme_value, BGM is turned ON" >> $LOGFILE

#BGM not found
else 
	echo "Current Theme:$theme_value, BGM file not found. please make sure the song is titled bgm.mp3" >> $LOGFILE

fi                                          
