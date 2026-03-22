// -------------------------------------------------- //
// ---------------Unusual Photo Script--------------- //
// -----------------Brought to you By---------------- //
// -                                                - //
// - The FatCat    - Main Programmer 				- //
// - Shadowbolt    - Where the Idea came from 		- //
// - PopExtensions - the CreateWearable function 	- //
// -                                                - //
// -------------------------------------------------- //
// -------------------------------------------------- //


// /unusual command parameters
// /unusual 			// this will throw an error
// /unusual [1]			// this is either the unusual particle id for hats, or particle internal name for taunts
// /unusual [ ] [2]		// this is what team to set the bot to, options or red or blue and defaults to blue



// this script will run at most 3 commands to the server console
// bot_kick all									// kicks all bots
// bot -team #### -class pyro -name Pyro 		// Adds a pyro bot name "Pyro" on whatever team you wanted

if(Convars.GetStr("sv_allow_point_servercommand") != "always")
{
	if(Convars.IsConVarOnAllowList("sv_allow_point_servercommand"))
	{
		Convars.SetValue("sv_allow_point_servercommand", "always")
		ClientPrint(null, 3, "\x03Set convar \"sv_allow_point_servercommand\" to \"always\"")
	}
	else 
	{
		ClientPrint(null, 3, "\x07ff0000This Script need to send commands to the server console!\nPlease set sv_allow_point_servercommand to \"always\".")
		return
	}
}


::ROOT <- getroottable()

if (!("ConstantNamingConvention" in ROOT)) // make sure folding is only done once
{
	foreach (enum_table in Constants)
	{
		foreach (name, value in enum_table)
		{
			if (value == null)
				value = 0

			CONST[name] <- value
			ROOT[name] <- value
		}
	}
}

if (!("FoldedNetProps" in ROOT)) // make sure folding is only done once
{
	ROOT["FoldedNetProps"] <- "Folds all NetProps to Not require 'NetProps.'"
	foreach (name, method in ::NetProps.getclass())
	{
		// Every 'class' has this
		if (name != "IsValid")
		{
			ROOT[name] <- method.bindenv(::NetProps)
		}
	}
}

function ROOT::EnableStringPurge(entity)
{
	if( !entity )
		return entity
	SetPropBool(entity, "m_bForcePurgeFixedupStrings", true)
	return entity
}

function ROOT::CreateByClassname(classname)
	return EnableStringPurge(Entities.CreateByClassname(classname))

const TF_STUN_LOSER_NO_EFFECTS = 96

const BRIGADE_HELM_IDX = 105
const TAUNT_RPS = 1110
const BASE_JUMPER_IDX = 1101

const SF_TRIGGER_ALLOW_CLIENTS = 0x1
const PATTACH_ABSORIGIN_FOLLOW = 1

function ROOT::CTFPlayer::ForceTaunt(taunt_id, particle = null, particle_duration = -1)
{
	local weapon = CreateByClassname("tf_weapon_bat")
	local active_weapon = GetActiveWeapon()
	StopTaunt(true) // both are needed to fully clear the taunt
	RemoveCond(TF_COND_TAUNTING)
	weapon.DispatchSpawn()
	SetPropInt(weapon, "m_AttributeManager.m_Item.m_iItemDefinitionIndex", taunt_id)
	SetPropBool(weapon, "m_AttributeManager.m_Item.m_bInitialized", true)
	EnableStringPurge(weapon)
	SetPropEntity(this, "m_hActiveWeapon", weapon)
	SetPropInt(this, "m_iFOV", 0) // fix sniper rifles
	HandleTauntCommand(0)
	SetPropEntity(this, "m_hActiveWeapon", active_weapon)
	weapon.Kill()

	if(particle)
		CreateParticle(particle, particle_duration, true)
}

