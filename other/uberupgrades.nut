IncludeScript("fatcat_library")

local uu_header = "\x07FFFF00[UU]\x01 "

// Command is
// @buy "upgrade" "amount"

// money multiplier is ( Current Time / UU_MONEY_MULT_TIME ) + 1
const UU_COMMAND_PREFIX = "!"
const UU_MONEY_MULT_TIME = 90
const UU_MONEY_STARTING = 500
const UU_MONEY_STARTING_DEATH_DROP = 50

local WEAPON_UPGRADES = {
	DAMAGE_UPGRADE = {
		attribute = "CARD: damage bonus"
		upgrades = 8
		increment = 0.25
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
		upgrades = 5
		increment = -0.15
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
		upgrades = 6
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
		upgrades = 6
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
		upgrades = 5
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
}

local BODY_UPGRADES = {
	HEALTH_UPGRADE = {
		attribute = "max health additive bonus"
		cap = 5000
		increment = 50
		cost = 300
		default_value = 0
	}
	ALL_RES_UPGRADE = {
		attribute = "dmg taken increased"
		cap = 0.1
		increment = -0.15
		cost = 300
		default_value = 1
	}
/* 	BULLET_RES_UPGRADE = {
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
	} */
	CRIT_RES_UPGRADE = {
		attribute = "dmg taken from crit reduced"
		cap = 0.1
		increment = -0.30
		cost = 200
		default_value = 1
	}
/* 	MELEE_RES_UPGRADE = {
		attribute = "dmg from melee increased"
		cap = 0.25
		increment = -0.25
		cost = 200
		default_value = 1
	} */
	SPEED_UPGRADE = {
		attribute = "move speed bonus"
		cap = 1.5
		increment = 0.1
		cost = 100
		default_value = 1
	}
	PRIMARY_AMMO_UPGRADE = {
		attribute = "maxammo primary increased"
		cap = 3
		increment = 0.25
		cost = 200
		default_value = 1
	}
	SECONDARY_AMMO_UPGRADE = {
		attribute = "maxammo secondary increased"
		cap = 3
		increment = 0.25
		cost = 100
		default_value = 1
	}
}

const UU_CMD = 0
const UU_UPGRADE = 1
const UU_AMOUNT = 2


::upgrade <- {
	function OnGameEvent_player_spawn(params)
	{
		if(params.team == TF_TEAM_UNASSIGNED)
		{
			local player = GetPlayerFromUserID(params.userid)
			local game_scope = GetScope(Gamerules)
			local player_scope = GetScope(player)
			if(IsNotInScope("max_currency", game_scope))
				game_scope.max_currency <- 0
			if(IsNotInScope("currency", player_scope))
				player_scope.currency <- 0


			player_scope.currency <- game_scope.max_currency
		}
	}


	function OnGameEvent_player_say(params)
	{
		local player = GetPlayerFromUserID(params.userid)
		local game_scope = GetScope(Gamerules)
		local player_scope = GetScope(player)

		if(IsNotInScope("max_currency", game_scope))
			game_scope.max_currency <- 0
		if(IsNotInScope("currency", player_scope))
			player_scope.currency <- 0


		local text = split(params.text, " ", true)

		switch (text[UU_CMD])
		{
			case UU_COMMAND_PREFIX + "currency":
			{
				player.PrintToChat(format("%sCurrent Currency: $%i", uu_header, player_scope.currency))
				return
			}
			case UU_COMMAND_PREFIX + "query":
			{
				if(text.len() != 1)
				{
					player.PrintToChat(format("%sWarning Invalid Syntax", uu_header))
					return
				}
				local active = player.GetActiveWeapon()

				local display = format("%sYour Active Weapon has\n", uu_header)
				local defaults = 0
				foreach(upgrade in WEAPON_UPGRADES)
				{
					if(active.GetAttribute(upgrade.attribute, upgrade.default_value) == upgrade.default_value)
					{
						defaults++
						continue
					}
					display += format("%s : %.2f\n", upgrade.attribute, active.GetAttribute(upgrade.attribute, upgrade.default_value))
				}
				if(defaults == WEAPON_UPGRADES.len())
				{
					display = format("%sYou have not bought any Upgrades Yet", uu_header)
				}
				player.PrintToChat(display)
				return
			}
			case UU_COMMAND_PREFIX + "buy":
			case UU_COMMAND_PREFIX + "upgrade":
			{
				if(text.len() != 2)
				{
					player.PrintToChat(format("%sWarning Invalid Syntax", uu_header))
					return
				}
				local upgrade = text[UU_UPGRADE]
				if(!IsWeaponUpgradeValid(upgrade))
				{
					player.PrintToChat(format("%sWarning Upgrade \"\x07B0FFB0%s\x01\" is not a valid upgrade", uu_header, upgrade))
					return
				}

				local table = WeaponUpgadeToTableEntry(upgrade)
				local active = player.GetActiveWeapon()

				if(!CanPlayerAffordUpgrade(player, table))
				{
					player.PrintToChat(format("%sOops. You dont have Enough money to Aford that Upgrade. %i Missing", uu_header, table.cost - player_scope.currency))
					return
				}

				if(!CanWeaponApplyUpgrade(active, table))
				{
					player.PrintToChat(format("%sOops. You Already Maxed that upgrade out!", uu_header))
					return
				}

				ApplyUpgradeToWeapon(active, table)
				DecrementPlayerCurrency(player, table.cost)
				player.PrintToChat(format("%sBought Upgrade %s for %i, $%i Remaining", uu_header, table.attribute, table.cost, player_scope.currency))
				return
			}
			case UU_COMMAND_PREFIX + "pl_buy":
			case UU_COMMAND_PREFIX + "pl_upgrade":
			{
				if(text.len() != 3)
				{
					player.PrintToChat(format("%sWarning Invalid Syntax", uu_header))
					return
				}
				if(!IsplayerUpgradeValid(text[1]))
				{
					player.PrintToChat(format("%sWarning Upgrade \"\x0700300%s\x01\" is not a valid upgrade", uu_header, text[1]))
					return
				}


				return
			}
		}
		
	}

	function OnGameEvent_HumanDeath(params)
	{
		local victim = params.victim
		local attacker = params.attacker

		local GameScope = GetScope(Gamerules)
	}

	function OnGameEvent_player_death(params)
	{
		local victim = GetPlayerFromUserID(params.userid)
		local attacker = GetPlayerFromUserID(params.attacker)

		local scope = GetScope(Gamerules)

		if(IsNotInScope("max_currency", scope))
		{
			scope.max_currency <- 0
		}
		local money = UU_MONEY_STARTING_DEATH_DROP * ( ( Time() / UU_MONEY_MULT_TIME ) + 1 )
		scope.max_currency += money
		PrintToChatAllFilter(format("%sEnemy Player Killed! +$%i", uu_header, money), GetAllPlayers(victim.GetTeam()))
		PrintToChatAllFilter(format("%sA Teammate was Killed! +$%i", uu_header, money), GetAllPlayers(attacker.GetTeam()))
		GiveAllPlayerMoney(money)
	}
}
__CollectGameEventCallbacks(upgrade)

function GiveAllPlayerMoney(money)
{
	foreach (player in GetEveryPlayer())
	{
		if(IsNotInScope("currency", GetScope(player))) 
			GetScope(player).currency <- 0
		GetScope(player).currency += money
	}
}

function DecrementPlayerCurrency(player, amount)
{
	GetScope(player).currency -= amount
}

function ApplyUpgradeToWeapon(weapon, table)
{
	weapon.AddAttribute(table.attribute, weapon.GetAttribute(table.attribute, table.default_value) + table.increment, 0)
	if(weapon.GetAttribute(table.attribute, table.default_value) < (table.upgrades * table.increment))
	{
		weapon.AddAttribute(table.attribute, (table.upgrades * table.increment), 0)
	}
}

function IsWeaponUpgradeValid(name)
{
	switch (name)
	{
		case "damage_bonus":
		case "fire_rate":
		case "clip_size":
		case "reload_rate":
		{
			return true
		}
		default:
		{
			return false
		}
	}
}
function WeaponUpgadeToTableEntry(name)
{
	switch (name)
	{
		case "damage_bonus":
		{
			return WEAPON_UPGRADES.DAMAGE_UPGRADE
		}
		case "fire_rate":
		{
			return WEAPON_UPGRADES.FIRE_RATE_UPGRADE
		}
		case "reload_rate":
		{
			return WEAPON_UPGRADES.RELOAD_SPEED_UPGRADE
		}
		case "clip_size":
		{
			return WEAPON_UPGRADES.CLIP_SIZE_UPGRADE
		}
		case "clip_size_atomic":
		{
			return WEAPON_UPGRADES.CLIP_SIZE_ATOMIC_UPGRADE
		}
		default:
		{
			return null
		}
	}
}

function CanPlayerAffordUpgrade(player, table)
{
	local currency = GetScope(player).currency
	local cost = table.cost
	if(cost <= currency)
		return true
	else 
		return false
}
function CanWeaponApplyUpgrade(weapon, upgrade)
{
	if(weapon.GetAttribute(upgrade.attribute, upgrade.default_value) == (upgrade.upgrades * upgrade.increment) + upgrade.default_value)
	{
		printl(format("value : %.2f is == %.2f", weapon.GetAttribute(upgrade.attribute, upgrade.default_value), (upgrade.upgrades * upgrade.increment) + upgrade.default_value))
		return false
	}

	if(upgrade.increment < 0)
	{
		if(weapon.GetAttribute(upgrade.attribute, upgrade.default_value) <= (upgrade.upgrades * upgrade.increment) + upgrade.default_value)
		{
			printl(format("value : %.2f is <= %.2f", weapon.GetAttribute(upgrade.attribute, upgrade.default_value), (upgrade.upgrades * upgrade.increment) + upgrade.default_value))
			return false
		}
		else
			return true
	}
	else
	{
		if(weapon.GetAttribute(upgrade.attribute, upgrade.default_value) >= (upgrade.upgrades * upgrade.increment) + upgrade.default_value)
		{
			printl(format("value : %.2f is >= %.2f", weapon.GetAttribute(upgrade.attribute, upgrade.default_value), (upgrade.upgrades * upgrade.increment) + upgrade.default_value))
			return false
		}
		else
			return true
	}
}

function IsUpgradeValidForWeapon(weapon, upgrade)
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