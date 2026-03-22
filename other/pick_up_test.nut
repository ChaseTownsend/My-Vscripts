IncludeScript("fatcat_library")

// Allows changing this without editing and reloading script
// I.e. "script ::Debug_Abilities <- #"
::Debug_Abilities <- true

// Base
// - - - - - - - - - Base - - - - - - - - - |
local BASE_spawn_cooldown = 60           // |
local BASE_attack_cooldown = 15          // |
// - - - - - - - - - - - - - - - - - - - - -|
// Scout
// - - - - - - - - - Test - - - - - - - - - |
local TEST_spawn_cooldown = 10           // |
local TEST_attack_cooldown = 0.1          // |
// - - - - - - - - - - - - - - - - - - - - -|
// Soldier
// Pyro
// Demoman
// Heavy
// - - - - - - - - - Rage - - - - - - - - - |
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
local CHEERS_spawn_cooldown = 20         // | 20
local CHEERS_attack_cooldown = 75        // | 75
local CHEERS_health_mult = 10.00         // |
// - - - - - - - - - - - - - - - - - - - - -|
// - - - - - - - -   KART   - - - - - - - - |
local KART_spawn_cooldown = 30           // | 30
local KART_attack_cooldown = 75          // | 75
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
		local weapon = player.GetAbilityWeapon()
		if(weapon == null)
		{
			printl("Found No Ability Weapons for " + player)
			continue
		}
		local idx = GetWeaponIDX(weapon)
		local scope = GetScope(weapon)

		if("Ability" in scope)
		{
			if(scope.Ability != null)
				continue
		}

		switch (idx)
		{
			case TF_ABILITY_BASE:
			{
				AddThinkToEnt(weapon, "BaseAbility")

				scope.Ability_timestamp <- Time() + BASE_spawn_cooldown
				scope.Ability <- "Base"
				break
			}
			case TF_ABILITY_TEST:
			{
				AddThinkToEnt(weapon, "TestAbility")

				scope.Ability_timestamp <- Time() + TEST_spawn_cooldown
				scope.Ability <- "Test"
				break
			}
			case TF_ABILITY_HEAVY_RAGE:
			{
				AddThinkToEnt(weapon, "HeavyRage")

				scope.Ability_timestamp <- Time() + RAGE_spawn_cooldown
				scope.Ability <- "Rage"
				break
			}
			case TF_ABILITY_CHEERS:
			{
				AddThinkToEnt(weapon, "CheersAbility")

				scope.Ability_timestamp <- Time() + CHEERS_spawn_cooldown
				scope.Ability <- "Cheers"
				break
			}
			case TF_ABILITY_KART:
			{
				AddThinkToEnt(weapon, "KartAbility")

				scope.Ability_timestamp <- Time() + KART_spawn_cooldown
				scope.Ability <- "Kart"
				break
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

		local weapon = player.GetAbilityWeapon()
		if(weapon == null) return
		local idx = GetWeaponIDX(weapon)
		local scope = GetScope(weapon)

		scope.Ability <- null

		switch (idx)
		{
			case TF_ABILITY_BASE:
			{
				scope.Ability_timestamp <- Time() + BASE_spawn_cooldown
				break
			}
			case TF_ABILITY_TEST:
			{
				scope.Ability_timestamp <- Time() + TEST_spawn_cooldown
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
	function OnGameEvent_post_inventory_application(params)
	{
		local player = GetPlayerFromUserID(params.userid)

		if( !ValidatePlayer(player) )
			return

		local weapon = player.GetAbilityWeapon()
		if(weapon == null) 
			return
		local idx = GetWeaponIDX(weapon)

		if( idx == TF_ABILITY_TEST )
		{
			SetPropInt( player, "m_ArmorValue", 0x80000000)
		}
	}
	function OnGameEvent_player_death(params)
	{
		/////////////////////////////////
		//  Remove any Ability Thinks  //
		/////////////////////////////////

		local player = GetPlayerFromUserID(params.userid)
		if (!ValidatePlayer(player)) return

		local weapon = player.GetAbilityWeapon()
		if(weapon == null) return
		local idx = GetWeaponIDX(weapon)

		switch (idx)
		{
			case TF_ABILITY_BASE:
			{
				AddThinkToEnt(weapon, null)
			}
			case TF_ABILITY_TEST:
			{
				AddThinkToEnt(weapon, null)
			}
			case TF_ABILITY_HEAVY_RAGE:
			{
				AddThinkToEnt(weapon, null)
			}
			case TF_ABILITY_CHEERS:
			{
				AddThinkToEnt(weapon, null)
			}
			case TF_ABILITY_KART:
			{
				AddThinkToEnt(weapon, null)
			}
		}
	}
	function OnGameEvent_player_disconnect(params)
	{
		local text = FindByName(null, "User: " + params.networkid +  " Display")
		if(!text.IsValid()) return

		text.Kill()
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
	local ability_name = "Base Ability"
	local player_class = TF_CLASS_CIVILIAN

	local player = self.GetOwner()

	if ( ( player.GetSteamID() == TheFatCat || player.GetSteamID() == ShadowBolt ) && Debug_Abilities)
	{
		local message = "Variable list:\n"
		foreach(k, v in this)
		{
			if(!startswith(k, "__"))
				message += (k + " : " + v + "\n")
		}
		ClientPrint(player, 4, message)
	}

	// foreach (k, v in getstackinfos(0)) printl(k + ": " + v)
	if(!player.HasWeapon(TF_ABILITY_BASE) || !player.IsAlive() || player.GetPlayerClass() != player_class)
		return 1

	/// All Below is for the text
	local text_name = "User: " + player.GetSteamID() +  " Display"
	local text_entity = FindByName(null, text_name)
	local text_message = ""

	local text_time = format("Charging: %.0fs", (this.Ability_timestamp-Time()))


	if(this.Ability_timestamp-Time() < 0) text_message = ability_name + "\n► Ready ◄"
	else text_message = ability_name + "\n" + text_time

	if(player.IsTaunting()) text_message = ""

	if(!text_entity)
	{
		text_entity = SpawnEntityFromTable("game_text", {
			targetname = text_name,
			message = text_message,
			x = 0.75,
			y = 0.75,
			color = "255 25 5",
			holdtime = 0.5, // has to be non zero
		})
	}
	else
	{
		text_entity.KeyValueFromString("message", text_message)
		text_entity.KeyValueFromString("color", "255 25 5")
	}

	text_entity.AcceptInput("Display", "" , player, null)

	//////////////////

	//////////
	// MAIN //
	//////////
	if (player.IsUsingActionSlot() && player.IsOnGround() && player.GetActiveWeaponIDX() == TF_ABILITY_BASE && ValidatePlayer(player) && this.Ability_timestamp < Time())
	{
		this.Ability_timestamp = Time() + BASE_attack_cooldown
		// Actual Use goes in here

		player.PrintToHud("Test")
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
	local ability_name = "MEGA-CRUSH"
	local player_class = TF_CLASS_HEAVYWEAPONS

	local player = self.GetOwner()

	if ( ( player.GetSteamID() == TheFatCat || player.GetSteamID() == ShadowBolt ) && Debug_Abilities)
	{
		local message = "Variable list:\n"
		foreach(k, v in this)
		{
			if(!startswith(k, "__"))
				message += (k + " : " + v + "\n")
		}
		ClientPrint(player, 4, message)
	}

	if(!player.HasWeapon(TF_ABILITY_HEAVY_RAGE) || !player.IsAlive() || player.GetPlayerClass() != player_class)
		return 1

	/// All Below is for the text
	local text_name = "User: " + player.GetSteamID() +  " Display"
	local text_entity = FindByName(null, text_name)
	local text_message = ""

	local text_time = format("Charging: %.0fs", (this.Ability_timestamp-Time()))


	if(this.Ability_timestamp-Time() < 0) text_message = ability_name + "\n► Ready ◄"
	else text_message = ability_name + "\n" + text_time

	if(player.IsTaunting()) text_message = ""

	if(!text_entity)
	{
		text_entity = SpawnEntityFromTable("game_text", {
			targetname = text_name,
			message = text_message,
			x = 0.75,
			y = 0.75,
			color = "255 25 5",
			holdtime = 0.5, // has to be non zero
		})
	}
	else
	{
		text_entity.KeyValueFromString("message", text_message)
		text_entity.KeyValueFromString("color", "255 25 5")
	}

	text_entity.AcceptInput("Display", "" , player, null)

	//////////////////

	//////////
	// MAIN //
	//////////
	if (player.IsUsingActionSlot() && player.IsOnGround() && player.GetActiveWeaponIDX() == TF_ABILITY_HEAVY_RAGE && ValidatePlayer(player) && this.Ability_timestamp <= Time())
	{
		this.Ability_timestamp = Time() + 5

		if (GetFlagStatus(FindByClassnameWithin(null, "item_teamflag", player.GetOrigin(), RAGE_bomb_range)) == 2) player.AddCondEx(TF_COND_MARKEDFORDEATH, 2.55, self)

		player.AddCondEx(TF_COND_IMMUNE_TO_PUSHBACK, 2.75, player)
		player.AddCondEx(TF_COND_STUNNED, 2.55, player)

		player.ForceTaunt(TF_TAUNT_UNLEASHED_RAGE)
		EntFireByHandle(player, "RunScriptCode", "HeavyRage2()", 2.55, null, null)
		return -1
	}

	return -1
}
function HeavyRage2()
{
	if (!self.IsAlive()) return
	if (!self.IsTaunting()) return

	if(self.GetAbilityWeapon() == null) return
	local scope = GetScope(self.GetAbilityWeapon())


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
		bomb.AcceptInput("ForceReset", "", self, self)
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

	local player = self.GetOwner()

	if ( ( player.GetSteamID() == TheFatCat || player.GetSteamID() == ShadowBolt ) && Debug_Abilities)
	{
		local message = "Variable list:\n"
		foreach(k, v in this)
		{
			if(!startswith(k, "__"))
				message += (k + " : " + v + "\n")
		}
		ClientPrint(player, 4, message)
	}

	if(!player.HasWeapon(TF_ABILITY_CHEERS) || !player.IsAlive())
		return 1

	/// All Below is for the text
	local text_name = "User: " + player.GetSteamID() +  " Display"
	local text_entity = FindByName(null, text_name)
	local text_message = ""

	local text_time = format("Charging: %.0fs", (this.Ability_timestamp-Time()))


	if(this.Ability_timestamp-Time() < 0) text_message = ability_name + "\n► Ready ◄"
	else text_message = ability_name + "\n" + text_time

	if(player.IsTaunting()) text_message = ""

	if(!text_entity)
	{
		text_entity = SpawnEntityFromTable("game_text", {
			targetname = text_name,
			message = text_message,
			x = 0.75,
			y = 0.75,
			color = "21 124 235",
			holdtime = 0.5, // has to be non zero
		})
	}
	else
	{
		text_entity.KeyValueFromString("message", text_message)
		text_entity.KeyValueFromString("color", "21 124 235")
	}

	text_entity.AcceptInput("Display", "" , player, null)

	//////////////////

	//////////
	// MAIN //
	//////////
	if (player.IsUsingActionSlot() && player.IsOnGround() && player.GetActiveWeaponIDX() == TF_ABILITY_CHEERS && ValidatePlayer(player) && this.Ability_timestamp < Time())
	{
		this.Ability_timestamp = Time() + 5.5
		player.ForceTaunt(TF_TAUNT_CHEERS)

		switch (player.GetPlayerClass())
		{
			case TF_CLASS_DEMOMAN:
			{
				EntFireByHandle(player, "RunScriptCode", "CheersHealth()", 4.4, null, null)
				return -1
			}
			case TF_CLASS_HEAVYWEAPONS:
			{
				EntFireByHandle(player, "RunScriptCode", "CheersHealth()", 4.1, null, null)
				return -1
			}
			case TF_CLASS_MEDIC:
			{
				EntFireByHandle(player, "RunScriptCode", "CheersHealth()", 3.9, null, null)
				return -1
			}
			case TF_CLASS_PYRO:
			{
				EntFireByHandle(player, "RunScriptCode", "CheersHealth()", 3.85, null, null)
				return -1
			}
			case TF_CLASS_SNIPER:
			{
				EntFireByHandle(player, "RunScriptCode", "CheersHealth()", 3.15, null, null)
				return -1
			}
			default:
			{
				EntFireByHandle(player, "RunScriptCode", "CheersHealth()", 4, null, null)
				return -1
			}
		}
		return -1
	}

	return -1
}

function CheersHealth()
{
	if (!self.IsAlive()) return
	if (!self.IsTaunting()) return

	local weapon = self.GetAbilityWeapon()
	if(weapon == null) return
	local scope = GetScope(weapon)


	self.SetHealth(self.GetMaxHealth() * CHEERS_health_mult)
	EntFireByHandle(self, "RunScriptCode", "self.AddCondEx(TF_COND_IMMUNE_TO_PUSHBACK, 20, self)", 0, null, null)
	EntFireByHandle(self, "RunScriptCode", "self.AddCondEx(TF_COND_GRAPPLINGHOOK_BLEEDING, 20, self)", 0, null, null)

	scope.Ability_timestamp = Time() + CHEERS_attack_cooldown + 3 // + 3 for taunt duration
}

function KartAbility()
{
	local ability_name = "VEHICULAR MANNSLAUGHTER"

	local player = self.GetOwner()
	if ( ( player.GetSteamID() == TheFatCat || player.GetSteamID() == ShadowBolt ) && Debug_Abilities)
	{
		local message = "Variable list:\n"
		foreach(k, v in this)
		{
			if(!startswith(k, "__"))
				message += (k + " : " + v + "\n")
		}
		ClientPrint(player, 4, message)
	}

	if(!player.HasWeapon(TF_ABILITY_KART) || !player.IsAlive())
		return 1

	/// All Below is for the text
	local text_name = "User: " + player.GetSteamID() +  " Display"
	local text_entity = FindByName(null, text_name)
	local text_message = ""

	local text_time = format("Charging: %.0fs", (this.Ability_timestamp-Time()))


	if(this.Ability_timestamp-Time() < 0) text_message = ability_name + "\n► Ready ◄"
	else text_message = ability_name + "\n" + text_time

	if(player.IsTaunting()) text_message = ""

	if(!text_entity)
	{
		text_entity = SpawnEntityFromTable("game_text", {
			targetname = text_name,
			message = text_message,
			x = 0.75,
			y = 0.75,
			color = "95 25 255",
			holdtime = 0.5, // has to be non zero
		})
	}
	else
	{
		text_entity.KeyValueFromString("message", text_message)
		text_entity.KeyValueFromString("color", "95 25 255")
	}

	text_entity.AcceptInput("Display", "" , player, null)

	//////////////////

	//////////
	// MAIN //
	//////////
	if (player.IsUsingActionSlot() && player.IsOnGround() && player.GetActiveWeaponIDX() == TF_ABILITY_KART && ValidatePlayer(player) && this.Ability_timestamp < Time())
	{
		this.Ability_timestamp = Time() + 5

		player.ForceTaunt(TF_TAUNT_SECOND_RATE_SORCERY)

		switch (player.GetPlayerClass())
		{
			case TF_CLASS_DEMOMAN:
			{
				EntFireByHandle(player, "RunScriptCode", "kart2()", 3.75, null, null)
				return -1
			}
			case TF_CLASS_SCOUT:
			case TF_CLASS_SOLDIER:
			case TF_CLASS_PYRO:
			case TF_CLASS_ENGINEER:
			{
				EntFireByHandle(player, "RunScriptCode", "kart2()", 2.75, null, null)
				return -1
			}
			case TF_CLASS_MEDIC:
			case TF_CLASS_HEAVYWEAPONS:
			{
				EntFireByHandle(player, "RunScriptCode", "kart2()", 2.6, null, null)
				return -1
			}
			case TF_CLASS_SNIPER:
			{
				EntFireByHandle(player, "RunScriptCode", "kart2()", 2.2, null, null)
				return -1
			}
			default:
			{
				EntFireByHandle(player, "RunScriptCode", "kart2()", 2.55, null, null)
				return -1
			}
		}
		return -1
	}
	return -1
}
function kart2()
{
	if (!self.IsAlive()) return
	if(!self.IsTaunting()) return

	if(self.GetAbilityWeapon() == null) return
	local scope = GetScope(self.GetAbilityWeapon())

	self.AddCondEx(TF_COND_HALLOWEEN_KART, 25, self)
	self.AddCondEx(TF_COND_HALLOWEEN_QUICK_HEAL, 25, self)
	self.AddCondEx(TF_COND_INVULNERABLE_HIDE_UNLESS_DAMAGED, 25, self)
	self.AddCondEx(TF_COND_HALLOWEEN_TINY, 0, self)

	self.CancelTaunt()

	scope.Ability_timestamp = Time() + KART_attack_cooldown
}



function TestAbility()
{
	local ability_name = "Test Ability"
	local player_class = TF_CLASS_SCOUT

	local player = self.GetOwner()

	if ( ( player.GetSteamID() == TheFatCat || player.GetSteamID() == ShadowBolt ) && Debug_Abilities)
	{
		local message = "Variable list:\n"
		foreach(k, v in this)
		{
			if(!startswith(k, "__"))
				message += (k + " : " + v + "\n")
		}
		ClientPrint(player, 4, message)
	}

	if(!player.HasWeapon(TF_ABILITY_TEST) || !player.IsAlive() || player.GetPlayerClass() != player_class)
		return 1

	/// All Below is for the text
	local text_name = "User: " + player.GetSteamID() +  " Display"
	local text_entity = FindByName(null, text_name)
	local text_message = ""

	local text_time = format("Charging: %.0fs", (this.Ability_timestamp-Time()))


	if(this.Ability_timestamp-Time() < 0) text_message = ability_name + "\n► Ready ◄"
	else text_message = ability_name + "\n" + text_time

	if(player.IsTaunting()) text_message = ""

	if(!text_entity)
	{
		text_entity = SpawnEntityFromTable("game_text", {
			targetname = text_name,
			message = text_message,
			x = 0.75,
			y = 0.75,
			color = "255 25 5",
			holdtime = 0.5, // has to be non zero
		})
	}
	else
	{
		text_entity.KeyValueFromString("message", text_message)
		text_entity.KeyValueFromString("color", "255 25 5")
	}

	text_entity.AcceptInput("Display", "" , player, null)

	//////////////////

	//////////
	// MAIN //
	//////////
	if (player.IsUsingActionSlot() && ValidatePlayer(player) && this.Ability_timestamp < Time())
	{
		this.Ability_timestamp = Time() + TEST_attack_cooldown

		local info = {
			origin = player.GetFrontOffset(64) + Vector(0, 0, 64)
			angles = Vector(0, player.EyeAngles().y, 0)
			team = 2
			model = "models/weapons/c_models/c_toolbox/c_toolbox.mdl"
			sound = "player/souls_receive2.wav"
			func = function(){
				player.AddCondEx(TF_COND_CRITBOOSTED, 10, null)
				EmitSoundEx({
					sound_name = "player/souls_receive2.wav"
					channel = 3
					volume = 0.5
					sound_level = SNDLVL_30dB
					entity = player
				})
			}
		}
		CreatePickup(info)

		return -1
	}
	return -1
}