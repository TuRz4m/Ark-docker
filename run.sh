#!/usr/bin/env bash
echo "###########################################################################"
echo "# Ark Server - " `date`
echo "###########################################################################"
[ -p /tmp/FIFO ] && rm /tmp/FIFO
mkfifo /tmp/FIFO

export TERM=linux

[ ! -f /ark/arkmanager.cfg ] && cp /home/steam/arkmanager.cfg /ark/arkmanager.cfg
[ ! -d /ark/log ] && mkdir /ark/log
[ ! -d /ark/backup ] && mkdir /ark/backup

#echo "Upgrade Ark server tools..."
#arkmanager upgrade-tools


if [ ! -d "/ark/server"  ] && [ ! -f "/ark/server/arkversion" ];then 
	echo "Install ark..."
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

# Auto update every $AUTOUPDATE minutes
if [ $AUTOUPDATE -gt 0 ]; then
	while :; do sleep $(($AUTOUPDATE * 60)); echo "[`date +'%y/%m/%d %H:%M'`] [Auto-Update]"; arkmanager update --warn --update-mods --backup ; done &
fi

# Auto backup every $AUTOBACKUP minutes
if [ $AUTOBACKUP -gt 0 ]; then
	while :; do sleep $(($AUTOBACKUP * 60)); echo "[`date +'%Y/%m/%d %H:%M'`] [Auto-Backup]"; arkmanager backup ; done &
fi

read < /tmp/FIFO &
wait
