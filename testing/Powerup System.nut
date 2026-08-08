class CustomPowerupSystem {
	player = null

	data = null
	data_name = ""

	constructor(_player, name)
	{
		this.player = _player
		this.data = FindPowerupFromName(name)
		this.data_name = name

		data.OnCollect(player)

		player.AddThink(function() {
			local Powerup = CustomPowerup.data

			if (Powerup == null)
				GetScope(self).CustomPowerup <- self.GiveCustomPowerup("None")
				// could be recursive, but idgaf, all hell breaks loose

			self.DisplayHudText(format("Powerup: %s", Powerup.name), "255 100 0", [-1, -1], 0.5, 2)
			return 0.49
		}, "PowerupThink")
	}

	function FindPowerupFromName( name )
	{
		if (name in CustomPowerupData)
			return CustomPowerupData[name]
		else return null
	}

	function Drop()
	{
		if (data)
			data.OnDrop(player)

		// if (player)
			// player.RemoveThink("PowerupThink")
	}
}

function CTFPlayer::GiveCustomPowerup( name, drop = false )
{
	local scope = GetScope(this)
	if ("CustomPowerup" in scope && scope.CustomPowerup != null && drop)
	{
		if ("Drop" in scope.CustomPowerup)
			scope.CustomPowerup.Drop()
	}

	scope.CustomPowerup <- CustomPowerupSystem(this, name)
}

class PowerupData {
	name = ""
	OnCollect = null //@(...) {}
	OnDrop = null // @(...) {}

	constructor(_name, _collect, _drop)
	{
		this.name = _name
		this.OnCollect = _collect
		this.OnDrop = _drop
	}
}

function CTFPlayer::GetCustomPowerupData()
{
	local scope = GetScope(this)
	if (!("CustomPowerup" in scope))
		GiveCustomPowerup("None")

	return scope.CustomPowerup
}
function CTFPlayer::GetCustomPowerup()
{
	local scope = GetScope(this)
	if (!("CustomPowerup" in scope))
		GiveCustomPowerup("None")

	return scope.CustomPowerup.data_name
}

function CTFPlayer::UpdateWeaponStats()
{
	foreach (/**@type {CTFWeaponBase} */weapon in GetAllWeapons())
	{
		weapon.AddAttribute("cannot delete", 1.0, 0) // force an update on the weapon
		weapon.RemoveAttribute("cannot delete")
	}
}

::CustomPowerupData <- {}

function CreateCustomPowerup( name, collect, drop )
{
	if (name in CustomPowerupData)
		printf("There is already a powerup with the name %s\n", name)
	CustomPowerupData[name] <- PowerupData(name, collect, drop)
}

