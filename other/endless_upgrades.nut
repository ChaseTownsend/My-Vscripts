IncludeScript("fatcat_library")

const LEVEL_UP_TIME = 30				// Time Between level ups
const LEVEL_UP_REWARD = 1000			// How much money to give on Level ups
const LEVEL_STARTING_CURRENCY = 500		// Starting currency for bots
const LEVEL_KILL_REWARD = 10			// How much to reward players * level (e.x. 10 * level)
// const LEVEL_KILL_BASE = 10			// How much money to reward on top of

//Maybe a bit too big
/* local BOT_WEAPON_UPGRADES = {
	DAMAGE_UPGRADE = {
		attribute = "CARD: damage bonus"
		cap = 3.0
		increment = 0.2
		cost = 250
		default_value = 1
		only_allow_weapons = []
		disallowed_weapons = [
			"tf_weapon_buff_item",
			"tf_wearable",
			"tf_wearable_demoshield",
			"tf_wearable_razorback",
			"tf_weapon_jar",
			"tf_weapon_jar_gas",
			"tf_weapon_jar_milk",
			"tf_weapon_medigun",
			"tf_weapon_builder",
			"tf_weapon_sapper"
		]
	}
	FIRE_RATE_UPGRADE = {
		attribute = "fire rate bonus HIDDEN"
		cap = 0.2
		increment = -0.2
		cost = 300
		default_value = 1
		only_allow_weapons = []
		disallowed_weapons = [
			"slot2",
			"tf_weapon_flamethrower",
			"tf_weapon_buff_item",
			"tf_wearable",
			"tf_wearable_demoshield",
			"tf_wearable_razorback",
			"tf_weapon_jar",
			"tf_weapon_jar_gas",
			"tf_weapon_jar_milk",
			"tf_weapon_medigun",
			"tf_weapon_builder",
			"tf_weapon_sapper"
		]
	}
	RELOAD_SPEED_UPGRADE = {
		attribute = "faster reload rate"
		cap = 0.1
		increment = -0.15
		cost = 250
		default_value = 1
		only_allow_weapons = []
		disallowed_weapons = [
			"slot2",
			"tf_weapon_flamethrower",
			"tf_weapon_buff_item",
			"tf_wearable",
			"tf_wearable_demoshield",
			"tf_wearable_razorback",
			"tf_weapon_jar",
			"tf_weapon_jar_gas",
			"tf_weapon_jar_milk",
			"tf_weapon_medigun",
			"tf_weapon_builder",
			"tf_weapon_sapper"
		]
	}
	CLIP_SIZE_UPGRADE = {
		attribute = "clip size bonus"
		cap = 2.50
		increment = 0.25
		cost = 200
		default_value = 1
		only_allow_weapons = []
		disallowed_weapons = [
			"slot2",
			"tf_weapon_flamethrower",
			"tf_weapon_buff_item",
			"tf_wearable",
			"tf_wearable_demoshield",
			"tf_wearable_razorback",
			"tf_weapon_jar",
			"tf_weapon_jar_gas",
			"tf_weapon_jar_milk",
			"tf_weapon_medigun",
			"tf_weapon_builder",
			"tf_weapon_sapper"
		]
	}
	CLIP_SIZE_ATOMIC_UPGRADE = {
		attribute = "clip size upgrade atomic"
		cap = 10.0
		increment = 2
		cost = 200
		default_value = 0
		only_allow_weapons = [
			"tf_weapon_rocketlauncher",
			"tf_weapon_rocketlauncher_directhit",
			"tf_weapon_particle_cannon",
			"tf_weapon_rocketlauncher_airstrike",
			"tf_weapon_grenadelauncher",
			"tf_weapon_cannon",
			"tf_weapon_crossbow"
		]
		disallowed_weapons = []
	}
} */

