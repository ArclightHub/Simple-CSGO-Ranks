//Appname:
//SimpleCSGORanksCommunity

#include <dbi>
#include <sourcemod> 
#include <cstrike>
#include <clientprefs>
#include <sdktools>
#include <multicolors>
#include <smlib>

#define PLUGIN_VERSION "0.0.0"

/*
CREATE TABLE `steamcommunity` (`steamId` char(65) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '',
`Steam2` char(65) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '', 
`Steam3` char(65) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '', 
`SteamID64` char(65) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '',
`age` char(65) DEFAULT NULL, PRIMARY KEY (`steamId`)) ENGINE=InnoDB DEFAULT CHARSET=latin1
*/

//Global Variables, do NOT touch.
Handle dbc;
int dbLocked = 0;
char errorc[255];
new String:databaseName[128] = "default";	

//begin
public Plugin:myinfo =
{
	name = "SimpleCSGORanksCommunity",
	author = "Puppetmaster",
	description = "SimpleCSGORanksCommunity Addon",
	version = PLUGIN_VERSION,
	url = "https://www.gamingzoneservers.com"
};

public int getSteamIdNumber(int client)
{
	decl String:steamId[64]; //defused the bomb
	GetClientAuthId(client, AuthId_Steam3, steamId, sizeof(steamId));
	ReplaceString(steamId, sizeof(steamId), "[U:1:", "", false);
	ReplaceString(steamId, sizeof(steamId), "[U:0:", "", false);
	ReplaceString(steamId, sizeof(steamId), "]", "", false);

	return StringToInt(steamId);
}

public OnClientPostAdminCheck(client){
	CreateTimer(0.1, Timer_Community, client);
	return;
}

public queryCallback(Handle:owner, Handle:HQuery, const String:error[], any:client)
{
	CloseHandle(HQuery); //make sure the handle is closed before we allow anything to happen
	dbLocked = 0; //unlock db after everything is done
}

public Action:Timer_Community(Handle:timer, any client)
{
	if(dbLocked == 1) return Plugin_Continue;

	decl String:steamId2[64];
	GetClientAuthId(client, AuthId_Steam2, steamId2, sizeof(steamId2));

	decl String:steamId3[64];
	GetClientAuthId(client, AuthId_Steam3, steamId3, sizeof(steamId3));

	decl String:communityId[64];
	GetClientAuthId(client, AuthId_SteamID64, communityId, sizeof(communityId));

	new String:stime[65];
	IntToString(GetTime(),stime,sizeof(stime));

	new String:query[256];
	Format(query, sizeof(query), "REPLACE INTO steamcommunity (steamId, Steam2, Steam3, SteamID64, age) VALUES(%s,%s,%s,%s,%s)", getSteamIdNumber(client), steamId2, steamId3, communityId, stime);

	if(dbc == INVALID_HANDLE){ 
		dbc = SQL_Connect(databaseName, false, errorc, sizeof(errorc));
		SQL_GetError(dbc, errorc, sizeof(errorc));
		PrintToServer("Failed to query (error: %s)", errorc);
	}
	dbLocked = 1; //Lock our own DB
	SQL_TQuery(dbc, queryCallback, query, client);

	return Plugin_Continue;
}




public OnPluginStart()
{
	dbc = SQL_Connect(databaseName, false, errorc, sizeof(errorc));
}

