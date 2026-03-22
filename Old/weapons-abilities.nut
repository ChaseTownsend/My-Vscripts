IncludeScript("fatcat_library")

// Allows changing this without editing and reloading script
// I.e. "script ::Debug_Abilities <- #"
::Debug_Abilities <- false

// Base
// - - - - - - - - - Base - - - - - - - - - |
const TF_ABILITY_BASE = -1               // |
local BASE_spawn_cooldown = 60           // |
local BASE_attack_cooldown = 15          // |
// - - - - - - - - - - - - - - - - - - - - -|
// Scout
// Soldier
// Pyro
// Demoman
// Heavy
// - - - - - - - - - Rage - - - - - - - - - |
const TF_ABILITY_HEAVY_RAGE = 43         // |
local RAGE_spawn_cooldown = 180          // |
local RAGE_attack_cooldown = 105         // |
local RAGE_bomb_range = 75               // |
local RAGE_explode_damage = 750000       // |
local RAGE_explode_radius = 500          // |
local RAGE_explode_damage_small = 40000  // |
local RAGE_explode_radius_small = 250    // |
// - - - - - - - - - - - - - - - - - - - - -|
// Engineer
// Medic
// Sniper
// Spy
// Multi-Class
// - - - - - - - -  CHEERS  - - - - - - - - |
const TF_ABILITY_CHEERS = 1013           // |
local CHEERS_spawn_cooldown = 20         // |
local CHEERS_attack_cooldown = 75        // |
local CHEERS_health_mult = 10.00         // |
// - - - - - - - - - - - - - - - - - - - - -|
// - - - - - - - -   KART   - - - - - - - - |
const TF_ABILITY_KART = 1123             // |
local KART_spawn_cooldown = 30           // |
local KART_attack_cooldown = 75          // |
// - - - - - - - - - - - - - - - - - - - - -|

///////////////////////
//  Precache Sounds  //
///////////////////////

PrecacheSound("items/cart_explode.wav")
PrecacheSound("weapons/airstrike_small_explosion_02.wav")

local Ability_Thinker = FindByName(null, "_AbilityThink")
if(Ability_Thinker == null) Ability_Thinker = SpawnEntityFromTable("info_target", { targetname = "_AbilityThink" })
AddThinkToEnt(Ability_Thinker, "AbilityThink")

function AbilityThink()
{
	foreach (player in GetEveryHuman())
	{
		local scope = player.GetScriptScope()

		if("Ability" in scope)
		{
			if(scope.Ability != null) continue

			switch (player.GetAbilityWeaponIDX())
			{
				case TF_ABILITY_BASE:
				{
					AddThinkToEnt(player, "BaseAbility")

					scope.Ability_timestamp <- Time() + BASE_spawn_cooldown
					scope.Ability = "Base"
					break
				}
				case TF_ABILITY_HEAVY_RAGE:
				{
					AddThinkToEnt(player, "HeavyRage")

					scope.Ability_timestamp <- Time() + RAGE_spawn_cooldown
					scope.Ability = "Rage"
					break
				}
				case TF_ABILITY_CHEERS:
				{
					AddThinkToEnt(player, "CheersAbility")

					scope.Ability_timestamp <- Time() + CHEERS_spawn_cooldown
					scope.Ability = "Cheers"
					break
				}
				case TF_ABILITY_KART:
				{
					AddThinkToEnt(player, "KartAbility")

					scope.Ability_timestamp <- Time() + KART_spawn_cooldown
					scope.Ability = "Kart"
					break
				}
			}
		}
		else
		{
			switch (player.GetAbilityWeaponIDX())
			{
				case TF_ABILITY_BASE:
				{
					AddThinkToEnt(player, "BaseAbility")

					scope.Ability_timestamp <- Time() + BASE_spawn_cooldown
					scope.Ability <- "Base"
					break
				}
				case TF_ABILITY_HEAVY_RAGE:
				{
					AddThinkToEnt(player, "HeavyRage")

					scope.Ability_timestamp <- Time() + RAGE_spawn_cooldown
					scope.Ability <- "Rage"
					break
				}
				case TF_ABILITY_CHEERS:
				{
					AddThinkToEnt(player, "CheersAbility")

					scope.Ability_timestamp <- Time() + CHEERS_spawn_cooldown
					scope.Ability <- "Cheers"
					break
				}
				case TF_ABILITY_KART:
				{
					AddThinkToEnt(player, "KartAbility")

					scope.Ability_timestamp <- Time() + KART_spawn_cooldown
					scope.Ability <- "Kart"
					break
				}
			}
		}
	}
	return 0.1
}

