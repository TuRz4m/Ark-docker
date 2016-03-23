#!/usr/bin/env bash
echo "###########################################################################"
echo "# Ark Server - " `date`
echo "###########################################################################"
[ -p /tmp/FIFO ] && rm /tmp/FIFO
mkfifo /tmp/FIFO

export TERM=linux

function stop {
	arkmanager stop
	if [ ${BACKUPONSTOP} -eq 1 ]; then
                echo "[Backup]"
                arkmanager backup
        fi
}

if [ ! -w /ark ]; then 
	echo "[Error] Can't access ark directory. Check permissions on your mapped directory with /ark"
	exit 1
fi

# Change working directory to /ark to allow relative path
cd /ark

# Add a template directory to store the last version of config file
[ ! -d /ark/template ] && mkdir /ark/template
# We overwrite the template file each time
cp /home/steam/arkmanager.cfg /ark/template/arkmanager.cfg
cp /home/steam/crontab /ark/template/crontab
# Creating directory tree && symbolic link
[ ! -f /ark/arkmanager.cfg ] && cp /home/steam/arkmanager.cfg /ark/arkmanager.cfg
[ ! -d /ark/log ] && mkdir /ark/log
[ ! -d /ark/backup ] && mkdir /ark/backup
[ ! -f /ark/Game.ini ] && ln -s server/ShooterGame/Saved/Config/LinuxServer/Game.ini Game.ini
[ ! -f /ark/GameUserSettings.ini ] && ln -s server/ShooterGame/Saved/Config/LinuxServer/GameUserSettings.ini GameUserSettings.ini



if [ ! -d "/ark/server"  ] || [ ! -f "/ark/server/arkversion" ];then 
	arkmanager install
	# Create mod dir
	mkdir /ark/server/ShooterGame/Content/Mods
	# Download mods
	arkmanager update --update-mods
else

	if [ ${BACKUPONSTART} -eq 1 ]; then 
		echo "[Backup]"
		arkmanager backup
	fi

	if [ ${UPDATEONSTART} -eq 1 ]; then 
		echo "[Update]"
		arkmanager update --update-mods
	fi
fi

# If there is uncommented line in the file
CRONNUMBER=`grep -v "^#" /ark/crontab | wc -l`
if [ $CRONNUMBER -gt 0 ]; then
	echo "Loading crontab..."
	# We load the crontab file if it exist.
	crontab /ark/crontab
	# Cron is attached to this process
	sudo cron -f &
else
	echo "No crontab set."
fi

# Launching ark server
arkmanager start


# Stop server in case of signal INT or TERM
echo "Waiting..."
trap stop INT
trap stop TERM

read < /tmp/FIFO &
wait
