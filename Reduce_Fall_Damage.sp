#include <sdkhooks>

#pragma semicolon 1
#pragma newdecls required

#define NAME		"Reduce Fall Damage"
#define AUTHOR		"Master"
#define VERSION		"1.0"
#define URL			"https://cswild.pl/"

public Plugin myinfo =
{ 
	name	= NAME,
	author	= AUTHOR,
	version	= VERSION,
	url		= URL
};

float g_fPercentages;

public void OnPluginStart()
{
	ConVar cvar = CreateConVar("sm_reduce_fall_damage", "0.50", "Ile procent obrażeń ma zadać", 0); cvar.AddChangeHook(OnCvarChange);
	g_fPercentages = cvar.FloatValue;

	AutoExecConfig(true, "Reduce_Fall_Damage");
}

public void OnCvarChange(ConVar cvar, char[] oldValue, char[] newValue)
{
	g_fPercentages = StringToFloat(newValue);
}

public void OnClientPutInServer(int client)
{
	SDKHook(client, SDKHook_OnTakeDamage, OnTakeDamage);
}

public Action OnTakeDamage(int victim, int &attacker, int &inflictor, float &damage, int &damagetype) 
{
	if(!IsValidClient(attacker))
		return Plugin_Continue;

	if(damagetype & DMG_FALL)
	{
		damage *= g_fPercentages; 
		return Plugin_Changed;
	}

	return Plugin_Continue;
}

bool IsValidClient(int client)
{
	return (1 <= client <= MaxClients && IsClientInGame(client));
}