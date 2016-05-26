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

There are five basic console variables:
<ul>
<li>sm_simplecsgoranks_mode<ul><li>Sets the mode. (0) is rounds mode. (1) is immediate mode. Immediate mode is useful for deathmatch type games.</li></ul></li>
<li>sm_simplecsgoranks_ffa<ul><li>Enables free for all mode.</li></ul></li>
<li>sm_simplecsgoranks_kill_points<ul><li>The number of points gained per kill</li></ul></li>
<li>sm_simplecsgoranks_higher_rank_additional<ul><li>Additional points gained when killing a higher ranked player.</li></ul></li>
<li>sm_simplecsgoranks_higher_rank_gap<ul><li>Difference between players ranks needed to consider one to be a higher ranked player.</li></ul></li>
</ul>

Additionally there are five advanced console variables:
<ul>
<li>sm_simplecsgoranks_database<ul><li>Allows changing of the database used from databases.cfg</li></ul></li>
<li>sm_simplecsgoranks_cleaning<ul><li>(0)Nothing. (1) Cleans the database. (2) Clears players who have no kills for more than two months.</li></ul></li>
<li>sm_simplecsgoranks_useSlowCache<ul><li>Limit the rate at which the cache updates its data.</li></ul></li>
<li>sm_simplecsgoranks_useMaxThreads<ul><li>Allows more threads than usual. Might be useful for servers with a large number of players.</li></ul></li>
<li>sm_simplecsgoranks_debug<ul><li>Enable or disable advanced error messages. (0 or 1)</li></ul></li>
</ul>

<b>MySQL setup on Windows:</b><br><br>
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

