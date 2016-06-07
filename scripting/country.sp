//Appname:
//SimpleCSGORanksCountry

#include <dbi>
#include <sourcemod>
#include <geoip>

#define PLUGIN_VERSION "0.0.0"

/*
CREATE TABLE `steamcountry` (`steamId` char(65) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '',
`country` char(45) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '', 
`age` char(65) DEFAULT NULL, PRIMARY KEY (`steamId`)) ENGINE=InnoDB DEFAULT CHARSET=latin1
*/

//Global Variables, do NOT touch.
Handle dbc;
char errorc[255];
new String:databaseName[128] = "default";	

//begin
public Plugin:myinfo =
{
	name = "SimpleCSGORanksCountry",
	author = "Puppetmaster",
	description = "SimpleCSGORanksCountry Addon",
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

	if(!IsFakeClient(client)) CreateTimer(0.1, Timer_Country, client);
	return;
}

public queryCallback(Handle:owner, Handle:HQuery, const String:error[], any:client)
{
	CloseHandle(HQuery);
}

public Action:Timer_Country(Handle:timer, any client)
{
	if( !IsClientConnected(client) || !IsClientAuthorized(client) || IsFakeClient(client) ) return Plugin_Continue;

	decl String:steamId[64];
	IntToString(getSteamIdNumber(client),steamId,sizeof(steamId));
	
	decl String:IP[16];
	IP[0] = '\0';
	GetClientIP(client, IP, sizeof(IP));

	decl String:countryname[45];
	countryname[0] = '\0';
	GeoipCountry(IP, countryname, sizeof(countryname));

	new String:stime[65];
	IntToString(GetTime(),stime,sizeof(stime));

	new String:query[256];
	Format(query, sizeof(query), "REPLACE INTO steamcountry (steamId, country, age) VALUES(\"%s\",\"%s\",\"%s\")", steamId, countryname, stime);
	

	if(dbc == INVALID_HANDLE){ 
		dbc = SQL_Connect(databaseName, false, errorc, sizeof(errorc));
		SQL_GetError(dbc, errorc, sizeof(errorc));
		PrintToServer("Failed to query (error: %s)", errorc);
	}
	SQL_TQuery(dbc, queryCallback, query, client);

	return Plugin_Continue;
}




public OnPluginStart()
{
	dbc = SQL_Connect(databaseName, false, errorc, sizeof(errorc));
}