RegisterDamageCallback("player", "CustomPowerupPlayer" function( params ) {
	if (HasCustomFlag(params.damage_custom, TF_DMG_CUSTOM_IGNORE_EVENTS) || params.damage_custom == TF_DMG_CUSTOM_TRIGGER_HURT)
		return

	/** @type {CTFPlayer} */
	local victim 	= params.victim
	/** @type {CTFPlayer|CBaseEntity|null} */
	local attacker 	= params.attacker
	/** @type {CBaseEntity|null} */
	local weapon 	= null
	/** @type {CBaseEntity|null} */
	local inflictor	= params.inflictor
	

	if (!attacker)
		return

	weapon = params.weapon

	if (!attacker || !weapon || !inflictor)
		return

	if ( !(startswith(weapon.GetClassname(), "tf_weapon") || startswith(weapon.GetClassname(), "tf_wearable")) )
		return

	if (victim.IsInvincible())
		return

	local vic_pow = victim.GetCustomPowerup()
	local attack_pow = attacker.GetCustomPowerup()

	if (attack_pow == "Vampire" && params.damage > 0)
	{
		local active = attacker.GetActiveWeapon()
		if (!active)
			attacker.HealPlayer(params.damage)
		else if (active.IsMinigun() || active.IsFlamethrower())
			attacker.HealPlayer(params.damage * 0.6)
		else if (active.IsMeleeWeapon() && vic_pow != "Resistance")
			attacker.HealPlayer(params.damage * 1.25)
		else if (params.damage_type & DMG_BLAST)
		{
			local iMaxHealthOverboost = 120
			if ( ( attacker.GetHealth() - attacker.GetMaxHealth() ) < iMaxHealthOverboost )
			{
				local iMaxHealthToAdd = ( iMaxHealthOverboost + attacker.GetMaxHealth() ) - attacker.GetHealth();
				if ( params.damage < iMaxHealthToAdd )
					attacker.HealPlayer(params.damage, 1.5)
				else
					attacker.HealPlayer(iMaxHealthToAdd, 1.5)
			}
		}
		else
			attacker.HealPlayer(params.damage)
	}
	
	if (vic_pow == "Reflect" && attack_pow != "Resistance" && attack_pow != "Vampire")
	{
		local mult_dmg = params.damage * 0.8
		local ref_victim = attacker

		if (inflictor.GetClassname() == "obj_sentrygun")
		{
			mult_dmg = params.damage
			ref_victim = inflictor
		}

		ref_victim.TakeDamageCustom(victim, victim, victim, Vector(), Vector(), mult_dmg, DMG_SHOCK, TF_DMG_CUSTOM_NO_CALLBACKS_IGNORE)
		if (ref_victim.GetHealth() <= 0)
			ref_victim.SetHealth(1)
	}

	if (attack_pow == "Knockout")
	{
		victim.GetCustomPowerupData().Drop()
		victim.DropFlag(true)
	}

	if (vic_pow == "Plague" && "Plaguer" in GetScope(attacker))
	{
		if (GetScope(attacker).Plaguer == victim)
		{
			if (GetScope(attacker).PlagueTime <= Time() + 5)
			{
				params.damage *= 0.5 //
			}
		}
	}
})

// CreateCustomPowerup("", 
// 	function( /**@type {CTFPlayer}*/player ) {
// 	},
// 	function( /**@type {CTFPlayer}*/player ) {
// 	}
// )

CreateCustomPowerup("None", function( ... ) {}, function(...) {})

CreateCustomPowerup("Strength", 
	function( /**@type {CTFPlayer}*/player ) {
		player.AddCustomAttribute("dmg penalty vs players", 2, 0)
		player.AddCustomAttribute("dmg bonus vs buildings", 2, 0)
	},
	function( /**@type {CTFPlayer}*/player ) {
		player.RemoveCustomAttribute("dmg penalty vs players")
		player.RemoveCustomAttribute("dmg bonus vs buildings")
	}
)

CreateCustomPowerup("Resistance", 
	function( /**@type {CTFPlayer}*/player ) {
		player.AddCustomAttribute("dmg taken increased", 0.5, 0)
		player.AddCustomAttribute("cannot be backstabbed", 1, 0)
	},
	function( /**@type {CTFPlayer}*/player ) {
		player.RemoveCustomAttribute("dmg taken increased")
		player.RemoveCustomAttribute("cannot be backstabbed")
	}
)

// guh, handle in custom event, but here to tell the players it exists
CreateCustomPowerup("Vampire", 
	function( /**@type {CTFPlayer}*/player ) {
		player.AddCustomAttribute("max health additive bonus", 80, 0)
		player.AddCustomAttribute("dmg taken increased", 0.75, 0)

		if (player.GetPlayerClass() == TF_CLASS_SOLDIER || player.GetPlayerClass() == TF_CLASS_DEMOMAN)
		{
			player.AddCustomAttribute("clip size upgrade atomic", 2, 0)
		}
	},
	function( /**@type {CTFPlayer}*/player ) {
		player.RemoveCustomAttribute("max health additive bonus")
		player.RemoveCustomAttribute("dmg taken increased")

		player.RemoveCustomAttribute("clip size upgrade atomic")
	}
)