local BOT_BODY_UPGRADES = {
	HEALTH_UPGRADE = {
		attribute = "max health additive bonus"
		cap = 5000
		increment = 50
		cost = 300
		default_value = 0
	}
	BULLET_RES_UPGRADE = {
		attribute = "dmg taken from bullets reduced"
		cap = 0.25
		increment = -0.25
		cost = 300
		default_value = 1
	}
	BLAST_RES_UPGRADE = {
		attribute = "dmg taken from blast reduced"
		cap = 0.25
		increment = -0.25
		cost = 300
		default_value = 1
	}
	FIRE_RES_UPGRADE = {
		attribute = "dmg taken from fire reduced"
		cap = 0.25
		increment = -0.25
		cost = 300
		default_value = 1
	}
	CRIT_RES_UPGRADE = {
		attribute = "dmg taken from crit reduced"
		cap = 0.1
		increment = -0.30
		cost = 200
		default_value = 1
	}
	MELEE_RES_UPGRADE = {
		attribute = "dmg from melee increased"
		cap = 0.25
		increment = -0.25
		cost = 200
		default_value = 1
	}
	SPEED_UPGRADE = {
		attribute = "move speed bonus"
		cap = 1.5
		increment = 0.1
		cost = 100
		default_value = 1
	}
	UNIVERSAL_FIRE_RATE_UPGRADE = {
		attribute = "halloween fire rate bonus"
		cap = 0.2
		increment = -0.2
		cost = 250
		default_value = 1
	}
	UNIVERSAL_RELOAD_SPEED_UPGRADE = {
		attribute = "halloween reload time decreased"
		cap = 0.1
		increment = -0.15
		cost = 200
		default_value = 1
	}
}

function setup_levels()
{
	local scope = GetScope(gamerules)
	scope.Currency <- LEVEL_STARTING_CURRENCY
	scope.Level <- 1
	scope.NextLevelTime <- Time() + LEVEL_UP_TIME
	scope.think <- function() {
		if(GetRoundState() != 4)
			return 0.25

		if(this.NextLevelTime >= Time())
			return 0.25

		this.NextLevelTime = Time() + LEVEL_UP_TIME

		this.Currency += LEVEL_UP_REWARD
		this.Level++
		PrintToHudAll("The Bots have Leveled Up!")
		EmitSoundEx({
			sound_name = "ui/duel_challenge.wav"
		})
		/* SendGlobalGameEvent("teamplay_broadcast_audio", {
			team = 0,
			sound = "ui/duel_challenge.wav",
			additional_flags = 0,
			player = -1
		}) */
		return 0.25
	}
	AddThinkToEnt(gamerules, "think")
}