::ability <- {
	function OnGameEvent_player_spawn(params)
	{
		//////////////////////////////////
		//  Reset Ability Key In Scope  //
		//////////////////////////////////

		local player = GetPlayerFromUserID(params.userid)
		if (!ValidatePlayer(player)) return

		local scope = GetScope(player)
		scope.Ability <- null

		switch (player.GetAbilityWeaponIDX())
		{
			case TF_ABILITY_BASE:
			{
				scope.Ability_timestamp <- Time() + BASE_spawn_cooldown
				break
			}
			case TF_ABILITY_HEAVY_RAGE:
			{
				scope.Ability_timestamp <- Time() + RAGE_spawn_cooldown
				break
			}
			case TF_ABILITY_CHEERS:
			{
				scope.Ability_timestamp <- Time() + CHEERS_spawn_cooldown
				break
			}
			case TF_ABILITY_KART:
			{
				scope.Ability_timestamp <- Time() + KART_spawn_cooldown
				break
			}
		}
	}
	function OnGameEvent_player_death(params)
	{
		/////////////////////////////////
		//  Remove any Ability Thinks  //
		/////////////////////////////////

		local player = GetPlayerFromUserID(params.userid)
		if (!ValidatePlayer(player)) return

		switch (player.GetAbilityWeaponIDX())
		{
			case TF_ABILITY_BASE:
			{
				AddThinkToEnt(player, null)
			}
			case TF_ABILITY_HEAVY_RAGE:
			{
				AddThinkToEnt(player, null)
			}
			case TF_ABILITY_CHEERS:
			{
				AddThinkToEnt(player, null)
			}
			case TF_ABILITY_KART:
			{
				AddThinkToEnt(player, null)
			}
		}
	}
}
__CollectGameEventCallbacks(ability)

function ValidatePlayer(player)
{
	if(!player) return false
	if(IsPlayerABot(player)) return false
	if(player.GetTeam() == TF_TEAM_PVE_INVADERS) return false
	return true
}

//////////////////////
//  Ability Thinks  //
//////////////////////

// BASE
function BaseAbility()
{
	if ( ( self.GetSteamID() == TheFatCat || self.GetSteamID() == ShadowBolt ) && Debug_Abilities)
	{
		local message = "DEBUG LIST:\nCurrent Ability: Base\n"
		foreach(k, v in this) message += (k + " : " + v + "\n")
		ClientPrint(self, 4, message)
	}

	local ability_name = "Base Ability"
	local player_class = TF_CLASS_CIVILIAN
	//local slot_num = 2 // 0,1,2


	if(!self.HasWeapon(TF_ABILITY_BASE) || !self.IsAlive() || self.GetPlayerClass() != player_class)
		return 1
	// Check
	/* local allow = false
	for (local i = 0; i < 3; i++)
	{
		if (self.GetWeaponIDXInSlot(i) == null) continue
		if (self.GetWeaponIDXInSlot(i) == TF_ABILITY_BASE && self.IsAlive() && self.GetPlayerClass() == player_class) allow = true
	}
	if(!allow) return 1 */

	local scope = GetScope(self)

	/// All Below is for the text
	local text_name = self.GetUserName() +  " Display"
	local text_entity = FindByName(null, text_name)
	local text_message = ""

	local text_time = format("Charging: %.0fs", (scope.Ability_timestamp-Time()))


	if(scope.Ability_timestamp-Time() < 0) text_message = ability_name + "\n►► Ready ◄◄" + "\n\n(+use_action_slot_item)"
	else text_message = ability_name + "\n" + text_time

	if(self.IsTaunting()) text_message = ""

	if(!text_entity)
	{
		text_entity = SpawnEntityFromTable("game_text", {
			targetname = text_name,
			message = text_message,
			x = 0.8,
			y = 0.7,
			color = "255 25 5",
			holdtime = 0.5, // has to be non zero
		})
	}
	else
	{
		text_entity.KeyValueFromString("message", text_message)
		text_entity.KeyValueFromString("color", "255 25 5")
	}

	text_entity.AcceptInput("Display", "" , self, null)

	//////////////////

	//////////
	// MAIN //
	//////////
	if (self.IsUsingActionSlot() && self.IsOnGround() && self.GetActiveWeaponIDX() == TF_ABILITY_BASE && ValidatePlayer(self) && scope.Ability_timestamp < Time())
	{
		scope.Ability_timestamp = Time() + BASE_attack_cooldown
		// Actual Use goes in here

		return -1
	}
	return -1
}