CreateCustomPowerup("Reflect", 
	function( /**@type {CTFPlayer}*/player ) {
		local cur_hp = player.GetMaxHealth()
		local to_add = 400 - cur_hp

		if (to_add > 0)
			player.AddCustomAttribute("max health additive bonus", to_add, 0)
	},
	function( /**@type {CTFPlayer}*/player ) {
		player.RemoveCustomAttribute("max health additive bonus")
	}
)

CreateCustomPowerup("Haste", 
	function( /**@type {CTFPlayer}*/player ) {
		player.AddCustomAttribute("fire rate bonus", 0.5, 0)
		player.AddCustomAttribute("faster reload rate", 0.25, 0)
		player.AddCustomAttribute("mult_item_meter_charge_rate", 0.5, 0)

		player.AddCustomAttribute("clip size bonus upgrade", 2, 0)
		player.AddCustomAttribute("move speed bonus", 1.3, 0)

		player.AddCustomAttribute("maxammo primary increased", 2, 0)
		player.AddCustomAttribute("maxammo secondary increased", 2, 0)
		player.AddCustomAttribute("maxammo grenades1 increased", 2, 0)

		// this is to not apply so many attribs

		if (player.GetPlayerClass() == TF_CLASS_MEDIC)
		{
			player.AddCustomAttribute("heal rate bonus", 2, 0)
			player.AddCustomAttribute("ubercharge rate bonus", 2, 0)
		}

		if (player.GetPlayerClass() == TF_CLASS_PYRO)
		{
			player.AddCustomAttribute("mult airblast refire time", 0.5, 0)
			if (player.GetWeaponInSlotNew(SLOT_SECONDARY).IsFlaregun())
				player.AddCustomAttribute("faster reload rate", 0.2, 0)
		}

		if (player.GetPlayerClass() == TF_CLASS_SNIPER)
		{
			player.AddCustomAttribute("SRifle Charge rate increased", 0.3333, 0)
			if (player.GetWeaponInSlotNew(SLOT_PRIMARY).IsBow()) // would like to apply single, but idk
				player.AddCustomAttribute("fire rate bonus", 0.4, 0)
		}

		if (player.GetPlayerClass() == TF_CLASS_DEMOMAN)
		{
			player.AddCustomAttribute("sticky arm time bonus", -0.8, 0) // need a mult version
		}

		if (player.GetPlayerClass() == TF_CLASS_ENGINEER)
		{
			player.AddCustomAttribute("maxammo metal increased", 2, 0)
			player.AddCustomAttribute("engy sentry fire rate increased", 0.5, 0)
		}

		player.TeamFortress_SetSpeed()
		player.UpdateWeaponStats()
	}, 
	function( /**@type {CTFPlayer}*/player ) {
		player.RemoveCustomAttribute("fire rate bonus")
		player.RemoveCustomAttribute("faster reload rate")
		player.RemoveCustomAttribute("engy sentry fire rate increased")
		player.RemoveCustomAttribute("mult_item_meter_charge_rate")
		player.RemoveCustomAttribute("mult airblast refire time")
		player.RemoveCustomAttribute("heal rate bonus")
		player.RemoveCustomAttribute("ubercharge rate bonus")

		player.RemoveCustomAttribute("clip size bonus upgrade")
		player.RemoveCustomAttribute("SRifle Charge rate increased")
		player.RemoveCustomAttribute("sticky arm time bonus")

		player.RemoveCustomAttribute("move speed bonus")

		player.RemoveCustomAttribute("maxammo primary increased")
		player.RemoveCustomAttribute("maxammo secondary increased")
		player.RemoveCustomAttribute("maxammo metal increased")
		player.RemoveCustomAttribute("maxammo grenades1 increased")

		player.TeamFortress_SetSpeed()
		player.FixAmmo()

		player.UpdateWeaponStats()
	}
)

