# Ark Survived Evolved - Docker

Docker build for managing an Ark Survived Evolved server.

This image uses [Ark Server Tools] (https://github.com/FezVrasta/ark-server-tools) to manage an ark server.

## Usage
Fast & Easy server setup :   
`docker run -d -p 7778:7778 -p 27016:27016  -e SESSIONNAME=myserver -e ADMINPASSWORD="mypasswordadmin" --name ark turzam/ark`

You can map the ark volume to access config files :  
`docker run -d -p 7778:7778 -p 27016:27016  -e SESSIONNAME=myserver -v /my/path/to/ark:/ark --name ark turzam/ark`  
Then you can edit */my/path/to/ark/arkcmanager.cfg* (the values override GameUserSetting.ini) and */my/path/to/ark/server/ShooterGame/Saved/Config/LinuxServer/GameUserSetting.ini.*

You can manager your server with rcon if you map the rcon port :  
`docker run -d -p 7778:7778 -p 27016:27016 -p 32330:32330  -e SESSIONNAME=myserver --name ark turzam/ark`  

You can define a server that updates itself every 2 hours and backups itself every hours:  
`docker run -d -p 7778:7778 -p 27016:27016  -e SESSIONNAME=myserver -e AUTOBACKUP=60 -e AUTOUPDATE=120 --name ark turzam/ark` 

You can check your server with :  
`docker exec ark arkmanager status` 

You can manually update your server:  
`docker exec ark arkmanager update` 

You can force save your server :  
`docker exec ark arkmanager saveworld` 

You can use rcon command via docker :  
`docker exec ark arkmanager rconcmd ListPlayers`  
*Full list of available command [here](http://steamcommunity.com/sharedfiles/filedetails/?id=454529617&searchtext=admin)*

__You can check all available command for arkmanager__ [here](https://github.com/FezVrasta/ark-server-tools/blob/master/README.md)

---

## Recommended Usage
- First run  
 `docker run -it -p 7778:7778 -p 27016:27016 -p 32330:32330 -e SESSIONNAME=myserver -e ADMINPASSWORD="mypasswordadmin" -e AUTOUPDATE=120 -e AUTOBACKUP=60 -v /my/path/to/ark:/ark --name ark turzam/ark`  
- Wait for ark to be downloaded installed and launched, then Ctrl+C to stop the server.
- Modify */my/path/to/ark/server/ShooterGame/Saved/Config/LinuxServer/GameUserSetting.ini.*
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
+ __BACKUPONSTART__
1 : Backup the server when the container is started. 0: no backup (default : 1)
+ __UPDATEPONSTART__
1 : Update the server when the container is started. 0: no update (default : 1)
+ __AUTOUPDATE__
Number of minute between each check for une newer version (-1 disable auto update) (default : -1)
Auto update is set to --warn and warn the players 30 minutes before update (default, can be changed in /ark/arkmanager.cfg).
+ __AUTOBACKUP__
Number of minute between each backup (-1 disable auto backup) (default : -1)

--- 

## Volumes
+ __/ark__ : Working directory :
    + /ark/server : Server files and data.
    + /ark/log : logs
    + /ark/backup : backups
    + /ark/arkmanager.cfg : config file

--- 

## Expose
+ Port : __7778__ : Steam port
+ Port : __27016__ : server port
+ Port : __32330__ : rcon port

---

## Known issues