// Scout
// Soldier
// Pyro
// Demoman
// Heavy
function HeavyRage()
{
	if ( ( self.GetSteamID() == "[U:1:969530867]" || self.GetSteamID() == "[U:1:101345257]" ) && Debug_Abilities == true)
	{
		local message = "DEBUG LIST:\nCurrent Ability: Rage\n"
		foreach(k, v in this) message += (k + " : " + v + "\n")
		ClientPrint(self, 4, message)
	}

	local ability_name = "MEGA-CRUSH"
	local player_class = TF_CLASS_HEAVYWEAPONS

	if(!self.HasWeapon(TF_ABILITY_HEAVY_RAGE) || !self.IsAlive() || self.GetPlayerClass() != player_class)
		return 1


	local scope = GetScope(self)

	/// All Below is for the text
	local text_name = self.GetUserName() +  " Display"
	local text_entity = FindByName(null, text_name)
	local text_message = ""

	local text_time = format("Charging: %.0fs", (scope.Ability_timestamp-Time()))


	if(scope.Ability_timestamp-Time() < 0) text_message = ability_name + "\n►► Ready ◄◄" + "\n\n(+use_action_slot_item)"
	else text_message = ability_name + "\n" + text_time

	if(self.IsTaunting()) text_message = ""

	if(!text_entity)
	{
		text_entity = SpawnEntityFromTable("game_text", {
			targetname = text_name,
			message = text_message,
			x = 0.8,
			y = 0.7,
			color = "255 25 5",
			holdtime = 0.5, // has to be non zero
		})
	}
	else
	{
		text_entity.KeyValueFromString("message", text_message)
		text_entity.KeyValueFromString("color", "255 25 5")
	}

	text_entity.AcceptInput("Display", "" , self, null)

	//////////////////

	//////////
	// MAIN //
	//////////
	if (self.IsUsingActionSlot() && self.IsOnGround() && self.GetActiveWeaponIDX() == TF_ABILITY_HEAVY_RAGE
		 && ValidatePlayer(self) && scope.Ability_timestamp <= Time())
	{
		scope.Ability_timestamp = Time() + 5

		if (GetFlagStatus(FindByClassnameWithin(null, "item_teamflag", self.GetOrigin(), RAGE_bomb_range)) == 2) self.AddCondEx(TF_COND_MARKEDFORDEATH, 2.55, self)

		self.AddCondEx(TF_COND_IMMUNE_TO_PUSHBACK, 2.75, self)
		self.AddCondEx(TF_COND_STUNNED, 2.55, self)

		self.ForceTaunt(31441)
		EntFireByHandle(self, "RunScriptCode", "HeavyRage2()", 2.55, null, null)
		return -1
	}

	return -1
}
function HeavyRage2()
{
	local scope = self.GetScriptScope()

	if (!self.IsAlive()) return
	if (!self.IsTaunting()) return

	scope.Ability_timestamp = Time() + RAGE_attack_cooldown + 0.1 // cancel taunt delay

	EntFireByHandle(self, "RunScriptCode", "self.CancelTaunt()", 0.1, null, null)
	EntFireByHandle(self, "RunScriptCode", "self.AddCondEx(TF_COND_CRITBOOSTED, 12, self)", 0.1, null, null)
	EntFireByHandle(self, "RunScriptCode", "self.AddCondEx(TF_COND_DEFENSEBUFF, 12, self)", 0.1, null, null)
	EntFireByHandle(self, "RunScriptCode", "self.AddCondEx(TF_COND_REGENONDAMAGEBUFF, 12, self)", 0.1, null, null)

	local bomb = FindByClassnameWithin(null, "item_teamflag", self.GetOrigin(), RAGE_bomb_range)
	if(GetFlagStatus(bomb) == 2)
	{
		DispatchParticleEffect("hightower_explosion", bomb.GetOrigin(), QAngle(-90, 0, 0).Forward())
		bomb.EmitSound("items/cart_explode.wav")

		self.TakeDamage(RAGE_explode_damage, 0, self)
		self.DamageEveryBotWithin(RAGE_explode_radius, RAGE_explode_damage)
		self.DamageEveryTankWithin(RAGE_explode_radius, RAGE_explode_damage)
		EntFireByHandle(bomb, "ForceReset", "", -1, null, null)
	}
	else
	{
		DispatchParticleEffect("ExplosionCore_Wall", (self.GetOrigin() + Vector(0,0,10)), QAngle(-90, 0, 0).Forward())
		self.EmitSound("weapons/airstrike_small_explosion_02.wav")

		self.DamageEveryBotWithin(RAGE_explode_radius_small, RAGE_explode_damage_small)
		self.DamageEveryTankWithin(RAGE_explode_radius_small, RAGE_explode_damage_small)
	}
}
// Engineer
// Medic
// Sniper
// Spy
// AllClass
function CheersAbility()
{
	local ability_name = "VITAL RESURGENCE"

	if ( ( self.GetSteamID() == "[U:1:969530867]" || self.GetSteamID() == "[U:1:101345257]" ) && Debug_Abilities == 1)
	{
		local message = "DEBUG LIST:\nCurrent Ability: Cheers\n"
		foreach(k, v in this) message += (k + " : " + v + "\n")
		ClientPrint(null, 4, message)
	}

	if(!self.HasWeapon(TF_ABILITY_CHEERS) || !self.IsAlive())
		return 1

	local scope = GetScope(self)

	/// All Below is for the text
	local text_name = self.GetUserName() +  " Display"
	local text_entity = FindByName(null, text_name)
	local text_message = ""

	local text_time = format("Charging: %.0fs", (scope.Ability_timestamp-Time()))


	if(scope.Ability_timestamp-Time() < 0) text_message = ability_name + "\n►► Ready ◄◄" + "\n\n(+use_action_slot_item)"
	else text_message = ability_name + "\n" + text_time

	if(self.IsTaunting()) text_message = ""

	if(!text_entity)
	{
		text_entity = SpawnEntityFromTable("game_text", {
			targetname = text_name,
			message = text_message,
			x = 0.8,
			y = 0.7,
			color = "21 124 235",
			holdtime = 0.5, // has to be non zero
		})
	}
	else
	{
		text_entity.KeyValueFromString("message", text_message)
		text_entity.KeyValueFromString("color", "21 124 235")
	}

	text_entity.AcceptInput("Display", "" , self, null)

	//////////////////

	//////////
	// MAIN //
	//////////
	if (self.IsUsingActionSlot() && self.IsOnGround() && self.GetActiveWeaponIDX() == TF_ABILITY_CHEERS && ValidatePlayer(self) && scope.Ability_timestamp < Time())
	{
		scope.Ability_timestamp = Time() + 5.5
		self.ForceTaunt(31412)
		switch(self.GetPlayerClass())
		{
			case TF_CLASS_SNIPER:
				EntFireByHandle(self, "RunScriptCode", "CheersHealth()", 3.3, null, null)

			default:
				EntFireByHandle(self, "RunScriptCode", "CheersHealth()", 4, null, null)

		}
	}

	return -1
}
function CheersHealth()
{
	local scope = GetScope(self)
	if (!self.IsTaunting()) return

	self.SetHealth(self.GetMaxHealth() * CHEERS_health_mult)
	EntFireByHandle(self, "RunScriptCode", "self.AddCondEx(TF_COND_IMMUNE_TO_PUSHBACK, 20, self)", 0, null, null)
	EntFireByHandle(self, "RunScriptCode", "self.AddCondEx(TF_COND_GRAPPLINGHOOK_BLEEDING, 20, self)", 0, null, null)

	scope.Ability_timestamp = Time() + CHEERS_attack_cooldown + 3 // + 3 for taunt duration
}