CreateCustomPowerup("Regen", 
	function( /**@type {CTFPlayer}*/player ) {
		player.AddThink(function() {
			// fuckass magic
			local percent = MATH.RemapVal((player.GetHealth().tofloat() / player.GetMaxHealth()), 1.0, 0.1 player.GetMaxHealth() / 25, player.GetMaxHealth() / 10)
			player.HealPlayer(percent)
			player.GivePercentPrimaryAmmo(20)
			player.GivePercentSecondaryAmmo(20)
			player.GivePercentMetal(20)

			// heal buildings?
			/* if (player.GetPlayerClass() == TF_CLASS_ENGINEER)
			{
				local buildings = []
				local global_buildings
			} */
			return 0.2
		}, "RegenThink")
	},
	function( /**@type {CTFPlayer}*/player ) {
		player.RemoveThink("RegenThink")
	}
)

CreateCustomPowerup("Precision",
	function( /**@type {CTFPlayer}*/player ) {
		player.AddCustomAttribute("weapon spread bonus", 0.1, 0)

		if (player.GetPlayerClass() == TF_CLASS_SNIPER)
		{
			player.AddCustomAttribute("SRifle Charge rate increased", 0.3333, 0)
			player.AddCustomAttribute("damage bonus", 2, 0) // need primary only
		}

		if (player.GetPlayerClass() == TF_CLASS_SOLDIER || player.GetPlayerClass() == TF_CLASS_DEMOMAN)
		{
			player.AddCustomAttribute("Projectile speed decreased", 3, 0)
			player.AddCustomAttribute("clip size upgrade atomic", 2, 0)
			player.AddCustomAttribute("no self blast dmg", 1, 0)
			player.AddCustomAttribute("dmg falloff decreased", 0.0, 0)
		}
		player.UpdateWeaponStats()
	},
	function( /**@type {CTFPlayer}*/player ) {
		player.RemoveCustomAttribute("weapon spread bonus")
		
		player.RemoveCustomAttribute("SRifle Charge rate increased")
		player.RemoveCustomAttribute("damage bonus")
		
		player.RemoveCustomAttribute("Projectile speed decreased")
		player.RemoveCustomAttribute("clip size upgrade atomic")
		player.RemoveCustomAttribute("no self blast dmg")
		player.RemoveCustomAttribute("dmg falloff decreased")

		player.UpdateWeaponStats()
	}
)

CreateCustomPowerup("Agility", 
	function( /**@type {CTFPlayer}*/player ) {
		player.AddCustomAttribute("move speed bonus", 1.5, 0)

		player.AddCustomAttribute("increased jump height", 1.8, 0)
		player.AddCustomAttribute("cancel falling damage", 1, 0)

		if (player.GetPlayerClass() != TF_CLASS_SPY)
		{
			player.AddCustomAttribute("deploy time decreased", 0.2, 0)
		}

		player.TeamFortress_SetSpeed()
		player.UpdateWeaponStats()
	},
	function( /**@type {CTFPlayer}*/player ) {
		player.RemoveCustomAttribute("move speed bonus")

		player.RemoveCustomAttribute("increased jump height")
		player.RemoveCustomAttribute("cancel falling damage")
		
		player.RemoveCustomAttribute("deploy time decreased")

		player.TeamFortress_SetSpeed()
		player.UpdateWeaponStats()
	}
)

CreateCustomPowerup("Knockout", 
	function( /**@type {CTFPlayer}*/player ) {
		// player.AddCustomAttribute("maxammo primary increased")
		player.Weapon_Switch(player.GetWeaponInSlotNew(SLOT_MELEE))
		player.AddCustomAttribute("disable weapon switch", 1, 0)

		// supposed to be 1.9, since no grapple hook we do about 2.15
		player.AddCustomAttribute("dmg penalty vs players", (140.0 / 65.0), 0) 
		player.AddCustomAttribute("dmg bonus vs buildings", 4, 0) 

		player.AddCustomAttribute("damage force reduction", 0.001, 0)
		player.AddCustomAttribute("airblast vulnerability multiplier", 0.001, 0)


		local hp_add = 175
		local pclass = player.GetPlayerClass()
		switch(pclass)
		{
		case TF_CLASS_SOLDIER:
		case TF_CLASS_MEDIC:
			hp_add = 150
		break
		case TF_CLASS_PYRO:
		case TF_CLASS_HEAVYWEAPONS:
			hp_add = 125
		break
		case TF_CLASS_DEMOMAN:
		{
			hp_add = 150
			if (GetPropBool(player, "m_Shared.m_bShieldEquipped"))
				hp_add += 30
		}
		break
		}

		player.AddCustomAttribute("max health additive bonus", hp_add, 0)

		player.TeamFortress_SetSpeed()
		player.UpdateWeaponStats()
	},
	function( /**@type {CTFPlayer}*/player ) {
		player.RemoveCustomAttribute("disable weapon switch")

		player.RemoveCustomAttribute("dmg penalty vs players")
		player.RemoveCustomAttribute("dmg bonus vs buildings")

		player.RemoveCustomAttribute("damage force reduction")
		player.RemoveCustomAttribute("airblast vulnerability multiplier")
		
		player.RemoveCustomAttribute("max health additive bonus")

		player.TeamFortress_SetSpeed()
		player.UpdateWeaponStats()
	}
)

