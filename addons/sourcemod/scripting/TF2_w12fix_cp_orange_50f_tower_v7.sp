#pragma newdecls required
#include <sourcemod>
#include <sdktools>
#include <sdkhooks>
#include <tf2>
#include <tf2_stocks>
bool g_bRebuild = false;
public Plugin myinfo = 
{
	name = "cp_orange_50f_tower_v7 Map glitch fixed",
	author = "w1200441",
	description = "cp_orange_50f_tower_v7 glitch fixed",
	version = "0.0.2",
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
	if(g_bRebuild)
		return;
	g_bRebuild = true;
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
		SetVariantString("OnEndTouch !activator:RunScriptCode:self.RemoveCond(57):3.0:-1"); //TFCond_UberchargedOnTakeDamage
		AcceptEntityInput(prop, "AddOutput");
		HookSingleEntityOutput(prop, "OnStartTouch", OnStartTouchSpawnRoomTrigger);
	}
	prop = CreateEntityByName("trigger_add_tf_player_condition"); //blue roof
	if (IsValidEntity(prop))
	{
		DispatchKeyValue(prop, "targetname", "MapEntity");
		DispatchKeyValue(prop, "model", "*40");
		DispatchKeyValue(prop, "origin", "-2684 -1569 -8861");
		DispatchKeyValue(prop, "angles", "0 90 0");
		DispatchKeyValue(prop, "spawnflags", "1");
		DispatchKeyValue(prop, "condition", "107"); //TFCond_SwimmingNoEffects
		DispatchKeyValue(prop, "duration", "0.5");
		DispatchSpawn(prop);
		ActivateEntity(prop);
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
		SetVariantString("OnEndTouch !activator:RunScriptCode:self.RemoveCond(57):3.0:-1"); //TFCond_UberchargedOnTakeDamage
		AcceptEntityInput(prop, "AddOutput");
		HookSingleEntityOutput(prop, "OnStartTouch", OnStartTouchSpawnRoomTrigger);
	}
	prop = CreateEntityByName("trigger_add_tf_player_condition"); //red roof
	if (IsValidEntity(prop))
	{
		DispatchKeyValue(prop, "targetname", "MapEntity");
		DispatchKeyValue(prop, "model", "*39");
		DispatchKeyValue(prop, "origin", "1774 1570 -8862");
		DispatchKeyValue(prop, "angles", "0 90 0");
		DispatchKeyValue(prop, "spawnflags", "1");
		DispatchKeyValue(prop, "condition", "107"); //TFCond_SwimmingNoEffects
		DispatchKeyValue(prop, "duration", "0.5");
		DispatchSpawn(prop);
		ActivateEntity(prop);
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
	else
		TF2_AddCondition(activator, TFCond_UberchargedOnTakeDamage, TFCondDuration_Infinite);
}
public Action HookMapEntry(Handle timer)
{
	int entity = -1;
	while ((entity = FindEntityByClassname(entity, "game_text")) != -1)
	{
		DispatchKeyValue(entity, "channel", "3");
		DispatchKeyValue(entity, "message", "[blw.tf] cp_orange_50f_tower fixed by w1200441");
		SetVariantString("[blw.tf] cp_orange_50f_tower fixed by w1200441");
		AcceptEntityInput(entity, "SetText");
	}
	while ((entity = FindEntityByClassname(entity, "trigger_multiple")) != -1)
	{
		char modelname[128];
		GetEntPropString(entity, Prop_Data, "m_ModelName", modelname, sizeof(modelname));
		if(StrEqual(modelname, "*39") || StrEqual(modelname, "*40"))
			HookSingleEntityOutput(entity, "OnStartTouch", OnStartTouchGameTextTrigger);
	}
	return Plugin_Stop;
}
public void OnStartTouchGameTextTrigger(const char[] output, int caller, int activator, float delay)
{
	if(!IsValidClient(activator))
		return;
	if(!IsAdmin(activator))
		return;
	int iButton = GetClientButtons(activator);
	if (iButton & IN_RELOAD)
		Menu_AdminPanel(activator);
}

public void Menu_AdminPanel(int client)
{
	Menu menu = new Menu(MenuFunc_AdminMenuFunction);
	menu.SetTitle("[blw.tf] cp_orange_50f_tower");
	menu.ExitButton = true;
	menu.ExitBackButton = true;
	menu.AddItem("0", "Teleport to top of tower");
	menu.AddItem("1", "Teleport to Red roof");
	menu.AddItem("2", "Teleport to Blue roof");
	menu.Display(client, MENU_TIME_FOREVER);	
}
public int MenuFunc_AdminMenuFunction(Menu menu, MenuAction action, int param1, int param2)
{
	if (action == MenuAction_End)
	{
		delete menu;
	}
	else if (action == MenuAction_Select)
	{
		switch(param2)
		{
			case 0: TeleportEntity(param1, {-444.0, 0.0, 8905.0}, NULL_VECTOR, NULL_VECTOR);
			case 1: TeleportEntity(param1, {2095.0, 663.0, -8900.0}, NULL_VECTOR, NULL_VECTOR);
			case 2: TeleportEntity(param1, {-2991.0, -663.0, -8900.0}, NULL_VECTOR, NULL_VECTOR);
		}
	}
	return 0;
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