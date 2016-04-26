# Simple-CSGO-Ranks

 SimpleCSGORanks is being coded as an alternative to paid mods such as gameme.
The aim of the SimpleCSGORanks project is to create a simple plugin to track players skill in a simple way.

By Default:
Everytime a player gets a kill their rank increases by 5.
When a player is killed their rank decreases by 6.
When a player assists a kill their rank increases by 2.
When a player is much lower rank than the player they killed the numbers are 10 and 11.
When a player defuses the bomb their rank increases by 5.

A player is considered recent if they have either killed a player or have themselves been killed by another player.
Their recent activity variable is updated at the end of the round and time-stamped. Team kills are not tracked.
A player can check their rank by saying !rank
A player can check the top 10/25 players by saying !top, !top10 or !top25

Setup:

Copy all the zipped files into your sourcemod server directory.
The plugin download link contains all of the sourcemod plugin files.
The plugin works with MySQL, as such you will need to have one set up.
The zip file contains a copy of databases.cfg that works with this mod.
The following MySQL database and tables need to be created:<br><br>
CREATE DATABASE IF NOT EXISTS steam;<br><br>
CREATE TABLE `steam` (`steamId` char(65) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '', `rank` char(65) DEFAULT NULL, `age` char(65) DEFAULT NULL, PRIMARY KEY (`steamId`)) ENGINE=InnoDB DEFAULT CHARSET=latin1;<br><br>
CREATE TABLE `steamname` (`steamId` char(65) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '', `name` char(255) DEFAULT NULL, PRIMARY KEY (`steamId`)) ENGINE=InnoDB DEFAULT CHARSET=latin1;


It is also recommended that you increase the buffer pool if you have over 20000 players.
innodb_buffer_pool_size=384M

There are two console variables:
sm_simplecsgoranks_database: Allows changing of the database used from databases.cfg
sm_simplecsgoranks_debug: Enable or disable advanced error messages. (0 or 1)

You may also want an updated version of the includes: "[INC] Multi Colors" from https://forums.alliedmods.net/showthread.php?t=247770
The ranking data is able to be displayed on the server MOTD.
Currently this addon is running on the "Gaming Zone Retake : 5v5 Ranked" server.
If you wish to try the addon before you download it please feel free to join the server.
IP: gamingzoneservers.com


Many people have had trouble setting up MySQL and adding the databases on windows. Below you will find information for setting up MySQL:
Step 1, Install the MySQL database server: https://www.youtube.com/watch?v=AqQc3YqfelE
Step 2, Add the database and tables: https://www.youtube.com/watch?v=FAXhXI2Gxdc
Follow the step 2 tutorial until you have used the "mysql -uroot" bit and then enter the following 4 lines of code into the command window:<br><br>
CREATE DATABASE IF NOT EXISTS steam;<br><br>
USE steam;<br><br>
CREATE TABLE `steam` (`steamId` char(65) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '', `rank` char(65) DEFAULT NULL, `age` char(65) DEFAULT NULL, PRIMARY KEY (`steamId`)) ENGINE=InnoDB DEFAULT CHARSET=latin1;<br><br>
CREATE TABLE `steamname` (`steamId` char(65) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '', `name` char(255) DEFAULT NULL, PRIMARY KEY (`steamId`)) ENGINE=InnoDB DEFAULT CHARSET=latin1;<br><br>
Thats it. You are done. Your database is ready to go.

You can also download the database files from the repo
