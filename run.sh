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

# Launching ark server
arkmanager start


# Stop server in case of signal INT or TERM
echo "Waiting..."
trap 'arkmanager stop' INT
trap 'arkmanager stop' TERM

read < /tmp/FIFO &
wait
