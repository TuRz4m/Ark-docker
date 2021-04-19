#!/bin/bash
echo "###########################################################################"
echo "# Ark Server - " `date`
echo "# UID ${UID} - GID ${GID}"
echo "###########################################################################"
[ -p /tmp/FIFO ] && rm /tmp/FIFO
mkfifo /tmp/FIFO

export TERM=linux

function stop {
	if [ ${BACKUPONSTOP} -eq 1 ] && [ "$(ls -A server/ShooterGame/Saved/SavedArks)" ]; then
		echo "[Backup on stop]"
		arkmanager backup
	fi
	if [ ${WARNONSTOP} -eq 1 ];then 
	    arkmanager stop --warn
	else
	    arkmanager stop
	fi
	exit
}

## Creating directory tree if not available
[ ! -d /ark/log ] && mkdir /ark/log 
[ ! -d /ark/backup ] && mkdir /ark/backup
[ ! -d /ark/staging ] && mkdir /ark/staging

# Copy global config file to /ark
[ ! -f /ark/arkmanager.cfg ] && cp /home/steam/arkmanager.cfg /ark/arkmanager.cfg
# Copy instance config file to /ark
[ ! -f /ark/main.cfg ] && cp /home/steam/main.cfg /ark/main.cfg
# Copy crontab file
[ ! -f /ark/crontab ] && cp /home/steam/crontab /ark/crontab


if [ ! -d /ark/server ] || [ ! -f /ark/server/version.txt ];then 
	echo "No game files found. Installing..."
	arkmanager install --verbose
else
	if [ ${BACKUPONSTART} -eq 1 ] && [ "$(ls -A server/ShooterGame/Saved/SavedArks/)" ]; then 
		echo "[Backup]"
		arkmanager backup
	fi
fi

## Create symbolic links to ark config
[ ! -L /ark/Game.ini ] && ln -s server/ShooterGame/Saved/Config/LinuxServer/Game.ini Game.ini
[ ! -L /ark/GameUserSettings.ini ] && ln -s server/ShooterGame/Saved/Config/LinuxServer/GameUserSettings.ini GameUserSettings.ini

# If there is uncommented line in the file
CRONNUMBER=`grep -v "^#" /ark/crontab | wc -l`
if [ ${CRONNUMBER} -gt 0 ]; then
	echo "Loading crontab..."
	# We load the crontab file if it exist.
	crontab /ark/crontab
	# Cron is attached to this process
	sudo cron -f &
else
	echo "No crontab set."
fi

# Launching ark server
if [ ${UPDATEONSTART} -eq 0 ]; then
	arkmanager start -noautoupdate
else
	arkmanager start
fi


# Stop server in case of signal INT or TERM
echo "Waiting..."
trap stop INT
trap stop TERM

read < /tmp/FIFO &
wait