CreateCustomPowerup("King", 
	function( /**@type {CTFPlayer}*/player ) {
		player.AddCustomAttribute("max health additive bonus", 100, 0)
		player.AddThink(function() {
			player.HealPlayer(MATH.RemapVal((player.GetHealth().tofloat() / player.GetMaxHealth()), 1.0, 0.1 player.GetMaxHealth() / 25, player.GetMaxHealth() / 10) * 0.3)

			local players = GetAllPlayers(player.GetTeam(), 800)

			foreach (/**@type {CTFPlayer} */plr in players)
			{
				plr.AddCustomAttribute("fire rate penalty", 0.75, 1)
				plr.AddCustomAttribute("Reload time increased", 0.75, 1)
				plr.AddCustomAttribute("mult_item_meter_charge_rate", 0.75, 1)

				if (plr.GetPlayerClass() == TF_CLASS_PYRO)
					plr.AddCustomAttribute("mult airblast refire time", 0.75, 1)

				if (plr.GetPlayerClass() == TF_CLASS_ENGINEER)
					plr.AddCustomAttribute("engy sentry fire rate increased", 0.75, 1)

				if (plr.GetPlayerClass() == TF_CLASS_SNIPER)
					plr.AddCustomAttribute("SRifle Charge rate decreased", 0.6666, 1)

				if (plr.GetPlayerClass() == TF_CLASS_MEDIC)
				{
					plr.AddCustomAttribute("ubercharge rate penalty", 1.5, 1)
					plr.AddCustomAttribute("heal rate penalty", 1.5, 1)
				}

				plr.TeamFortress_SetSpeed()
				plr.UpdateWeaponStats()
			}

			return 0.5
		}, "KingThink")
	},
	function( /**@type {CTFPlayer}*/player ) {
		player.RemoveThink("KingThink")
		player.RemoveCustomAttribute("max health additive bonus")
	}
)

CreateCustomPowerup("Plague", 
	function( /**@type {CTFPlayer}*/player ) {
		player.AddCustomAttribute("health from packs increased", 2.0, 0)
		player.AddThink(function() {
			local nearby = GetAllPlayers(player.GetTeam() == TF_TEAM_RED ? TF_TEAM_BLUE : TF_TEAM_RED, 500)

			foreach (/**@type {CTFPlayer}*/plr in nearby)
			{
				if (plr.IsInvincible())
					continue
				if (plr.GetCustomPowerup() == "Resistance" || plr.GetCustomPowerup() == "Vampire")
				plr.TakeDamageCustom(player, player, player, Vector(), Vector(), plr.GetMaxHealth() / 30.0, DMG_GENERIC, TF_DMG_CUSTOM_NO_CALLBACKS_IGNORE)
				GetScope(plr).Plaguer <- player
				GetScope(plr).PlagueTime <- Time()
			}
			return 0.333
		}, "PlagueThink")
	},
	function( /**@type {CTFPlayer}*/player ) {
		player.RemoveThink("PlagueThink")
		player.RemoveCustomAttribute("health from packs increased")
	}
)