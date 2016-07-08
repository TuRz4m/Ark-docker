# ARK: Survival Evolved - Docker

Docker build for managing an ARK: Survival Evolved server.

This image uses [Ark Server Tools](https://github.com/FezVrasta/ark-server-tools) to manage an ark server.

*If you use an old volume, get the new arkmanager.cfg in the template directory.*  
__Don't forget to use `docker pull turzam/ark` to get the latest version of the image__


## Features
 - Easy install (no steamcmd / lib32... to install)
 - Use Ark Server Tools : update/install/start/backup/rcon/mods
 - Easy crontab configuration
 - Easy access to ark config file
 - Mods handling (via Ark Server Tools)
 - `Docker stop` is a clean stop 

## Usage
Fast & Easy server setup :   
`docker run -d -p 7778:7778 -p 7778:7778/udp -p 27015:27015 -p 27015:27015/udp -e SESSIONNAME=myserver -e ADMINPASSWORD="mypasswordadmin" --name ark turzam/ark`

You can map the ark volume to access config files :  
`docker run -d -p 7778:7778 -p 7778:7778/udp -p 27015:27015 -p 27015:27015/udp -e SESSIONNAME=myserver -v /my/path/to/ark:/ark --name ark turzam/ark`  
Then you can edit */my/path/to/ark/arkmanager.cfg* (the values override GameUserSetting.ini) and */my/path/to/ark/[GameUserSetting.ini/Game.ini]*

You can manager your server with rcon if you map the rcon port (you can rebind the rcon port with docker):  
`docker run -d -p 7778:7778 -p 7778:7778/udp -p 27015:27015 -p 27015:27015/udp -p 32330:32330  -e SESSIONNAME=myserver --name ark turzam/ark`  

You can change server and steam port to allow multiple servers on same host:  
*(You can't just rebind the port with docker. It won't work, you need to change STEAMPORT & SERVERPORT variable)*
`docker run -d -p 7779:7779 -p 7779:7779/udp -p 27016:27016 -p 27016:27016/udp -p 32331:32330  -e SESSIONNAME=myserver2 -e SERVERPORT=27016 -e STEAMPORT=7779 --name ark2 turzam/ark`  

You can check your server with :  
`docker exec ark arkmanager status` 

You can manually update your mods:  
`docker exec ark arkmanager update --update-mods` 

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

You can easily configure automatic update and backup.  
If you edit the file `/my/path/to/ark/crontab` you can add your crontab job.  
For example :  
`# Update the server every hours`  
`0 * * * * arkmanager update --warn --update-mods >> /ark/log/crontab.log 2>&1`    
`# Backup the server each day at 00:00  `  
`0 0 * * * arkmanager backup >> /ark/log/crontab.log 2>&1`  
*You can check [this website](http://www.unix.com/man-page/linux/5/crontab/) for more information on cron.*

To add mods, you only need to change the variable ark_GameModIds in *arkmanager.cfg* with a list of your modIds (like this  `ark_GameModIds="987654321,1234568"`). If UPDATEONSTART is enable, just restart your docker or use `docker exec ark arkmanager update --update-mods`.

---

## Recommended Usage
- First run  
 `docker run -it -p 7778:7778 -p 7778:7778/udp -p 27015:27015 -p 27015:27015/udp -p 32330:32330 -e SESSIONNAME=myserver -e ADMINPASSWORD="mypasswordadmin" -e AUTOUPDATE=120 -e AUTOBACKUP=60 -e WARNMINUTE=30 -v /my/path/to/ark:/ark --name ark turzam/ark`  
- Wait for ark to be downloaded installed and launched, then Ctrl+C to stop the server.
- Edit */my/path/to/ark/GameUserSetting.ini and Game.ini*
- Edit */my/path/to/ark/arkserver.cfg* to add mods and configure warning time.
- Add auto update every day and autobackup by editing */my/path/to/ark/crontab* with this lines :  
`0 0 * * * arkmanager update --warn --update-mods >> /ark/log/crontab.log 2>&1`  
`0 0 * * * arkmanager backup >> /ark/log/crontab.log 2>&1`  
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
+ __BACKUPONSTOP__
1 : Backup the server when the container is stopped. 0: no backup (default : 0)
+ __WARNONSTOP__
1 : Warn the players before the container is stopped. 0: no warning (default : 0)  
+ __TZ__
Time Zone : Set the container timezone (for crontab). (You can get your timezone posix format with the command `tzselect`. For example, France is "Europe/Paris").
+ __UID__
UID of the user used. Owner of the volume /ark
+ __GID__
GID of the user used. Owner of the volume /ark


--- 

## Volumes
+ __/ark__ : Working directory :
    + /ark/server : Server files and data.
    + /ark/log : logs
    + /ark/backup : backups
    + /ark/arkmanager.cfg : config file for Ark Server Tools
    + /ark/crontab : crontab config file
    + /ark/Game.ini : ark game.ini config file
    + /ark/GameUserSetting.ini : ark gameusersetting.ini config file
    + /ark/template : Default config files
    + /ark/template/arkmanager.cfg : default config file for Ark Server Tools
    + /ark/template/crontab : default config file for crontab
    + /ark/staging : default directory if you use the --downloadonly option when updating.

--- 

## Expose
+ Port : __STEAMPORT__ : Steam port (default: 7778)
+ Port : __SERVERPORT__ : server port (default: 27015)
+ Port : __32330__ : rcon port

---

## Known issues

---

## Changelog
+ 1.0 : 
  - Initial image : works with Ark Server tools 1.3
  - Add auto-update & auto-backup  
+ 1.1 :  
  - Works with Ark Server Tools 1.4 [See changelog here](https://github.com/FezVrasta/ark-server-tools/releases/tag/v1.4)
  - Handle mods && auto update mods
+ 1.2 :
  - Remove variable AUTOBACKUP & AUTOUPDATE 
  - Remove variable WARNMINUTE (can now be find in arkmanager.cfg)
  - Add crontab support
  - You can now config crontab with the file /your/ark/path/crontab
  - Add template directory with default config files.
  - Add documentation on TZ variable.
+ 1.3 :
  - Add BACKUPONSTOP to backup the server when you stop the server (thanks to [fkoester](https://github.com/fkoester))
  - Add WARNONSTOP to add warning message when you stop the server (default: 60 min)
  - Works with Ark Server Tools v1.5
    - Compressing backups so they take up less space
    - Downloading updates to a staging directory before applying
    - Added support for automatically updating on restart
    - Show a spinner when updating
  - Add UID & GID to set the uid & gid of the user used in the container (and permissions on the volume /ark)

