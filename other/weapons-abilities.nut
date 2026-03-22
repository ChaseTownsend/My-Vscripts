IncludeScript("fatcat_library")

// Allows changing this without editing and reloading script
// I.e. "script ::Debug_Abilities <- #"
::Debug_Abilities <- false

SetScriptVersion("Abilities", "1.0.1")

// Base
// - - - - - - - - - Base - - - - - - - - - |
local BASE_spawn_cooldown = 60           // |
local BASE_attack_cooldown = 15          // |
// - - - - - - - - - - - - - - - - - - - - -|
// Scout
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


local Ability_Thinker = FindByName(null, "Thinker_Abilities")
if (Ability_Thinker == null) Ability_Thinker = SpawnEntityFromTable("info_target", { targetname = "Thinker_Abilities" })
AddThinkToEnt(Ability_Thinker, "AbilityThink")

function AbilityThink()
{
	if( Players.len() < 1 )
		ReCalculatePlayers()
	
	foreach (player in Players)
	{
		// if we find old/removed instances in list, then, recalculate, and return
		if(!player)
		{
			ReCalculatePlayers()
			return -1
		}
		if(!player.IsValid())
		{
			ReCalculatePlayers()
			return -1
		}

		if(IsPlayerABot(player))
			continue

		if(!player.IsAlive())
			continue

		
		local weapon = player.GetAbilityWeapon()
		if (weapon == null)
			continue
		local scope = GetScope(weapon)

		if ("Ability" in scope && scope.Ability != null)
			continue

		switch (weapon.GetIDX())
		{
			case TF_ABILITY_BASE:
			{
				AddThinkToEnt(weapon, "BaseAbility")

				scope.Ability_timestamp <- Time() + BASE_spawn_cooldown
				scope.Ability <- "Base"
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
		if (IsPlayerABot(player)) return

		local weapon = player.GetAbilityWeapon()
		if (weapon == null) return
		local scope = GetScope(weapon)

		scope.Ability <- null

		switch (weapon.GetIDX())
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
		local player = GetPlayerFromUserID(params.userid)
		if (IsPlayerABot(player)) return

		local weapon = player.GetAbilityWeapon()
		if (weapon) ClearThinks(weapon)
	}
	function OnGameEvent_player_disconnect(params)
	{
		if (params.bot != 0) return

		local player = GetPlayerFromUserID(params.userid)
		local text = null
		if(!player)
		{
			text = FindByName(null, "User: " + params.networkid +  " Display")
			if(!text) return
			text.Kill()
			return
		}
		local weapon = player.GetAbilityWeapon()
		if ( !weapon ) return

		local scope = GetScope(weapon)
		if(IsNotInScope("m_hText", scope))
			return

		text = scope.m_hText
		if ( !text ) return
		text.Kill()
	}
}
__CollectGameEventCallbacks(ability)

//////////////////////
//  Ability Thinks  //
//////////////////////

// BASE
function BaseAbility()
{
	local ability_name = "Base Ability"
	local player_class = TF_CLASS_CIVILIAN

	local player = self.GetOwner()

	if ( player.IsAdmin() && Debug_Abilities)
	{
		local message = "Variable list:\n"
		foreach(k, v in this)
		{
			if (!startswith(k, "__"))
				message += (k + " : " + v + "\n")
		}
		player.PrintToHud(message)
	}

	// foreach (k, v in getstackinfos(0)) printl(k + ": " + v)
	if (!player.HasWeapon(TF_ABILITY_BASE) || !player.IsAlive() || player.GetPlayerClass() != player_class)
		return 1

	// Setup Text
	local text_name = "User: " + player.GetSteamID() +  " Display"
	local text = FindByName(null, text_name)
	local text_msg = ""
	local clr = "255 25 5"

	if (Ability_timestamp-Time() < 0) text_msg = ability_name + "\n► Ready ◄"
	else text_msg = format("%s\n%s", ability_name, format("Charging: %.0fs", (Ability_timestamp-Time())))
	if (player.IsTaunting()) text_msg = ""

	if ( !text )
	{
		text = SpawnEntityFromTable("game_text", {
			targetname = text_name,
			message = text_msg,
			x = 0.75,
			y = 0.75,
			color = clr,
			holdtime = 0.5
		})
	}
	else
	{
		text.KeyValueFromString("message", text_msg)
		text.KeyValueFromString("color", clr)
	}

	text.SetOwner(player)
	text.AcceptInput("Display", "" , player, null)

	this.m_hText <- text

	//////////////////

	//////////
	// MAIN //
	//////////
	if (player.IsUsingActionSlot() && player.IsOnGround() && player.GetActiveWeaponIDX() == TF_ABILITY_BASE && Ability_timestamp < Time())
	{
		Ability_timestamp = Time() + BASE_attack_cooldown
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

	if ( player.IsAdmin() && Debug_Abilities)
	{
		local message = "Variable list:\n"
		foreach(k, v in this)
		{
			if (!startswith(k, "__"))
				message += (k + " : " + v + "\n")
		}
		player.PrintToHud(message)
	}

	if (!player.HasWeapon(TF_ABILITY_HEAVY_RAGE) || !player.IsAlive() || player.GetPlayerClass() != player_class)
		return 1

	// Setup Text
	local text_name = "User: " + player.GetSteamID() +  " Display"
	local text = FindByName(null, text_name)
	local text_msg = ""
	local clr = "255 25 5"

	if (Ability_timestamp-Time() < 0) text_msg = ability_name + "\n► Ready ◄"
	else text_msg = format("%s\n%s", ability_name, format("Charging: %.0fs", (Ability_timestamp-Time())))
	if (player.IsTaunting()) text_msg = ""

	if ( !text )
	{
		text = SpawnEntityFromTable("game_text", {
			targetname = text_name,
			message = text_msg,
			x = 0.75,
			y = 0.75,
			color = clr,
			holdtime = 0.5
		})
	}
	else
	{
		text.KeyValueFromString("message", text_msg)
		text.KeyValueFromString("color", clr)
	}

	text.SetOwner(player)
	text.AcceptInput("Display", "" , player, null)

	this.m_hText <- text

	//////////////////

	//////////
	// MAIN //
	//////////
	if (player.IsUsingActionSlot() && player.IsOnGround() && player.GetActiveWeaponIDX() == TF_ABILITY_HEAVY_RAGE && Ability_timestamp <= Time())
	{
		Ability_timestamp = Time() + 5

		if (GetFlagStatus(FindByClassnameWithin(null, "item_teamflag", player.GetOrigin(), RAGE_bomb_range)) == FLAG_DROPPED) 
			player.AddCondEx(TF_COND_MARKEDFORDEATH, 2.55, self)

		player.AddCondEx(TF_COND_IMMUNE_TO_PUSHBACK, 2.75, player)
		player.AddCondEx(TF_COND_STUNNED, 2.55, player)

		player.ForceTaunt(TF_TAUNT_UNLEASHED_RAGE)
		EntFireByHandle(player, "RunScriptCode", "HeavyGoKaboom()", 2.55, null, null)
		return -1
	}

	return -1
}
function HeavyGoKaboom()
{
	if (!self.IsAlive()) return
	if (!self.IsTaunting()) return

	if (self.GetAbilityWeapon() == null) return

	GetScope(self.GetAbilityWeapon()).Ability_timestamp = Time() + RAGE_attack_cooldown + 0.1 // cancel taunt delay

	EntFireByHandle(self, "RunScriptCode", "self.CancelTaunt()", 0.1, null, null)
	EntFireByHandle(self, "RunScriptCode", "self.AddCondEx(TF_COND_CRITBOOSTED, 12, self)", 0.1, null, null)
	EntFireByHandle(self, "RunScriptCode", "self.AddCondEx(TF_COND_DEFENSEBUFF, 12, self)", 0.1, null, null)
	EntFireByHandle(self, "RunScriptCode", "self.AddCondEx(TF_COND_REGENONDAMAGEBUFF, 12, self)", 0.1, null, null)

	PrecacheSound("weapons/airstrike_small_explosion_02.wav")
	PrecacheSound("items/cart_explode.wav")

	local bomb = FindByClassnameWithin(null, "item_teamflag", self.GetOrigin(), RAGE_bomb_range)
	if (GetFlagStatus(bomb) == FLAG_DROPPED)
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

	if ( player.IsAdmin() && Debug_Abilities )
	{
		local message = "Variable list:\n"
		foreach(k, v in this)
		{
			if (!startswith(k, "__"))
				message += (k + " : " + v + "\n")
		}
		player.PrintToHud(message)
	}

	if ( !player.HasWeapon(TF_ABILITY_CHEERS) || !player.IsAlive() )
	{
		ClearThinks(self)
		return
	}

	// Setup Text
	local text_name = "User: " + player.GetSteamID() +  " Display"
	local text = FindByName(null, text_name)
	local text_msg = ""
	local clr = "21 124 235"

	if (Ability_timestamp-Time() < 0) text_msg = ability_name + "\n► Ready ◄"
	else text_msg = format("%s\n%s", ability_name, format("Charging: %.0fs", (Ability_timestamp-Time())))
	if (player.IsTaunting()) text_msg = ""

	if ( !text )
	{
		text = SpawnEntityFromTable("game_text", {
			targetname = text_name,
			message = text_msg,
			x = 0.75,
			y = 0.75,
			color = clr,
			holdtime = 0.5
		})
	}
	else
	{
		text.KeyValueFromString("message", text_msg)
		text.KeyValueFromString("color", clr)
	}

	text.SetOwner(player)
	text.AcceptInput("Display", "" , player, null)

	this.m_hText <- text

	//////////////////

	//////////
	// MAIN //
	//////////
	if (player.IsUsingActionSlot() && player.IsOnGround() && player.GetActiveWeaponIDX() == TF_ABILITY_CHEERS && Ability_timestamp < Time())
	{
		Ability_timestamp = Time() + 5.5
		player.ForceTaunt(TF_TAUNT_CHEERS)

		switch (player.GetPlayerClass())
		{
			case TF_CLASS_DEMOMAN:
			{
				EntFireByHandle(player, "RunScriptCode", "GiveMeThyHealth()", 4.4, null, null)
				return -1
			}
			case TF_CLASS_HEAVYWEAPONS:
			{
				EntFireByHandle(player, "RunScriptCode", "GiveMeThyHealth()", 4.1, null, null)
				return -1
			}
			case TF_CLASS_MEDIC:
			{
				EntFireByHandle(player, "RunScriptCode", "GiveMeThyHealth()", 3.9, null, null)
				return -1
			}
			case TF_CLASS_PYRO:
			{
				EntFireByHandle(player, "RunScriptCode", "GiveMeThyHealth()", 3.85, null, null)
				return -1
			}
			case TF_CLASS_SNIPER:
			{
				EntFireByHandle(player, "RunScriptCode", "GiveMeThyHealth()", 3.15, null, null)
				return -1
			}
			default:
			{
				EntFireByHandle(player, "RunScriptCode", "GiveMeThyHealth()", 4, null, null)
				return -1
			}
		}
		return -1
	}

	return -1
}

function GiveMeThyHealth()
{
	if (!self.IsAlive()) return
	if (!self.IsTaunting()) return

	local weapon = self.GetAbilityWeapon()
	if (weapon == null) return

	self.SetHealth(self.GetMaxHealth() * CHEERS_health_mult)
	EntFireByHandle(self, "RunScriptCode", "self.AddCondEx(TF_COND_IMMUNE_TO_PUSHBACK, 20, self)", 0, null, null)
	EntFireByHandle(self, "RunScriptCode", "self.AddCondEx(TF_COND_GRAPPLINGHOOK_BLEEDING, 20, self)", 0, null, null)

	GetScope(weapon).Ability_timestamp = Time() + CHEERS_attack_cooldown + 3 // + 3 for taunt duration
}

function KartAbility()
{
	local ability_name = "VEHICULAR MANNSLAUGHTER"

	local player = self.GetOwner()

	if ( player.IsAdmin() && Debug_Abilities)
	{
		local message = "Variable list:\n"
		foreach(k, v in this)
		{
			if (!startswith(k, "__"))
				message += (k + " : " + v + "\n")
		}
		player.PrintToHud(message)
	}

	if (!player.HasWeapon(TF_ABILITY_KART) || !player.IsAlive())
		return 1

	// Setup Text
	local text_name = "User: " + player.GetSteamID() +  " Display"
	local text = FindByName(null, text_name)
	local text_msg = ""
	local clr = "95 25 255"

	if (Ability_timestamp-Time() < 0) text_msg = ability_name + "\n► Ready ◄"
	else text_msg = format("%s\n%s", ability_name, format("Charging: %.0fs", (Ability_timestamp-Time())))
	if (player.IsTaunting()) text_msg = ""

	if ( !text )
	{
		text = SpawnEntityFromTable("game_text", {
			targetname = text_name,
			message = text_msg,
			x = 0.75,
			y = 0.75,
			color = clr,
			holdtime = 0.5
		})
	}
	else
	{
		text.KeyValueFromString("message", text_msg)
		text.KeyValueFromString("color", clr)
	}

	text.SetOwner(player)
	text.AcceptInput("Display", "" , player, null)

	this.m_hText <- text

	//////////////////

	//////////
	// MAIN //
	//////////
	if (player.IsUsingActionSlot() && player.IsOnGround() && player.GetActiveWeaponIDX() == TF_ABILITY_KART && Ability_timestamp < Time())
	{
		Ability_timestamp = Time() + 5

		player.ForceTaunt(TF_TAUNT_SECOND_RATE_SORCERY)

		switch (player.GetPlayerClass())
		{
			case TF_CLASS_DEMOMAN:
			{
				EntFireByHandle(player, "RunScriptCode", "SummonLasKart()", 3.75, null, null)
				return -1
			}
			case TF_CLASS_SCOUT:
			case TF_CLASS_SOLDIER:
			case TF_CLASS_PYRO:
			case TF_CLASS_ENGINEER:
			{
				EntFireByHandle(player, "RunScriptCode", "SummonLasKart()", 2.75, null, null)
				return -1
			}
			case TF_CLASS_MEDIC:
			case TF_CLASS_HEAVYWEAPONS:
			{
				EntFireByHandle(player, "RunScriptCode", "SummonLasKart()", 2.6, null, null)
				return -1
			}
			case TF_CLASS_SNIPER:
			{
				EntFireByHandle(player, "RunScriptCode", "SummonLasKart()", 2.2, null, null)
				return -1
			}
			default:
			{
				EntFireByHandle(player, "RunScriptCode", "SummonLasKart()", 2.55, null, null)
				return -1
			}
		}
		return -1
	}
	return -1
}
function SummonLasKart()
{
	if (!self.IsAlive()) return
	if (!self.IsTaunting()) return

	if (self.GetAbilityWeapon() == null) return

	local trace = {
		start = self.GetOrigin() + Vector(0, 0, 35)
		end = self.GetOrigin() + Vector(0, 0, 35)
		mask = MASK_SOLID
		hullmax = GetPropVector(self, "m_Collision.m_vecMaxs") * 0.975
		hullmin = GetPropVector(self, "m_Collision.m_vecMins") * 0.975
		allsolid = false
		ignore = self
	}
	TraceHull(trace)
	if(trace.allsolid == true)
	{
		self.ForceRespawn()
		self.PrintToHud("You were respawned to avoid getting stuck.")
		return
	}

	self.SetAbsOrigin(self.GetOrigin() + Vector(0, 0, 35))
	self.AddCondEx(TF_COND_HALLOWEEN_KART, 25, self)
	self.AddCondEx(TF_COND_HALLOWEEN_QUICK_HEAL, 25, self)
	self.AddCondEx(TF_COND_INVULNERABLE_HIDE_UNLESS_DAMAGED, 25, self)
	self.AddCondEx(TF_COND_HALLOWEEN_TINY, 0, self)
	self.SetScale(1.0)
	self.CancelTaunt()

	GetScope(self.GetAbilityWeapon()).Ability_timestamp = Time() + KART_attack_cooldown
}
