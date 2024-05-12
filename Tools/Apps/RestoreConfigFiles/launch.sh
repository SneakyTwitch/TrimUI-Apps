#!/bin/sh

RESTOREDIRECTORY=$(dirname "$0")
LOG_FILE="/mnt/SDCARD/Logs/BackupAndRestore.log"
echo 1 > /tmp/stay_awake

SDCARDPATH="/mnt/SDCARD/"
echo "" >> $LOG_FILE

BACKUPDIRECTORY="/mnt/SDCARD/Apps/BackupConfigFiles"

# Get which restore TAR file to use
RESTORE_VERSION=$(cat $BACKUPDIRECTORY/ForRestoring.txt)
RESTORE_FILE="$BACKUPDIRECTORY/backup_${RESTORE_VERSION}.tar.gz"
echo "Starting Restore for version: $RESTORE_VERSION" >> $LOG_FILE

if [[ -f "${RESTORE_FILE}" ]]; then

	EXTRACT_LOG="$RESTOREDIRECTORY/${RESTORE_VERSION}_EXTRACT.log"
	
	tar -xzvf "${RESTORE_FILE}" --strip-components=2 -C "${SDCARDPATH}" >> $EXTRACT_LOG 2>&1
	
	echo "Config file restored for : ${RESTORE_FILE}" >> $LOG_FILE
	echo "Check full extract log: ${EXTRACT_LOG}" >> $LOG_FILE
	
else
	echo "Restore failed. Backup file ${RESTORE_FILE} not found. Please run Backup Config Files first" >> $LOG_FILE
fi

rm /tmp/stay_awake
exit 0
