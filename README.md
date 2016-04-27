# Simple-CSGO-Ranks

 <a href="https://forums.alliedmods.net/showthread.php?p=2306795">SimpleCSGORanks</a> is being coded as an alternative to paid mods such as gameme.
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

<b>Setup:</b>

Copy all the zipped files into your sourcemod server directory.
The plugin download link contains all of the sourcemod plugin files.
The plugin works with MySQL, as such you will need to have one set up.
The zip file contains a copy of databases.cfg that works with this mod.
The following MySQL database and tables <b>NEED</b> to be either created or imported:
<ul>
<li>You can either download and import it as a .sql from <a href="https://github.com/ArclightHub/Simple-CSGO-Ranks/tree/master/databases">here</a></li>
OR
<li>You can add them manually with the following SQL statements:
<br><ul>
<li>CREATE DATABASE IF NOT EXISTS steam;</li>
<li>CREATE TABLE `steam` (`steamId` char(65) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '', `rank` char(65) DEFAULT NULL, `age` char(65) DEFAULT NULL, PRIMARY KEY (`steamId`)) ENGINE=InnoDB DEFAULT CHARSET=latin1;</li>
<li>CREATE TABLE `steamname` (`steamId` char(65) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '', `name` char(255) DEFAULT NULL, PRIMARY KEY (`steamId`)) ENGINE=InnoDB DEFAULT CHARSET=latin1;</li>
</ul></li>
</ul>


It is also recommended that you increase the buffer pool if you have over 20000 players.<br>
innodb_buffer_pool_size=384M

There are two console variables:
<ul>
<li>sm_simplecsgoranks_database<ul><li>Allows changing of the database used from databases.cfg</li></ul></li>
<li>sm_simplecsgoranks_debug<ul><li>Enable or disable advanced error messages. (0 or 1)</li></ul></li>
</ul>

You may also want an updated version of the includes: "[INC] Multi Colors" from https://forums.alliedmods.net/showthread.php?t=247770
The ranking data is able to be displayed on the server MOTD.
Currently this addon is running on the "Gaming Zone Retake : 5v5 Ranked" server.
If you wish to try the addon before you download it please feel free to join the server.
IP: gamingzoneservers.com

<b>Setup for newbies:</b><br><br>
Many people have had trouble setting up MySQL and adding the databases on windows. Below you will find information for setting up MySQL:
<ul>
<li>Step 1, Install the MySQL database server: <a href="https://www.youtube.com/watch?v=AqQc3YqfelE">Watch Video 1</a></li>
<li>Step 2, Add the database and tables: <a href="https://www.youtube.com/watch?v=FAXhXI2Gxdc">Watch Video 2</a><br>
Follow the step 2 tutorial until you have used the "mysql -uroot" bit and then enter the following 4 lines of code into the command window
<ul>
<li>CREATE DATABASE IF NOT EXISTS steam;</li>
<li>USE steam;</li>
<li>CREATE TABLE `steam` (`steamId` char(65) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '', `rank` char(65) DEFAULT NULL, `age` char(65) DEFAULT NULL, PRIMARY KEY (`steamId`)) ENGINE=InnoDB DEFAULT CHARSET=latin1;</li>
<li>CREATE TABLE `steamname` (`steamId` char(65) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '', `name` char(255) DEFAULT NULL, PRIMARY KEY (`steamId`)) ENGINE=InnoDB DEFAULT CHARSET=latin1;</li>
</ul>
</li>
</ul>
Thats it. You are done. Your database is ready to go.

