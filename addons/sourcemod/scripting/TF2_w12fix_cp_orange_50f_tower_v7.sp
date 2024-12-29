#pragma newdecls required
#include <sourcemod>
#include <sdktools>
#include <sdkhooks>
#include <tf2>
#include <tf2_stocks>

public Plugin myinfo = 
{
	name = "cp_orange_50f_tower_v7 Map glitch fixed",
	author = "w1200441",
	description = "cp_orange_50f_tower_v7 glitch fixed",
	version = "0.0.1",
	url = "https://steamcommunity.com/id/w1200441/"
};
public void OnPluginStart()
{
	RegAdminCmd("sm_w12rebuild", Command_ReBuild, ADMFLAG_SLAY, "Rebuild Emtites");
}
public Action Command_ReBuild(int client, int args)
{
	IsCorrectMap() ? Rebuild() : ReplyToCommand(client, "Command enable for map [ cp_orange_50f_tower_v7 ] only.");
	
	return Plugin_Handled;
}
public void OnEntityCreated(int entity, const char[] classname)
{
	if(!IsCorrectMap())
		return;
	if (StrEqual(classname, "logic_auto"))
		HookSingleEntityOutput(entity, "OnMapSpawn", OnLogicAutoMapSpawn);
}
public void OnLogicAutoMapSpawn(const char[] output, int caller, int activator, float delay)
{
	Rebuild();
}
public void Rebuild()
{
	CreateTimer(0.0, RemoveAll);
	CreateTimer(1.0, BuildEntity);
	CreateTimer(2.0, HookMapEntry);
	PrintToServer("[cp_orange_50f_tower_v7] cp_orange_50f_tower_v7 loaded.");
}
public Action RemoveAll(Handle timer)
{
	if(!IsCorrectMap())
		return Plugin_Stop;
	int entity = CreateEntityByName("logic_timer");
	if(IsValidEntity(entity))
	{
		DispatchKeyValue(entity, "targetname", "EntFireTimer");
		DispatchKeyValue(entity, "StartDisabled", "0");
		DispatchKeyValue(entity, "RefireTime", "0.1");
		DispatchKeyValue(entity, "spawnflags", "0");
		DispatchSpawn(entity);
		ActivateEntity(entity);
		SetVariantString("OnTimer MapEntity:Kill::0.0:-1");
		AcceptEntityInput(entity, "AddOutput");
		SetVariantString("OnTimer !self:Disable::0.5:-1");
		AcceptEntityInput(entity, "AddOutput");
		SetVariantString("OnTimer !self:Kill::1.0:-1");
		AcceptEntityInput(entity, "AddOutput");
	}
	return Plugin_Stop;
}
public Action BuildEntity(Handle timer)
{
	if(!IsCorrectMap())
		return Plugin_Stop;
	int prop;
	prop = CreateEntityByName("trigger_add_tf_player_condition"); //blue spawn out
	if (IsValidEntity(prop))
	{
		DispatchKeyValue(prop, "targetname", "MapEntity");
		DispatchKeyValue(prop, "model", "*16");
		DispatchKeyValue(prop, "origin", "0 -300 0");
		DispatchKeyValue(prop, "angles", "0 0 0");
		DispatchKeyValue(prop, "filtername", "filter_blu");
		DispatchKeyValue(prop, "spawnflags", "1");
		DispatchKeyValue(prop, "condition", "51"); //TFCond_UberchargedHidden
		DispatchKeyValue(prop, "duration", "-1");
		DispatchSpawn(prop);
		ActivateEntity(prop);
		SetVariantString("OnEndTouch !activator:RunScriptCode:self.RemoveCond(51):0.0:-1");
		AcceptEntityInput(prop, "AddOutput");
	}
	prop = CreateEntityByName("func_nobuild"); //blue spawn
	if (IsValidEntity(prop))
	{
		DispatchKeyValue(prop, "targetname", "MapEntity");
		DispatchKeyValue(prop, "model", "*16");
		DispatchKeyValue(prop, "origin", "0 -300 0");
		DispatchKeyValue(prop, "angles", "0 0 0");
		DispatchKeyValue(prop, "AllowSentry", "1");
		DispatchKeyValue(prop, "AllowDispenser", "1");
		DispatchKeyValue(prop, "AllowTeleporters", "0");
		DispatchKeyValue(prop, "TeamNum", "3");
		DispatchSpawn(prop);
		ActivateEntity(prop);
	}
	prop = CreateEntityByName("trigger_multiple"); //blue spawn end
	if(IsValidEntity(prop))
	{
		DispatchKeyValue(prop, "targetname", "MapEntity");
		DispatchKeyValue(prop, "model", "*16");
		DispatchKeyValue(prop, "origin", "0 900 0");
		DispatchKeyValue(prop, "angles", "0 0 0");
		DispatchKeyValue(prop, "StartDisabled", "0");
		DispatchKeyValue(prop, "filtername", "filter_blu");
		DispatchKeyValue(prop, "spawnflags", "1");
		DispatchSpawn(prop);
		ActivateEntity(prop);
		HookSingleEntityOutput(prop, "OnStartTouch", OnStartTouchSpawnRoomTrigger);
	}
	prop = CreateEntityByName("func_forcefield"); //blue roof
	if (IsValidEntity(prop))
	{
		DispatchKeyValue(prop, "targetname", "MapEntity");
		DispatchKeyValue(prop, "model", "*16");
		DispatchKeyValue(prop, "origin", "0 -500 550");
		DispatchKeyValue(prop, "angles", "0 0 0");
		DispatchKeyValue(prop, "spawnflags", "2");
		DispatchKeyValue(prop, "TeamNum", "1");
		DispatchSpawn(prop);
		ActivateEntity(prop);
		SetEntityRenderMode(prop, RENDER_TRANSCOLOR);
		SetEntityRenderColor(prop, 255, 255, 255, 0);
	}
	prop = CreateEntityByName("trigger_add_tf_player_condition"); //red spawn out
	if (IsValidEntity(prop))
	{
		DispatchKeyValue(prop, "targetname", "MapEntity");
		DispatchKeyValue(prop, "model", "*13");
		DispatchKeyValue(prop, "origin", "0 300 0");
		DispatchKeyValue(prop, "angles", "0 0 0");
		DispatchKeyValue(prop, "filtername", "filter_red");
		DispatchKeyValue(prop, "spawnflags", "1");
		DispatchKeyValue(prop, "condition", "51"); //TFCond_UberchargedHidden
		DispatchKeyValue(prop, "duration", "-1");
		DispatchSpawn(prop);
		ActivateEntity(prop);
		SetVariantString("OnEndTouch !activator:RunScriptCode:self.RemoveCond(51):0.0:-1");
		AcceptEntityInput(prop, "AddOutput");
	}
	prop = CreateEntityByName("trigger_multiple"); //red spawn end
	if(IsValidEntity(prop))
	{
		DispatchKeyValue(prop, "targetname", "MapEntity");
		DispatchKeyValue(prop, "model", "*13");
		DispatchKeyValue(prop, "origin", "0 -900 0");
		DispatchKeyValue(prop, "angles", "0 0 0");
		DispatchKeyValue(prop, "StartDisabled", "0");
		DispatchKeyValue(prop, "filtername", "filter_red");
		DispatchKeyValue(prop, "spawnflags", "1");
		DispatchSpawn(prop);
		ActivateEntity(prop);
		HookSingleEntityOutput(prop, "OnStartTouch", OnStartTouchSpawnRoomTrigger);
	}
	prop = CreateEntityByName("func_forcefield"); //red roof
	if (IsValidEntity(prop))
	{
		DispatchKeyValue(prop, "targetname", "MapEntity");
		DispatchKeyValue(prop, "model", "*13");
		DispatchKeyValue(prop, "origin", "0 500 550");
		DispatchKeyValue(prop, "angles", "0 0 0");
		DispatchKeyValue(prop, "spawnflags", "2");
		DispatchKeyValue(prop, "TeamNum", "1");
		DispatchSpawn(prop);
		ActivateEntity(prop);
		SetEntityRenderMode(prop, RENDER_TRANSCOLOR);
		SetEntityRenderColor(prop, 255, 255, 255, 0);
	}
	prop = CreateEntityByName("func_nobuild"); //red spawn
	if (IsValidEntity(prop))
	{
		DispatchKeyValue(prop, "targetname", "MapEntity");
		DispatchKeyValue(prop, "model", "*13");
		DispatchKeyValue(prop, "origin", "0 300 0");
		DispatchKeyValue(prop, "angles", "0 0 0");
		DispatchKeyValue(prop, "AllowSentry", "1");
		DispatchKeyValue(prop, "AllowDispenser", "1");
		DispatchKeyValue(prop, "AllowTeleporters", "0");
		DispatchKeyValue(prop, "TeamNum", "2");
		DispatchSpawn(prop);
		ActivateEntity(prop);
	}
	return Plugin_Stop;
}
public void OnStartTouchSpawnRoomTrigger(const char[] output, int caller, int activator, float delay)
{
	if(!IsValidClient(activator))
		return;
	if(!IsAdmin(activator))
		TF2_RespawnPlayer(activator);
}
public Action HookMapEntry(Handle timer)
{
	int entity = -1;
	while ((entity = FindEntityByClassname(entity, "game_text")) != -1)
	{
		DispatchKeyValue(entity, "message", "[blw.tf] cp_orange_50f_tower by w1200441");
		SetVariantString("[blw.tf] cp_orange_50f_tower by w1200441");
		AcceptEntityInput(entity, "SetText");
	}
	return Plugin_Stop;
}
stock bool IsCorrectMap()
{
	char map[32];
	GetCurrentMap(map, sizeof(map));
	return StrEqual(map, "cp_orange_50f_tower_v7");
}
bool IsValidClient(int client) 
{
    if (client <= 0) return false;
    if (client > MaxClients) return false;
    return IsClientInGame(client);
}
bool IsAdmin(int iClient) 
{
	if (!IsValidClient(iClient)) return false;
	if (IsFakeClient(iClient)) return false;
	return CheckCommandAccess(iClient, "is_a_sm_admin", ADMFLAG_GENERIC, true);
}