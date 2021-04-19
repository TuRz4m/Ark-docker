# ARK: Survival Evolved - Docker

Docker build for managing an ARK: Survival Evolved server.

The base image used is [cm2network/steamcmd](https://hub.docker.com/r/cm2network/steamcmd/), the recommended way for apps using steamcmd running in docker environments.

This image uses [Ark Server Tools](https://github.com/arkmanager/ark-server-tools) to manage the ark server.

It is based on the work done here: [https://github.com/TuRz4m/Ark-docker](https://github.com/TuRz4m/Ark-docker) but as this is not getting updated anymore I decided to do it myself.

---

As this is a new project and I could not test everything yet, some of the features mentioned may not work as expected!

---

## Features
 - Use Ark Server Tools : update/install/start/backup/rcon/mods
 - Easy crontab configuration (_not tested yet_)
 - Easy access to ark config files
 - Mods handling (via Ark Server Tools)
 - `Docker stop` is a clean stop 

## Usage
Fast & Easy minimal server setup :   
`docker run -d -p 7777:7777/udp -p 7778:7778/udp -p 27015:27015/udp  wollsi/arkdocker`

You can map the ark volume to access config files and persist your data:
`-v /my/path/to/ark:/ark`  

You can manage your server with rcon if you map the rcon port:  
`-p 27020:27020`  

You can change server and steam query port to allow multiple servers on same host:  
*(You can't just rebind the port with docker. It won't work, you need to change GAMEPORT & QUERYPORT variable)*
`-e QUERYPORT=27016 -e GAMEPORT=7779`

You can check your server with :  
`docker exec <container_name> arkmanager status` 

You can manually update your mods:  
`docker exec <container_name> arkmanager update --update-mods` 

You can manually update your server:  
`docker exec <container_name> arkmanager update --force` 

You can force save your server :  
`docker exec <container_name> arkmanager saveworld` 

You can backup your server :  
`docker exec <container_name> arkmanager backup` 

You can upgrade Ark Server Tools :  
`docker exec <container_name> arkmanager upgrade-tools` 

You can use rcon command via docker :  
`docker exec <container_name> arkmanager rconcmd ListPlayers`  
*Full list of available command [here](http://steamcommunity.com/sharedfiles/filedetails/?id=454529617&searchtext=admin)*

__You can check all available command for arkmanager__ [here](https://github.com/arkmanager/ark-server-tools#usage)

### cron
__I did not check if this part still works__

You can easily configure automatic update and backup.  
If you edit the file `/my/path/to/ark/crontab` you can add your crontab job.  
For example :

`# Update the server every hours`  
`0 * * * * arkmanager update --warn --update-mods >> /ark/log/crontab.log 2>&1`   

`# Backup the server each day at 00:00  `  
`0 0 * * * arkmanager backup >> /ark/log/crontab.log 2>&1`  
*You can check [this website](http://www.unix.com/man-page/linux/5/crontab/) for more information on cron.*

### Mods

To add mods, you only need to change the variable ark_GameModIds in *arkmanager.cfg* with a list of your modIds (like this  `ark_GameModIds="987654321,1234568"`). If UPDATEONSTART is enable, just restart your docker or use `docker exec ark arkmanager update --update-mods`.

---

## Recommended Usage
- First run  
 `docker run -d -p 7777:7777/udp -p 7778:7778/udp -p 27015:27015/udp -p 27020:27020 -e SESSIONNAME=YourARKServerName --name container_name wollsi/arkdocker`

- Wait for server to be downloaded
- Use `arkmanager stop` to stop the ark server
- Edit */my/path/to/ark/GameUserSetting.ini and Game.ini*
- Edit */my/path/to/ark/arkmanager.cfg* to add mods and configure warning time.
- Edit */my/path/to/ark/main.cfg* to add mods and configure warning time.
- Add auto update every day and autobackup by editing */my/path/to/ark/crontab* with this lines :  
`0 0 * * * arkmanager update --warn --update-mods >> /ark/log/crontab.log 2>&1`  
`0 0 * * * arkmanager backup >> /ark/log/crontab.log 2>&1`  
- Use `arkmanager start` to start the ark server
- Check your server with : `docker exec ark arkmanager status` 

--- 

## Variables
+ __SESSIONNAME__
Name of your ark server (default : "Ark Docker")
+ __SERVERMAP__
Map of your ark server (default : "TheIsland")
+ __SERVERPASSWORD__
Password of your ark server (default : "")
+ __ADMINPASSWORD__
Admin password of your ark server (default : "adminpassword")
+ __QUERYPORT__
Ark server port (can't rebind with docker, it doesn't work) (default : 27015)
+ __GAMEPORT__
Steam server port (can't rebind with docker, it doesn't work) (default : 7778)
+ __RCONPORT__
Rcon port
+ __BACKUPONSTART__
1 : Backup the server when the container is started. 0: no backup (default : 1)
+ __UPDATEPONSTART__
1 : Update the server when the container is started. 0: no update (default : 1)  
+ __BACKUPONSTOP__
1 : Backup the server when the container is stopped. 0: no backup (default : 0)
+ __WARNONSTOP__
1 : Warn the players before the container is stopped. 0: no warning (default : 0)  
+ __TZ__
Time Zone : Set the container timezone (for crontab). (You can get your timezone posix format with the command `tzselect`. For example, France is "Europe/Paris").
+ __UID__
UID of the user used. Owner of the volume /ark
+ __GID__
GID of the user used. Group of the volume /ark

--- 

## Volumes
+ __/ark__ : Working directory
    + /ark/Game.ini                 : Ark game.ini config file
    + /ark/GameUserSetting.ini      : Ark gameusersetting.ini config file
    + /ark/arkmanager.cfg           : Arkmanager global config file
    + /ark/main.cfg                 : Arkmanager Instance config file for main instance
    + /ark/crontab                  : crontab config file

    + /ark/server                   : Server files and data
    + /ark/log                      : logs directory
    + /ark/backup                   : backup directory
    + /ark/staging                  : default directory if you use the --downloadonly option when updating. 

+ __/home/steam/steamcmd__ : Installation directory of steamcmd

--- 

## Expose
+ Port : __GAMEPORT__   : Game port (default: 7777)
+ Port : __QUERYPORT__  : Steam query port (default: 27015)
+ Port : __RCONPORT__   : Rcon port (default: 27020)

---

## Known issues

## FAQ

### Why is there only one port (GAMEPORT) I can change? Don't I need two?

Yes indeed you need 2 (actually 3 if you count the Steam query port and 4 if you want to use rcon). The second port is always __GAMEPORT + 1__. So make sure that port is available on your host as well! (See: [Dedicated_Server_Setup#Network](https://ark.fandom.com/wiki/Dedicated_Server_Setup#Network) for more information)

### I get an ''Connection Timeout'' Error when trying to join the server.

+ The ports may not be set correctly in the container. Check used ports using the following:
  + Use `docker exec -it <container_name> bash` to open bash into your container.
  + Call `apt update && apt install net-tools` to install netstat.
  + Call `netstat -antup` to see if the ports are correct.
  
  You should see something like:
  ```
  Active Internet connections (servers and established)
  Proto Recv-Q Send-Q Local Address           Foreign Address         State       PID/Program name
  udp        0      0 127.0.0.1:27015         0.0.0.0.*                           -
  udp        0      0 127.0.0.1:7777          0.0.0.0.*                           -
  udp        0      0 127.0.0.1:7778          0.0.0.0.*                           -
  tcp        0      0 127.0.0.1:27020         0.0.0.0.*               LISTEN      -
  ```
  
+ Check if the ports exposed and forwarded in the container match with the ports used by the ark server.