function KartAbility()
{
	if ( ( self.GetSteamID() == TheFatCat || self.GetSteamID() == ShadowBolt ) && Debug_Abilities)
	{
		local message = "DEBUG LIST:\nCurrent Ability: Kart\n"
		foreach(k, v in this) message += (k + " : " + v + "\n")
		ClientPrint(self, 4, message)
	}

	local ability_name = "VEHICULAR MANNSLAUGHTER"


	if(!self.HasWeapon(TF_ABILITY_KART) || !self.IsAlive())
		return 1

	local scope = GetScope(self)

	/// All Below is for the text
	local text_name = self.GetUserName() +  " Display"
	local text_entity = FindByName(null, text_name)
	local text_message = ""

	local text_time = format("Charging: %.0fs", (scope.Ability_timestamp-Time()))


	if(scope.Ability_timestamp-Time() < 0) text_message = ability_name + "\n►► Ready ◄◄" + "\n\n(+use_action_slot_item)"
	else text_message = ability_name + "\n" + text_time

	if(self.IsTaunting()) text_message = ""

	if(!text_entity)
	{
		text_entity = SpawnEntityFromTable("game_text", {
			targetname = text_name,
			message = text_message,
			x = 0.8,
			y = 0.7,
			color = "30 230 100",
			holdtime = 0.5, // has to be non zero
		})
	}
	else
	{
		text_entity.KeyValueFromString("message", text_message)
		text_entity.KeyValueFromString("color", "30 230 100")
	}

	text_entity.AcceptInput("Display", "" , self, null)

	//////////////////

	//////////
	// MAIN //
	//////////
	if (self.IsUsingActionSlot() && self.IsOnGround() && self.GetActiveWeaponIDX() == TF_ABILITY_KART && ValidatePlayer(self) && scope.Ability_timestamp < Time())
	{
		scope.Ability_timestamp = Time() + 5

		self.ForceTaunt(30816)
		EntFireByHandle(self, "RunScriptCode", "kart2()", 2.55, null, null)
/*
		EntFireByHandle(self, "RunScriptCode", "self.CancelTaunt()", 2.55, null, null)
		EntFireByHandle(self, "RunScriptCode", "self.AddCondEx(TF_COND_HALLOWEEN_KART, 25, self)", 2.55, null, null)
		EntFireByHandle(self, "RunScriptCode", "self.AddCondEx(TF_COND_HALLOWEEN_QUICK_HEAL, 25, self)", 2.55, null, null)
		EntFireByHandle(self, "RunScriptCode", "self.AddCondEx(TF_COND_INVULNERABLE_HIDE_UNLESS_DAMAGED, 25, self)", 2.55, null, null)
		EntFireByHandle(self, "RunScriptCode", "self.AddCondEx(TF_COND_HALLOWEEN_TINY, 0, self)", 2.55, null, null) */

		return -1
	}
	return -1
}
function kart2()
{
	local scope = GetScope(self)

	if(!self.IsTaunting()) return

	self.AddCondEx(TF_COND_HALLOWEEN_KART, 25, self)
	self.AddCondEx(TF_COND_HALLOWEEN_QUICK_HEAL, 25, self)
	self.AddCondEx(TF_COND_INVULNERABLE_HIDE_UNLESS_DAMAGED, 25, self)
	self.AddCondEx(TF_COND_HALLOWEEN_TINY, 0, self)
	self.CancelTaunt()

	scope.Ability_timestamp = Time() + KART_attack_cooldown
}