// PrecacheSound("ui/duel_challenge.wav")
::upgrades <- {

	function OnGameEvent_mvm_begin_wave(params)
	{
		// TESTING ONLY
		GetListenServerHost().AddCustomAttribute("CARD: damage bonus", 100, -1)
		GetListenServerHost().AddCustomAttribute("dmg taken increased", 0.01, -1)
		GetListenServerHost().AddCustomAttribute("health regen", 500, -1)
		GetListenServerHost().AddCustomAttribute("mod see enemy health", 1, -1)
		GetListenServerHost().AddCustomAttribute("faster reload rate", 0, -1)
		GetListenServerHost().AddCustomAttribute("fire rate bonus", 0.25, -1)
		GetListenServerHost().AddCustomAttribute("Blast radius increased", 3, -1)
		GetListenServerHost().AddCustomAttribute("Projectile speed increased", 3, -1)
		GetListenServerHost().AddCustomAttribute("maxammo primary increased", 4, -1)
		GetListenServerHost().AddCustomAttribute("ammo regen", 1, -1)
		GetListenServerHost().AddCustomAttribute("move speed bonus", 2.5, -1)
	}
	function OnGameEvent_post_inventory_application(params)
	{
		local player = GetPlayerFromUserID(params.userid)
		if(!IsPlayerABot(player))
			return

		if(!player.IsAlive())
			return

		if(player.HasBotTag("Upgraded"))
			return

		player.ValidateScriptScope()
		local scope = player.GetScriptScope()
		scope.currency <- GetScope(gamerules).Currency
		scope.lvl <- GetScope(gamerules).Level

		player.AddBotTag("Upgraded")

		local BROKE_AS_FUCK = false
		while (scope.currency >= 100 || BROKE_AS_FUCK == true)
		{
			foreach (upgrade in BOT_BODY_UPGRADES)
			{
				if(scope.currency <= 100)
				{
					BROKE_AS_FUCK = true
					break
				}

				if(upgrade.cost >= scope.currency)
					continue

				if(player.GetCustomAttribute(upgrade.attribute, upgrade.default_value) == upgrade.cap)
					continue

				if(upgrade.increment < 0)
				{
					if((player.GetCustomAttribute(upgrade.attribute, upgrade.default_value) + upgrade.increment) < upgrade.cap)
					{
						player.AddCustomAttribute(upgrade.attribute, upgrade.cap, 0)
						scope.currency = scope.currency - upgrade.cost
					}
					else
					{
						player.AddCustomAttribute(upgrade.attribute, (player.GetCustomAttribute(upgrade.attribute, upgrade.default_value) + upgrade.increment), 0)
						scope.currency = scope.currency - upgrade.cost
					}
				}
				else
				{
					if((player.GetCustomAttribute(upgrade.attribute, upgrade.default_value) + upgrade.increment) > upgrade.cap)
					{
						player.AddCustomAttribute(upgrade.attribute, upgrade.cap, 0)
						scope.currency = scope.currency - upgrade.cost
					}
					else
					{
						player.AddCustomAttribute(upgrade.attribute, (player.GetCustomAttribute(upgrade.attribute, upgrade.default_value) + upgrade.increment), 0)
						scope.currency = scope.currency - upgrade.cost
					}
				}

				//testing
				printl(format("%s Bought \"%s\", for %i$ | Robot has %i$ left",
				player.tostring(),
				upgrade.attribute,
				upgrade.cost,
				scope.currency
				))

				if(scope.currency <= 100)
				{
					BROKE_AS_FUCK = true
					break
				}

			}
			if(scope.currency <= 100)
			{
				BROKE_AS_FUCK = true
				break
			}
			/* foreach (upgrade in BOT_WEAPON_UPGRADES)
			{
				if(upgrade.cost >= scope.currency)
					continue


				foreach (weapon in player.GetAllValidWeapons())
				{
					if(weapon.GetAttribute(upgrade.attribute, upgrade.default_value) == upgrade.cap)
						continue

					if(!CanWeaponBuyThisUpgrade(weapon, upgrade))
						continue

					if(upgrade.increment < 0)
					{
						if((weapon.GetAttribute(upgrade.attribute, upgrade.default_value) + upgrade.increment) < upgrade.cap)
						{
							weapon.AddAttribute(upgrade.attribute, upgrade.cap, 0)
							scope.currency = scope.currency - upgrade.cost
						}
						else
						{
							weapon.AddAttribute(upgrade.attribute, weapon.GetAttribute(upgrade.attribute, upgrade.default_value), 0)
							scope.currency = scope.currency - upgrade.cost
						}
					}
					else
					{
						if((weapon.GetAttribute(upgrade.attribute, upgrade.default_value) + upgrade.increment) > upgrade.cap)
						{
							weapon.AddAttribute(upgrade.attribute, upgrade.cap, 0)
							scope.currency = scope.currency - upgrade.cost
						}
						else
						{
							weapon.AddAttribute(upgrade.attribute, weapon.GetAttribute(upgrade.attribute, upgrade.default_value), 0)
							scope.currency = scope.currency - upgrade.cost
						}
					}
				}

				//testing
				printl(format("%s Bought \"%s\", for %i$ | Robot has %i$ left",
					player.tostring(),
					upgrade.attribute,
					upgrade.cost,
					scope.currency
				))
			} */
		}
		player.SetHealth(player.GetMaxHealth())
	}
	function OnGameEvent_player_death(params)
	{
		local victim = GetPlayerFromUserID(params.userid)
		if(!IsPlayerABot(victim))
			return

		foreach (human in GetEveryHuman())
		{
			human.AddCurrency(GetScope(victim).lvl * LEVEL_KILL_REWARD /* + LEVEL_KILL_BASE */)
		}
	}
}
__CollectGameEventCallbacks(upgrades)

function CanWeaponBuyThisUpgrade(weapon, upgrade)
{
	if(weapon == null)
		return false

	if(upgrade.only_allow_weapons.len() == 0)
	{
		foreach (name in upgrade.disallowed_weapons)
		{
			if(startswith(name, "slot"))
			{
				local split = split(name, "t")
				printl(split[0])
				printl(split[1])
				if(weapon.GetSlot() == split[1])
				{
					return false
				}
			}
			else if(weapon.GetClassname() == name)
			{
				return false
			}
		}
		return true
	}
	else
	{
		foreach (name in upgrade.only_allow_weapons)
		{
			if(startswith(name, "slot"))
			{
				local split = split(name, "t")
				printl(split[0])
				printl(split[1])
				if(weapon.GetSlot() != split[1])
				{
					return false
				}
			}
			else if(weapon.GetClassname() == name)
			{
				return false
			}
		}
		return false
	}
}