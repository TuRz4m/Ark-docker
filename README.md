# ARK: Survival Evolved - Docker

Docker build for managing an ARK: Survival Evolved server.

This image uses [Ark Server Tools](https://github.com/FezVrasta/ark-server-tools) to manage an ark server.

This version use the 1.4-dev branch on Ark server Tools allowing mods handling. Instead of turzam/ark, use : turzam/ark:dev-1.4

## Features
 - Easy install (no steamcmd / lib32... to install)
 - Use Ark Server Tools : update/install/start/backup/rcon
 - Auto update (on start or on timer)
 - Auto backup (on start or on timer)
 - Mods handling (via Ark Server Tools)
 - `Docker stop` is a clean stop 

## Usage
Fast & Easy server setup :   
`docker run -d -p 7778:7778 -p 7778:7778/udp -p 27015:27015 -p 27015:27015/udp -e SESSIONNAME=myserver -e ADMINPASSWORD="mypasswordadmin" --name ark turzam/ark`

You can map the ark volume to access config files :  
`docker run -d -p 7778:7778 -p 7778:7778/udp -p 27015:27015 -p 27015:27015/udp -e SESSIONNAME=myserver -v /my/path/to/ark:/ark --name ark turzam/ark`  
Then you can edit */my/path/to/ark/arkcmanager.cfg* (the values override GameUserSetting.ini) and */my/path/to/ark/server/ShooterGame/Saved/Config/LinuxServer/[GameUserSetting.ini/Game.ini]*

You can manager your server with rcon if you map the rcon port (you can rebind the rcon port with docker):  
`docker run -d -p 7778:7778 -p 7778:7778/udp -p 27015:27015 -p 27015:27015/udp -p 32330:32330  -e SESSIONNAME=myserver --name ark turzam/ark`  

You can define a server that updates itself every 2 hours (with 1 hour warning) and backups itself every hours:  
`docker run -d -p 7778:7778 -p 7778:7778/udp -p 27015:27015 -p 27015:27015/udp -e SESSIONNAME=myserver -e AUTOBACKUP=60 -e AUTOUPDATE=120 -e WARNMINUTE=60 --name ark turzam/ark` 

You can change server and steam port to allow multiple servers on same host:  
*(You can't just rebind the port with docker. It won't work, you need to change STEAMPORT & SERVERPORT variable)*
`docker run -d -p 7779:7779 -p 7779:7779/udp -p 27016:27016 -p 27016:27016/udp -p 32331:32330  -e SESSIONNAME=myserver2 -e SERVERPORT=27016 -e STEAMPORT=7779 --name ark2 turzam/ark`  

You can check your server with :  
`docker exec ark arkmanager status` 

You can manually update your server:  
`docker exec ark arkmanager update --force` 

You can force save your server :  
`docker exec ark arkmanager saveworld` 

You can backup your server :  
`docker exec ark arkmanager backup` 

You can upgrade Ark Server Tools :  
`docker exec ark arkmanager upgrade-tools` 

You can use rcon command via docker :  
`docker exec ark arkmanager rconcmd ListPlayers`  
*Full list of available command [here](http://steamcommunity.com/sharedfiles/filedetails/?id=454529617&searchtext=admin)*

__You can check all available command for arkmanager__ [here](https://github.com/FezVrasta/ark-server-tools/blob/master/README.md)

---

## Recommended Usage
- First run  
 `docker run -it -p 7778:7778 -p 7778:7778/udp -p 27015:27015 -p 27015:27015/udp -p 32330:32330 -e SESSIONNAME=myserver -e ADMINPASSWORD="mypasswordadmin" -e AUTOUPDATE=120 -e AUTOBACKUP=60 -e WARNMINUTE=30 -v /my/path/to/ark:/ark --name ark turzam/ark`  
- Wait for ark to be downloaded installed and launched, then Ctrl+C to stop the server.
- Modify */my/path/to/ark/server/ShooterGame/Saved/Config/LinuxServer/GameUserSetting.ini and Game.ini*
- `docker start ark`
- Check your server with :  
 `docker exec ark arkmanager status` 

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
+ __SERVERPORT__
Ark server port (can't rebind with docker, it doesn't work) (default : 27015)
+ __STEAMPORT__
Steam server port (can't rebind with docker, it doesn't work) (default : 7778)
+ __BACKUPONSTART__
1 : Backup the server when the container is started. 0: no backup (default : 1)
+ __UPDATEPONSTART__
1 : Update the server when the container is started. 0: no update (default : 1)
+ __AUTOUPDATE__
Number of minute between each check for une newer version (-1 disable auto update) (default : -1)
Auto update is set to --warn and warn the players 30 minutes before update (default, can be changed in /ark/arkmanager.cfg).
+ __AUTOBACKUP__
Number of minute between each backup (-1 disable auto backup) (default : -1)
+ __WARNMINUTE__
Number of minute to warn the players when auto-update (default : 30)


--- 

## Volumes
+ __/ark__ : Working directory :
    + /ark/server : Server files and data.
    + /ark/log : logs
    + /ark/backup : backups
    + /ark/arkmanager.cfg : config file

--- 

## Expose
+ Port : __STEAMPORT__ : Steam port (default: 7778)
+ Port : __SERVERPORT__ : server port (default: 27015)
+ Port : __32330__ : rcon port

---

## Known issues
