//Appname:
//SimpleCSGORanksAddons
//This app records wins and losses so that game stats can be made for the new web interface system.

#include <dbi>
#include <sourcemod> 
#include <cstrike>
#include <clientprefs>
#include <sdktools>
#include <multicolors>
#include <smlib>

#define PLUGIN_VERSION "0.0.0"

//Global Variables, do NOT touch.
char aquery[600];
bool ready = false;
Handle dbc;
char errorc[255];
int dbLocked = 0;
int bufferLocked = 0;
//buffers for the data
int round[255][2]; //players id, win, lose (Tells the server to increment the total rounds by 1 and add 1 if its a win, else dont add 1, (part of query))
//CREATE TABLE `rounds` (`steamId` char(65) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '', `rounds` int DEFAULT NULL, `wins` int DEFAULT NULL, PRIMARY KEY (`steamId`)) ENGINE=InnoDB DEFAULT CHARSET=latin1;
int roundIndex = -1; //max 254, -1 is empty
int kills[255][3]; //killer, victim, headshot
//CREATE TABLE `kills` (`steamId` char(65) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '', `kills` char(65) DEFAULT NULL, `deaths` char(65) DEFAULT NULL, `hskills` char(65) DEFAULT NULL, PRIMARY KEY (`steamId`)) ENGINE=InnoDB DEFAULT CHARSET=latin1;
int killsIndex = -1; //-1 means empty
int queryType = 0; //1 is round, kills is round
int currentOperate = -1;
//editable defines
int printToServer = 0;

//begin
public Plugin:myinfo =
{
	name = "SimpleCSGORanksAddons",
	author = "Puppetmaster",
	description = "SimpleCSGORanksAddons Addon",
	version = PLUGIN_VERSION,
	url = "https://www.gamingzoneservers.com"
};


//called at start of plugin, sets everything up.
public OnPluginStart()
{
	newDB();
	ready = dbWorks(); //check if the database is set up. This does not ever function if sourcemod does not have mysql set up
	if(!ready){
		newDB(); //create a new table in the database if its not there
		ready = dbWorks(); //check again
	}
	if(ready){
		PrintToServer("Database appears to be working");
		dbc = SQL_Connect("addons", false, errorc, sizeof(errorc)); //open the connection that will be used for the rest of the time
		HookEvent("player_death", Event_PlayerDeath, EventHookMode_Pre);
		HookEvent("round_end", Event_RoundEnd) //new round
	}
	else{
		PrintToServer("Database Failure. Please make sure your MySQL database is correctly set up. If you believe it is please check the databases.cfg file, check the permissions and check the port."); //inform the user that its broken
	}
}

public Action:Event_RoundEnd (Handle:event, const String:name[], bool:dontBroadcast){
	bufferLocked = 1;
	PrintToServer("%d", GetEventInt(event, "winner")); //2 is t win, 3 is ct win
	int winner = GetEventInt(event, "winner");
	for(int x = 1; x<64; x++)
	{
		if(IsClientConnected(x) && IsClientInGame(x))
		{
			if(GetClientTeam(x) > 1 && roundIndex < 255){
				roundIndex++;
				round[roundIndex][0] = GetSteamAccountID(x, false); //players id, win, lose
				if(GetClientTeam(x) == winner) round[roundIndex][1] = 1;
				else round[roundIndex][1] = 0;
			}
		}
	}
	bufferLocked = 0;
	return Plugin_Continue;
}

//event is called every time a player dies.
public Action:Event_PlayerDeath(Handle:event, const String:name[], bool:dontBroadcast)
{	
	if( killsIndex < 255 ){
		bufferLocked = 1;
		if(IsClientConnected(GetClientOfUserId(GetEventInt(event, "attacker"))) && IsClientConnected(GetClientOfUserId(GetEventInt(event, "userid"))) && GetClientOfUserId(GetEventInt(event, "attacker")) > 0 && GetClientOfUserId(GetEventInt(event, "userid")))
		{
			killsIndex++;
			kills[killsIndex][0] = GetClientOfUserId(GetEventInt(event, "attacker"));
			kills[killsIndex][1] = GetClientOfUserId(GetEventInt(event, "userid"));
			if(GetEventInt(event, "headshot")) kills[killsIndex][2] = 1;
			else kills[killsIndex][2] = 0;
		}
		bufferLocked = 0;
	}
	else PrintToServer("Error kill buffer is full");
	return Plugin_Continue;
}

public OnMapStart ()
{
	//add some event which calls the update
	if(ready) CreateTimer(0.2, Timer_Update, _, TIMER_REPEAT); //update every 6 seconds if the db works
}

public bool dbWorks()
{
	//should return 1
	int isWorking = 0;
	new String:error2[255]
	new Handle:db = SQL_Connect("addons", false, error2, sizeof(error2));//SQL_DefConnect(error2, sizeof(error2))
	if (db == INVALID_HANDLE)
	{
		if(printToServer == 1) PrintToServer("Could not connect: %s", error2)
	}
	else
	{
		new Handle:query = SQL_Query(db, "SELECT count(*) FROM information_schema.tables WHERE table_name = 'steam'")
		if (query == INVALID_HANDLE)
		{
			new String:error[255]
			SQL_GetError(db, error, sizeof(error))
			if(printToServer == 1) PrintToServer("Failed to query (error: %s)", error)
		} else {

			new String:name[65]
			while (SQL_FetchRow(query))
			{
				SQL_FetchString(query, 0, name, sizeof(name))
				if(printToServer == 1) PrintToServer("Steamid \"%s\" was found.", name)
				isWorking = StringToInt(name);
			}
		}
		CloseHandle(query)
		
	}
	CloseHandle(db)
	if(isWorking > 0) return true;
	else return false;	
}