function ROOT::CTFPlayer::CreateParticle(particle, duration = -1, used_for_taunt = false)
{
	local trigger = CreateByClassname("trigger_particle")
	trigger.KeyValueFromString("particle_name", particle)
	trigger.KeyValueFromInt("spawnflags", SF_TRIGGER_ALLOW_CLIENTS)
	trigger.KeyValueFromInt("attachment_type", PATTACH_ABSORIGIN_FOLLOW)

	EnableStringPurge(trigger)

	trigger.AcceptInput("StartTouch", "", null, this)
	trigger.Destroy()

	if(duration > 0)
	{
		EntFireByHandle(this, "DispatchEffect", "ParticleEffectStop", duration, null, null)
	}
	if(used_for_taunt)
	{
		ValidateScriptScope()
		local scope = GetScriptScope()
		scope.RemoveTauntParticle <- function() {
			if(!self.InCond(TF_COND_TAUNTING))
			{
				EntFireByHandle(self, "DispatchEffect", "ParticleEffectStop", -1, null, null)
				SetPropString(self, "m_iszScriptThinkFunction", "")
				return 500
			}
			return 0.1
		}
		AddThinkToEnt(this, "RemoveTauntParticle")
	}
}

function ROOT::CTFPlayer::CreateWearable( idx, model, attributes = {} )
{
	local dummy = CreateByClassname("tf_weapon_parachute")
	SetPropInt(dummy, "m_AttributeManager.m_Item.m_iItemDefinitionIndex", BASE_JUMPER_IDX)
	SetPropBool(dummy, "m_AttributeManager.m_Item.m_bInitialized", true)
	dummy.SetTeam(GetTeam())
	dummy.DispatchSpawn()
	dummy.SetModelSimple("")
	Weapon_Equip(dummy)

	EnableStringPurge(dummy)

	local wearable = GetPropEntity( dummy, "m_hExtraWearable" )
	dummy.Kill()

	wearable.SetTeam(GetTeam())
	SetPropInt(wearable, "m_AttributeManager.m_Item.m_iItemDefinitionIndex", idx)
	SetPropBool(wearable, "m_AttributeManager.m_Item.m_bInitialized", true)
	SetPropBool(wearable, "m_bValidatedAttachedEntity", true)

	foreach (attribute, value in attributes)
	{
		wearable.AddAttribute(attribute, value, -1)
	}

	wearable.DispatchSpawn()

	EnableStringPurge(wearable)

	if (model) wearable.SetModelSimple(model)

	wearable.SetTeam(GetTeam())

	SendGlobalGameEvent( "post_inventory_application", {userid = GetUserID()})
	wearable.SetOwner(this)

	return wearable
}

::Next_bot_unusual <- {
	hat = false
	taunt = false
}

::Unusual <- {
	function OnGameEvent_player_say(params)
	{
		local player = GetPlayerFromUserID(params.userid)
		local text = split(params.text, " ")

		if(text.len() < 2)
			return

		if(player.IsFakeClient())
			return

		if(text[0].slice(1) != "unusual")
			return

		if(text[1].find("_") == null)
				::Next_bot_unusual <- {hat = text[1].tointeger(), taunt = false}
		else 	::Next_bot_unusual <- {taunt = text[1], hat = false}

		SendToServerConsole("bot_kick all")
		SendToServerConsole(format("bot -team %s -class pyro -name Pyro", text.len() < 3 ? "red" : text[2]))
	}
	function OnGameEvent_player_spawn(params)
	{
		local player = GetPlayerFromUserID(params.userid)
		if(!player.IsFakeClient())
			return

		if(GetPropString(player, "m_szNetname") != "Pyro")
			return

		player.CreateWearable(BRIGADE_HELM_IDX, "models/player/items/pyro/fireman_helmet.mdl", Next_bot_unusual.hat ? {"attach particle effect" : Next_bot_unusual.hat} : {})
		if((Next_bot_unusual.hat == false || Next_bot_unusual.hat.tointeger() < 3000) && !Next_bot_unusual.taunt)
		{
			EntFireByHandle(player, "RunScriptCode", "self.StunPlayer(10000, 1, TF_STUN_LOSER_NO_EFFECTS+256, self)", 0.1, null, null)
		}
		//TODO: make them spawn at spot
		// player.SetAbsOrigin(Vector())
		// player.SetAbsAngles(QAngle())
		if(Next_bot_unusual.taunt || Next_bot_unusual.hat.tointeger() > 3000)
		{
			EntFireByHandle(player, "RunScriptCode", "self.ForceTaunt(TAUNT_RPS, Next_bot_unusual.hat.tointeger() >= 3000 ? null : Next_bot_unusual.taunt.tostring())", 0.1, null, null)
		}
	}
}
__CollectGameEventCallbacks(Unusual)