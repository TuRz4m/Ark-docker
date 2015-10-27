#!/usr/bin/env bash
echo "###########################################################################"
echo "# Ark Server - " `date`
echo "###########################################################################"
[ -p /tmp/FIFO ] && rm /tmp/FIFO
mkfifo /tmp/FIFO

export TERM=linux

# Creating directory tree && symbolic link
[ ! -f /ark/arkmanager.cfg ] && cp /home/steam/arkmanager.cfg /ark/arkmanager.cfg
[ ! -d /ark/log ] && mkdir /ark/log
[ ! -d /ark/backup ] && mkdir /ark/backup
[ ! -f /ark/Game.ini ] && ln -s /ark/server/ShooterGame/Saved/Config/Game.ini /ark/Game.ini
[ ! -f /ark/GameUserSetting.ini ] && ln -s /ark/server/ShooterGame/Saved/Config/GameUserSetting.ini /ark/GameUserSetting.ini



if [ ! -d "/ark/server"  ] || [ ! -f "/ark/server/arkversion" ];then 
	arkmanager install
	# Create mod dir
	mkdir /ark/server/ShooterGame/Content/Mods
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

# We load the crontab file if it exist.
if [ -f /ark/crontab ]; then
	crontab /ark/crontab
else
	cat <<EOT >> /ark/crontab
# Minute   Hour   Day of Month       Month          Day of Week        Command
# (0-59)  (0-23)     (1-31)    (1-12 or Jan-Dec)  (0-6 or Sun-Sat)
# Example : update every hour
# 0 * * * * arkmanager update
# Example : backup every 15min
# */15 * * * * arkmanager backup
# Example : backup every day at midnight
# 0 0 * * * arkmanager backup
	EOT
fi

# Launching ark server
arkmanager start


# Stop server in case of signal INT or TERM
echo "Waiting..."
trap 'arkmanager stop' INT
trap 'arkmanager stop' TERM

read < /tmp/FIFO &
wait
