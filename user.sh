#!/bin/sh

# Change the UID if needed
if [ ! "$(id -u steam)" -eq "$UID" ]; then 
	echo "Changing steam uid to $UID."
	usermod -o -u "$UID" steam ; 
fi
# Change gid if needed
if [ ! "$(id -g steam)" -eq "$GID" ]; then 
	echo "Changing steam gid to $GID."
	groupmod -o -g "$GID" steam ; 
fi

# Put steam owner of directories (if the uid changed, then it's needed)
chown -R steam:steam /ark /home/steam

# avoid error message when su -p (we need to read the /root/.bash_rc )
chmod -R 777 /root/

# Launch run.sh with user steam (-p allow to keep env variables)
su -p - steam -c /home/steam/run.sh
