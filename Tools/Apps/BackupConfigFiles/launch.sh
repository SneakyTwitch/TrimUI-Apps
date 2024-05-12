#!/bin/sh

CURRENT_DATE=$(date "+%d%m%Y_%H%M" | xargs)
LOG_FILE="/mnt/SDCARD/Logs/BackupAndRestore.log"
echo 1 > /tmp/stay_awake
sleep 1

BACKUPDIRECTORY=$(dirname "$0")
BACKUPFOLDER="${BACKUPDIRECTORY}/${CURRENT_DATE}"

# For Restoration
echo "${CURRENT_DATE}" > ${BACKUPDIRECTORY}/ForRestoring.txt

SDCARDPATH="/mnt/SDCARD/"
RAFolder="RetroArch"
NDSFolder="Emus/NDS/drastic/config"
PSPFolder=".config/ppsspp/PSP/SYSTEM"
echo "" >> $LOG_FILE

# For Backup	
if [ ! -d "$BACKUPFOLDER" ]; then
	echo "Starting Backup $CURRENT_DATE" >> $LOG_FILE
	mkdir -p "$BACKUPFOLDER/$RAFolder/.retroarch/config" "$BACKUPFOLDER/$PSPFolder" "$BACKUPFOLDER/$NDSFolder"

	# Backup RA files
	cp "$SDCARDPATH$RAFolder/retroarch.cfg" "$BACKUPFOLDER/$RAFolder/" && \
	cp "$SDCARDPATH$RAFolder/ra64.trimui" "$BACKUPFOLDER/$RAFolder/" && \
	cp "$SDCARDPATH$RAFolder/ra32.trimui" "$BACKUPFOLDER/$RAFolder/" && \
	cp -a "$SDCARDPATH$RAFolder/.retroarch/config/"* "$BACKUPFOLDER/$RAFolder/.retroarch/config/"
	if [ $? -eq 0 ]; then
		echo "Backup of RetroArch files completed successfully" >> $LOG_FILE
	else
		echo "Error occurred during RetroArch backup" >> $LOG_FILE
	fi
	
	# Backup PSP config
	cp -a "$SDCARDPATH$PSPFolder/"* "$BACKUPFOLDER/$PSPFolder/"
	if [ $? -eq 0 ]; then
		echo "Backup of PSP config completed successfully" >> $LOG_FILE
	else
		echo "Error occurred during PSP config backup" >> $LOG_FILE
	fi

	# Backup NDS config
	cp -a "$SDCARDPATH$NDSFolder/"* "$BACKUPFOLDER/$NDSFolder/"
	if [ $? -eq 0 ]; then
		echo "Backup of NDS config completed successfully" >> $LOG_FILE
	else
		echo "Error occurred during NDS config backup" >> $LOG_FILE
	fi
else
	echo "Backup directory already exists for $CURRENT_DATE. Backup skipped." >> $LOG_FILE
fi


# Create TAR file
BACKUP_TARFILE="$BACKUPDIRECTORY/backup_${CURRENT_DATE}.tar.gz"


if tar -czf "$BACKUP_TARFILE" "$BACKUPFOLDER"; then
    echo "Backup: ${BACKUPFOLDER}.tar.gz created successfully." >> $LOG_FILE
    rm -r "$BACKUPFOLDER"
    echo "Cleaned up Backup folder" >> $LOG_FILE
else
    echo "Failed to create ZIP file." >> $LOG_FILE
fi

rm /tmp/stay_awake

exit 0