public void newDB()
{
	//new String:error2[255]
	new String:error[255]
	new Handle:db = SQL_Connect("addons", false, error, sizeof(error));//SQL_DefConnect(error2, sizeof(error2))
	PrintToServer("Adding database tables");
	if (!SQL_FastQuery(db, "CREATE TABLE `rounds` (`steamId` char(65) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '', `rounds` char(65) DEFAULT NULL, `wins` char(65) DEFAULT NULL, PRIMARY KEY (`steamId`)) ENGINE=InnoDB DEFAULT CHARSET=latin1;"))
	{
		SQL_GetError(db, error, sizeof(error))
		if(printToServer == 1) PrintToServer("Failed to query (error: %s)", error)
	}
	CloseHandle(db)
	
	db = SQL_Connect("addons", false, error, sizeof(error));//SQL_DefConnect(error2, sizeof(error2))
	PrintToServer("Adding database tables");
	if (!SQL_FastQuery(db, "CREATE TABLE `kills` (`steamId` char(65) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '', `kills` char(65) DEFAULT NULL, `deaths` char(65) DEFAULT NULL, `hskills` char(65) DEFAULT NULL, PRIMARY KEY (`steamId`)) ENGINE=InnoDB DEFAULT CHARSET=latin1;"))
	{
		SQL_GetError(db, error, sizeof(error))
		if(printToServer == 1) PrintToServer("Failed to query (error: %s)", error)
	}
	CloseHandle(db)
	return;
}


//queries

public queryCallback(Handle:owner, Handle:HQuery, const String:error[], any:client)
{
	CloseHandle(HQuery); //make sure the handle is closed before we allow anything to happen
	//query complete, decrement
	if(queryType == 1) roundIndex--;
	else if(queryType == 2) killsIndex--;
	dbLocked = 0; //unlock db after everything is done
}

public Action:Timer_Update(Handle:timer)
{
	if(dbLocked > 0 || bufferLocked > 0) {
		return; //something should still be processing, data is locked until its next loop.
	}
	if(killsIndex > 0 || roundIndex > 0)
	{
		CreateTimer(0.05, Timer_executeQueries);
	}
	return;
} 

public Action:Timer_executeQueries(Handle:timer)
{
	if(dbLocked > 0) {
		//PrintToServer("%s", "Thread is locked.");
		return;
	}
	if(dbc == INVALID_HANDLE)
	{
		PrintToServer("%s", "Complete Database Failure. Reconnecting.");
		dbc = SQL_Connect("addons", false, errorc, sizeof(errorc));
		return;
	}
	else{
		if(roundIndex > 0) { 
			queryType = 1; 
			currentOperate = roundIndex; 
			PrintToServer("Updating player:%d", round[currentOperate][0]);
			Format(aquery, sizeof(aquery), "INSERT INTO rounds VALUES(%d, 1, %d, '') ON DUPLICATE KEY UPDATE rounds = rounds + 1, wins = wins + %d", round[currentOperate][0], round[currentOperate][1], round[currentOperate][1]);
			//INSERT INTO steamname (steamId,name) VALUES ('%d','\%s\') ON DUPLICATE KEY UPDATE name='\%s\'
			dbLocked = 1;
			SQL_TQuery(dbc, queryCallback, aquery, 1);
		}
		else if(killsIndex > 0) { 
			PrintToServer("Adding kills");
			queryType = 2; 
			currentOperate = killsIndex; 
			//kills[255][3]; //killer, victim, headshot
			//decl String:steamId[64];
			//decl String:steamId2[64];
			//GetClientAuthId(kills[currentOperate][0], AuthId_Steam2, steamId, sizeof(steamId));
			//GetClientAuthId(kills[currentOperate][1], AuthId_Steam2, steamId2, sizeof(steamId2));
			//Format(aquery, sizeof(aquery), "REPLACE INTO kills SET steamId = %d, rounds = rounds + 1, wins = wins + %d", round[currentOperate][0], round[currentOperate][1]);
			if(IsClientConnected(kills[currentOperate][0]) && IsClientConnected(kills[currentOperate][1])){
				Format(aquery, sizeof(aquery), "INSERT INTO kills (steamId,kills,deaths,hskills) VALUES(%d, 1, 0, %d), (%d, 0, 1, 0) ON DUPLICATE KEY UPDATE kills=VALUES(kills)+kills, deaths=VALUES(deaths)+deaths, hskills=VALUES(hskills)+hskills", GetSteamAccountID(kills[currentOperate][0], false), kills[currentOperate][2], GetSteamAccountID(kills[currentOperate][1], false));
				dbLocked = 1;
				SQL_TQuery(dbc, queryCallback, aquery, 1);
			}
			else killsIndex--;
		}

	}
	return;
}



