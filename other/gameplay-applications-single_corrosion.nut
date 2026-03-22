IncludeScript("fatcat_library")

SetScriptVersion("GamePlayApplications", "1.4.0 --Single Corrosion--")

local Thinker = FindByName(null, "Thinker_GameplayApplications")
if (Thinker == null) Thinker = SpawnEntityFromTable("info_target", { targetname = "Thinker_GameplayApplications" })
AddThinkToEnt(Thinker, "GameplayThink")
PurgeString("GameplayThink")

::TOMISLAV_SETTINGS <- {
	TimeBeforeHeatLost = 7.50
	HeatLostPerSecond = 15
}
::SWIMMING_IDS <- [ TF_WEAPON_TRIBALMANS_SHIV, TF_WEAPON_CANDY_CANE ]

// [11/27/25] what the fuck is this shit!
// i want to just do
// {TF_WEAPON_NEON_ANNIHILATOR = 0.25}
// but no, this shit has to be difficult
::GravityIDS <- {
	"813" : 0.25 // TF_WEAPON_NEON_ANNIHILATOR
	"834" : 0.25 // TF_WEAPON_NEON_ANNIHILATOR_GENUINE
}
::SpellWeapons <- [
	TF_WEAPON_LOLLICHOP, 
	TF_WEAPON_SHORT_CIRCUT, 
	TF_WEAPON_CLAIDHEAMH_MOR, 
	TF_WEAPON_UNARMED_COMBAT,
	///
	"lollichop",
	"short_circuit",
	"tf_projectile_mechanicalarmorb",
	"claidheamohmor",
	"unarmed_combat",
]


::BLUTSAUGER_SETTINGS <- {
	CorrosiveDamage = 250
	// PermannentCorrosion = true
	CorrosionDuration = true // for Permannent Corrosion use true
	CorrosionTickTime = 0.5
	CorrosionAcidPuddleDuration = 15.0
	CorrosivePuddleParticle = "utaunt_spirit_festive_parent"
	GasPuddleThinkDelay = 0.1
	GasPuddleRadius = 75
	CorrosionColor = "205 245 135"
}

::CorrosivePuddleDefaultDuration <- 15.0
::MaxCorrosivePuddles <- 4

::CORROSION_ICON <- CreateKillIcon("infection_acid_puddle")


function GameplayThink()
{
	if ( Players.len() < 1 )
		ReCalculatePlayers()
	
	foreach (player in Players)
	{
		// if we find old/removed instances in list, then, recalculate, and return
		if (!player || !player.IsValid() || player.GetClassname() != "player" )
		{
			ReCalculatePlayers()
			return -1
		}
		EnableStringPurge(player)

		if(IsPlayerABot(player))
			continue

		player.SetGravity(DEFAULT_GRAVITY)
		local meleeIDX = player.GetWeaponIDXInSlotNew(SLOT_MELEE)

		if(IsInArray(meleeIDX, SWIMMING_IDS))
			player.AddCondEx(TF_COND_SWIMMING_NO_EFFECTS, -1, null)
		else
			player.RemoveCondEx(TF_COND_SWIMMING_NO_EFFECTS, true)

		if(meleeIDX.tostring() in GravityIDS)
			player.MultiplyGravity(GravityIDS[meleeIDX.tostring()])

		if(player.GetActiveWeaponIDX() == TF_WEAPON_TOMISLAV)
			player.TranslateToHud("TOMISLAV_HEAT", ("Hits" in GetScope(player.GetActiveWeapon()) ? GetScope(player.GetActiveWeapon()).Hits/10 : -1))


		if(player.GetWeaponIDXInSlotNew(SLOT_PRIMARY) == TF_WEAPON_TOMISLAV)
		{
			local weapon = player.GetWeaponInSlotNew(SLOT_PRIMARY)
			local scope = GetScope(weapon)

			if(IsNotInScope("Hits", scope))
				scope.Hits <- 0
			if(IsNotInScope("m_flLastHeatHit", scope))
				scope.m_flLastHeatHit <- Time()
			if(IsNotInScope("m_flLastHeatLoseTime", scope))
				scope.m_flLastHeatLoseTime <- Time()

			if (scope.Hits >= 1 && 
				scope.m_flLastHeatHit + TOMISLAV_SETTINGS.TimeBeforeHeatLost.tofloat() <= Time() &&
				scope.m_flLastHeatLoseTime + (1.0/TOMISLAV_SETTINGS.HeatLostPerSecond.tofloat()) <= Time())
			{
				scope.m_flLastHeatLoseTime <- Time()
				scope.Hits -= 1
				////////////////////////////////////////////////////////////
				weapon.CalculateAttributeChange(scope.Hits, "damage bonus", 0.008, 1, 9, 1)
				////////////////////////////////////////////////////////////
				weapon.CalculateAttributeChange(scope.Hits, "fire rate bonus", -0.00025, 1, 1, 0.75)
				////////////////////////////////////////////////////////////
				weapon.CalculateAttributeChange(scope.Hits, "max health additive bonus", 1, 0, 1000, 0)
				////////////////////////////////////////////////////////////
				weapon.CalculateAttributeChange(scope.Hits, "maxammo primary increased", 0.002, 1, 3, 1)
				////////////////////////////////////////////////////////////
				weapon.CalculateAttributeChange(scope.Hits, "restore health on kill", 0.1, 0, 100, 0)
				////////////////////////////////////////////////////////////
				weapon.CalculateAttributeChange(scope.Hits, "minigun spinup time decreased", -0.0005, 1, 1, 0.5)
				////////////////////////////////////////////////////////////
				weapon.CalculateAttributeChange(scope.Hits, "weapon spread bonus", -0.00075, 1, 1, 0.25)
				////////////////////////////////////////////////////////////

				weapon.AddAttribute("Set DamageType Ignite", (scope.Hits > 400).tointeger(), 0)
				weapon.AddAttribute("ragdolls become ash", (scope.Hits > 700).tointeger(), 0)
				weapon.AddAttribute("turn to gold", (scope.Hits > 1000).tointeger(), 0)
				if(player.GetPrimaryAmmo() > player.GetMaximumPrimaryAmmo())
					player.ResetPrimaryAmmo()
			}
			if( "Hits" in scope && scope.Hits >= 1000)
				scope.Hits = 1000
		}
	}

	if (player.IsInvincible() || player.InRespawnRoom() || player.IsDead())
	{
		player.ClearCorrosion()
		continue
	}

	local Corrosion = player.GetCorrosion()

	if (Time() >= Corrosion.flCorrosionRemoveTime && !Corrosion.bPermanentCorrosion)
	{
		player.ClearCorrosion()
		continue
	}
	else if (Time() >= Corrosion.flCorrosionTime)
	{
		Corrosion.flCorrosionTime = Time() + Corrosion.flCorrosionTickTime
		player.TakeDamageEx(CORROSION_ICON, Corrosion.hCorrosionAttacker, Corrosion.hCorrosionWeapon, 
			Vector(), Vector(), Corrosion.flCorrosionDmg, DMG_GENERIC | DMG_PREVENT_PHYSICS_FORCE)
		// printf("%s took Corrosion Damage! Attacker : %s, Weapon : %s\n", player.tostring(), Corrosion.hCorrosionAttacker.tostring(), Corrosion.hCorrosionWeapon.tostring())
	}
	foreach (tank in GetEveryTank())
	{
		EnableStringPurge(tank)
		if (tank.GetTeam() != TF_TEAM_PVE_DEFENDERS)
			continue
		if (GetPropBool(tank, "m_bGlowEnabled") == true)
			continue

		EntFireNew(tank, "RunScriptCode", "SetPropBool(self, `m_bGlowEnabled`, true)", 0.1)
	}

	return -1
}

::GameplayEvents <- {
	function OnGameEvent_player_death(params)
	{
		if (!params.attacker) return
		local attacker = GetPlayerFromUserID(params.attacker)
		local victim  = GetPlayerFromUserID(params.userid)
		if (!attacker || IsPlayerABot(attacker)) return

		if (GetPlayerFromUserID(params.userid) == attacker) return // No Self Kills!

		local weaponIDX = params.weapon_def_index
		local logname = params.weapon_logclassname

		/////////////////////////// Wanga Prick ////////////////////////////

		if (weaponIDX == TF_WEAPON_WANGA_PRICK && logname == "voodoo_pin")
			attacker.AddCondEx(TF_COND_STEALTHED_USER_BUFF, 5, attacker)

		/////////////////////////// BlutSauger //////////////////////////////
		// if (logname == "infection_acid_puddle") ) or weaponIDX == TF_WEAPON_BLUTSAUGER 
		// so if i get a kill with corrosion, then logname passes, but if i kill with blutsauger it also passes
		local bCorrosionKill = false
		if(!((victim.GetCorrosionWeapon() && victim.GetCorrosionWeapon().IsValid() && victim.GetCorrosionWeapon().GetIDX() == TF_WEAPON_BLUTSAUGER) || weaponIDX == TF_WEAPON_BLUTSAUGER))
		{
			bCorrosionKill = (logname == "infection_acid_puddle" && victim.GetCorrosionWeapon().IsValid())
		}
		else
		{	// we did hit one of the mentioned above
			bCorrosionKill = true
		}
		if ( bCorrosionKill )
		{
			if(victim.InRespawnRoom())
			{
				victim.ClearCorrosion()
				return
			}

			local puddle_times = []
			local puddles = {}

			foreach (bomb in GetAllEntitiesByTargetname("GasBomb"))
			{
				if(!bomb || !bomb.IsValid())
					return
				
				bomb.ValidateScriptScope() // whaaa, GetScope validates the scope though?
				puddles[format("%.02f", GetScope(bomb).m_flTimeCreated)] <- [bomb, GetScope(bomb).particle]
				puddle_times.append(GetScope(bomb).m_flTimeCreated.tofloat())
			}
			puddle_times.sort(@(a,b) a <=> b)
			foreach (time in puddle_times)
			{
				if(time >= Time() + CorrosivePuddleDefaultDuration)
				{
					// local time = format("%.02f", puddle_times[0])
					local bomb = puddles[format("%.02f", time)][0]
					local particle = puddles[format("%.02f", time)][1]
					if(bomb && bomb.IsValid()) bomb.Destroy()
					if(particle && particle.IsValid()) particle.Destroy()
				}
			}
			if(puddle_times.len() >= MaxCorrosivePuddles)
			{
				local time = format("%.02f", puddle_times[0])
				local bomb = puddles[time][0]
				local particle = puddles[time][1]
				if(bomb && bomb.IsValid()) bomb.Destroy()
				if(particle && particle.IsValid()) particle.Destroy()
			}

			// Create the fucking uhhh, acid puddle?
			local particle = SpawnEntityFromTable("info_particle_system", {
				targetname = "GasParticle"
				effect_name = BLUTSAUGER_SETTINGS.CorrosivePuddleParticle
				start_active = 1
			})
			particle.SetAbsOrigin(victim.GetOrigin() + Vector(0, 0, 5))
			EntFireNew(particle, "RunScriptCode", "self.Destroy()", CorrosivePuddleDefaultDuration)

			// do NOT preserve this entity over rounds
			local temp_think = SpawnEntityFromTable("info_teleport_destination", {targetname = "GasBomb"})
			temp_think.SetAbsOrigin(victim.GetOrigin())
			local scope = GetScope(temp_think)

			scope.weapon <- victim.GetCorrosionWeapon()
			scope.Attacker <- attacker
			scope.m_flTimeCreated <- Time()
			scope.particle <- particle
			scope.think <- function() {
				if(!self || !self.IsValid())
					return 500
				if(!Attacker || !Attacker.IsValid() || m_flTimeCreated + CorrosivePuddleDefaultDuration <= Time() || IsPointInRespawnRoom(self.GetOrigin()))
				{
					particle.Destroy()
					self.Destroy()
					return 500
				}
				foreach(bot in GetEveryBotWithin(self.GetOrigin(), BLUTSAUGER_SETTINGS.GasPuddleRadius))
				{
					if(!Attacker || !Attacker.IsValid() || m_flTimeCreated + CorrosivePuddleDefaultDuration <= Time() || IsPointInRespawnRoom(self.GetOrigin()))
					{
						particle.Destroy()
						self.Destroy()
						return 500
					}
					bot.MakeCorrosion(Attacker, weapon, BLUTSAUGER_SETTINGS.CorrosionDuration, BLUTSAUGER_SETTINGS.CorrosiveDamage, BLUTSAUGER_SETTINGS.CorrosionTickTime)
				}
				return BLUTSAUGER_SETTINGS.GasPuddleThinkDelay
			}
			AddThinkToEnt(temp_think, "think")
			EntFireNew(temp_think, "RunScriptCode", "self.Destroy()", CorrosivePuddleDefaultDuration)
		}
		/////////////////////////// Spell Book //////////////////////////////
		victim.ClearCorrosion()

		if(!IsInArray(weaponIDX, SpellWeapons) || !IsInArray(logname, SpellWeapons))
			return

		local spell_book = attacker.GetSpellBook()
		if (!spell_book) return

		local scope = GetScope(spell_book)

		scope.m_iKills++
		switch (weaponIDX)
		{
			case TF_WEAPON_LOLLICHOP: { spell_book.ModifySpells(TF_SPELL_METEOR, 2, scope.m_iKills, 10) ; return }
			case TF_WEAPON_SHORT_CIRCUT: { spell_book.ModifySpells(TF_SPELL_LIGHTNING, 2, scope.m_iKills, 10) ; return }
			case TF_WEAPON_CLAIDHEAMH_MOR: { spell_book.ModifySpells(TF_SPELL_MONOCULUS, 2, scope.m_iKills, 10) ; return }
			case TF_WEAPON_UNARMED_COMBAT: { spell_book.ModifySpells(TF_SPELL_SKELETON, 2, scope.m_iKills, 10) ; return }
		}
	}
	function OnScriptHook_OnTakeDamage(params)
	{
		local hVictim = params.const_entity
		local hAttacker = params.attacker
		local hWeapon = null
		local hInflictor = params.inflictor

		// Fixes specific damage types not including the weapon, i.e. spells and stomp
		// Also, since modifying weapon in the event info
		// it tells the engine to use that as the weapon, instead of null
		if (params.damage_stats >= TF_DMG_CUSTOM_SPELL_TELEPORT && params.damage_stats <= TF_DMG_CUSTOM_KART)
		{
			local spell_book = hAttacker.GetSpellBook()
			if(spell_book)
				params.weapon = spell_book
			else
				params.weapon = hAttacker.GetWeaponInSlotNew(SLOT_MELEE)
		}
		if (params.damage_stats == TF_DMG_CUSTOM_BOOTS_STOMP)
			params.weapon = hAttacker.GetWeaponInSlotNew(SLOT_SECONDARY)

		hWeapon = params.weapon



		if ( !hVictim || !hAttacker || !hWeapon || !hInflictor ) return

		if ( !(startswith(hWeapon.GetClassname(), "tf_weapon") || startswith(hWeapon.GetClassname(), "tf_wearable"))) return
		if ( hVictim.GetClassname() == "tf_zombie" && params.damage > 5.0) {params.damage = 5.00 ; return}
		if ( !IsValidEnemy(hVictim) || IsPlayerABot(hAttacker) )  return
		if ( hVictim.IsPlayer() ) { if (hVictim.IsInvincible()) return }
		if ( hInflictor.GetClassname() == "infection_acid_puddle" ) return


		switch (params.damage_stats)
		{
			case TF_DMG_CUSTOM_BACKSTAB:
			{
				local iExplosiveShot = hWeapon.GetAttribute("explosive sniper shot", 0)
				if ( iExplosiveShot == 0)
					break

				local base_range = 160
				local additive_range = 20
				local base_damage = 3125

				local flRadiusMult = 1.00
				flRadiusMult *= hWeapon.GetAttribute("Blast radius increased", 1)
				flRadiusMult *= hWeapon.GetAttribute("Blast radius decreased", 1)

				local info = {
					owner = hAttacker
					weapon = hWeapon
					radius = (base_range + (iExplosiveShot * additive_range)) * flRadiusMult
					damage = (iExplosiveShot * base_damage / 1.25)
					center = hVictim.GetOrigin() + Vector(0, 0, 16)
					ignore = [hVictim]
					dmg_Type = DMG_BLAST
					sound = "weapons/barret_arm_fizzle.wav"
					particle = "drg_cow_explosioncore_charged"
				}
				CreateKnifeAoETable(info)
				break
			}

			case TF_DMG_CUSTOM_BOOTS_STOMP: //STOMP
			{
				if (hAttacker.GetAbsVelocity().z > 0) break
				params.damage = hAttacker.GetAbsVelocity().z * -100
				break
			}
			////// Spells
			case TF_DMG_CUSTOM_KART: //BUMPER CAR
			{
				// [11/12/25] Please, dear god, why do i have to do this stupid hack
				params.early_out = true
				hVictim.TakeDamageCustom(params.inflictor, params.attacker, params.weapon, params.damage_force, params.damage_position, 40000, DMG_VEHICLE, TF_DMG_CUSTOM_TRIGGER_HURT)
				if (hVictim.IsPlayer())
				{
					if (hVictim.IsMiniBoss()) return
					hVictim.AddCondEx(TF_COND_MARKEDFORDEATH, 10, hAttacker)
					hVictim.AddCondEx(TF_COND_MVM_BOT_STUN_RADIOWAVE, 10, hAttacker)
				}
				return
			}
			case TF_DMG_CUSTOM_SPELL_SKELETON: //SKELETONS
			{
				params.damage = 8500
				if (hVictim.IsPlayer())
				{
					hVictim.AddCondEx(TF_COND_MARKEDFORDEATH, 10, hAttacker)
				}
				break
			}
			case TF_DMG_CUSTOM_SPELL_MIRV: //MIRV
			{
				params.damage = 15000
				if (hVictim.IsPlayer())
				{
					hVictim.AddCondEx(TF_COND_MARKEDFORDEATH, 10, hAttacker)
				}
				break
			}
			case TF_DMG_CUSTOM_SPELL_METEOR: //METEOR
			{
				params.damage = 3000
				if (hVictim.IsPlayer())
				{
					hVictim.AddCondEx(TF_COND_MARKEDFORDEATH, 10, hAttacker)
				}
				break
			}
			case TF_DMG_CUSTOM_SPELL_LIGHTNING: //LIGHTNING
			{
				params.damage = 5000
				break
			}
			case TF_DMG_CUSTOM_SPELL_FIREBALL: //FIREBALL
			{
				params.damage = 15000
				break
			}
			case TF_DMG_CUSTOM_SPELL_MONOCULUS: //MONOCULUS
			{
				params.damage = 12500
				break
			}
			case TF_DMG_CUSTOM_SPELL_BLASTJUMP: //BLAST JUMP
			{
				params.damage = 22500
				if (hVictim.IsPlayer())
				{
					hVictim.AddCondEx(TF_COND_MARKEDFORDEATH, 10, hAttacker)
				}
				break
			}
			case TF_DMG_CUSTOM_SPELL_BATS: //BATS
			{
				params.damage = 10000
				break
			}

			// TF_DMG_CUSTOM_SPELL_TELEPORT
		}
		switch (hWeapon.GetIDX())
		{
			case TF_WEAPON_TOMISLAV:
			{
				if (hAttacker.GetWeaponIDXInSlotNew(SLOT_PRIMARY) != TF_WEAPON_TOMISLAV) 
					return

				local scope = GetScope(hWeapon)
				if ( IsNotInScope("Hits", scope) )
					scope.Hits <- 0

				scope.Hits++
				scope.m_flLastHeatHit <- Time()
				////////////////////////////////////////////////////////////
				hWeapon.CalculateAttributeChange(scope.Hits, "damage bonus", 0.008, 1, 9, 1)
				////////////////////////////////////////////////////////////
				hWeapon.CalculateAttributeChange(scope.Hits, "fire rate bonus", -0.00025, 1, 1, 0.75)
				////////////////////////////////////////////////////////////
				hWeapon.CalculateAttributeChange(scope.Hits, "max health additive bonus", 1, 0, 1000, 0)
				////////////////////////////////////////////////////////////
				hWeapon.CalculateAttributeChange(scope.Hits, "maxammo primary increased", 0.002, 1, 3, 1)
				////////////////////////////////////////////////////////////
				hWeapon.CalculateAttributeChange(scope.Hits, "restore health on kill", 0.1, 0, 100, 0)
				////////////////////////////////////////////////////////////
				hWeapon.CalculateAttributeChange(scope.Hits, "minigun spinup time decreased", -0.0005, 1, 1, 0.5)
				////////////////////////////////////////////////////////////
				hWeapon.CalculateAttributeChange(scope.Hits, "weapon spread bonus", -0.00075, 1, 1, 0.25)
				////////////////////////////////////////////////////////////
				
				hWeapon.AddAttribute("Set DamageType Ignite", (scope.Hits > 400).tointeger(), 0)
				hWeapon.AddAttribute("ragdolls become ash", (scope.Hits > 700).tointeger(), 0)
				hWeapon.AddAttribute("turn to gold", (scope.Hits > 1000).tointeger(), 0)
				if(hAttacker.GetPrimaryAmmo() > hAttacker.GetMaximumPrimaryAmmo())
					hAttacker.ResetPrimaryAmmo()
				
				if( scope.Hits >= 1000 )
					scope.Hits = 1000
				hWeapon.ReapplyProvision()
				return
			}
			case TF_WEAPON_VITA_SAW:
			{
				if (hAttacker.GetWeaponIDXInSlotNew(SLOT_MELEE) != TF_WEAPON_VITA_SAW) 
					return
				if (!(params.damage_type & DMG_CLUB)) return

				local spell_book = hAttacker.GetSpellBook()
				if (!spell_book) return

				spell_book.ModifySpells(TF_SPELL_HEAL, 5)
				return
			}
			case TF_WEAPON_BLUTSAUGER:
			{
				if ( hAttacker.GetWeaponIDXInSlotNew(SLOT_PRIMARY) != TF_WEAPON_BLUTSAUGER ) 
					return

				if ( hVictim.IsInvincible() || hVictim.InAnyRespawnRoom() )
				{
					hVictim.ClearCorrosion()
					return
				}

				hVictim.MakeCorrosion(hAttacker, hWeapon, 
				BLUTSAUGER_SETTINGS.CorrosionDuration, BLUTSAUGER_SETTINGS.CorrosiveDamage, BLUTSAUGER_SETTINGS.CorrosionTickTime)
				// KEEP THIS COMMENT SO I CAN FIX THIS SHIT LATER
				// printf("Added Corrosion to %s, attacker : %s, weapon : %s\n", hVictim.tostring(), hAttacker.tostring(), hWeapon.tostring())
			}
		}
	}
	function OnGameEvent_post_inventory_application(params)
	{
		local player = GetPlayerFromUserID(params.userid)
		if (player.GetTeam() != TF_TEAM_PVE_DEFENDERS) return

		player.ClearCorrosion()

		SetUsingSpells(true)

		if (player.GetPlayerClass() != TF_CLASS_ENGINEER)
			player.RemoveAllObjects(true)

		local meleeIDX = player.GetWeaponIDXInSlotNew(SLOT_MELEE)
		if(meleeIDX == TF_WEAPON_FIST_OF_STEEL)
		{
			PrecacheModel("models/bots/heavy_boss/bot_heavy_boss.mdl")
			EntFireNew(player, "RunScriptCode", "self.SetForcedTauntCam(1)", 0.1)
			EntFireNew(player, "RunScriptCode", "self.SetCustomModelWithClassAnimations(`models/bots/heavy_boss/bot_heavy_boss.mdl`)", 0.1)

			// get a list of wearables to kill
			local KILLCHILDREN = []
			for (local child = player.FirstMoveChild(); child; child = child.NextMovePeer())
			{
				EnableStringPurge(child)
				if (!startswith(child.GetClassname(), "tf_wearable")) continue
				// do not kill wearables if they are needed for weapons!
				if (child.GetIDX() in WearableIDXs.Primarys || child.GetIDX() in WearableIDXs.Secondarys) continue
				KILLCHILDREN.append(child)
			}
			foreach (child in KILLCHILDREN) child.Kill()
		}
		else
		{
			player.SetCustomModelWithClassAnimations("")
			EntFireNew(player, "RunScriptCode", "self.SetForcedTauntCam(0)", 0.1)
			EntFireNew(player, "RunScriptCode", "self.SetCustomModelWithClassAnimations(``)", 0.1)
		}
		local primary = player.GetWeaponInSlotNew(SLOT_PRIMARY)
		if( primary && primary.getclass() == CTFWeaponBase && primary.GetIDX() == TF_WEAPON_TOMISLAV )
			GetScope(primary).Hits <- 0
	}
	function OnGameEvent_player_spawn(params)
	{
		if (params.team == TF_TEAM_UNASSIGNED)
			return
		
		local player = GetPlayerFromUserID(params.userid)
		if (IsPlayerABot(player))
		{	
			// dont kno why but the bot check sometimes effects players
			if(player.GetTeam() == TF_TEAM_PVE_DEFENDERS)
				return
			if (FatCatLibSettings.KillWatchViewmodels)
			{
				local viewmodel_watch = GetPropEntityArray(player, "m_hViewModel", 1)
				if (viewmodel_watch != null)
				{
					EnableStringPurge(viewmodel_watch)
					EntFireNew(viewmodel_watch, "Kill")
				}
			}
			return
		}

		local primary = player.GetWeaponInSlotNew(SLOT_PRIMARY)
		if( primary && primary.getclass() == CTFWeaponBase && primary.GetIDX() == TF_WEAPON_TOMISLAV )
		{
			primary.AddAttribute("damage bonus", 1, 0)
			primary.AddAttribute("fire rate bonus", 1, 0)
			primary.AddAttribute("max health additive bonus", 0, 0)
			primary.AddAttribute("maxammo primary increased", 1, 0)
			primary.AddAttribute("restore health on kill", 0, 0)
			primary.AddAttribute("minigun spinup time decreased", 1, 0)
			primary.AddAttribute("weapon spread bonus", 1, 0)
			primary.RemoveAttribute("Set DamageType Ignite")
			primary.RemoveAttribute("ragdolls become ash")
			primary.RemoveAttribute("turn to gold")
			primary.ReapplyProvision()
			GetScope(primary).Hits <- 0

			player.ResetHealth()
			player.ResetPrimaryAmmo()
		}

		local book = player.GetSpellBook()
		if( book ) GetScope(book).m_iKills <- 0

		local melee = player.GetWeaponInSlotNew(SLOT_MELEE)
		if( melee && melee.getclass() == CTFWeaponBase && melee.GetIDX() == TF_WEAPON_FIST_OF_STEEL)
		{
			PrecacheModel("models/bots/heavy_boss/bot_heavy_boss.mdl")
			EntFireNew(player, "RunScriptCode", "self.SetForcedTauntCam(1)", 0.1)
			EntFireNew(player, "RunScriptCode", "self.SetCustomModelWithClassAnimations(`models/bots/heavy_boss/bot_heavy_boss.mdl`)", 0.1)

			// get a list of wearables to kill
			local KILLCHILDREN = []
			for (local child = player.FirstMoveChild(); child; child = child.NextMovePeer())
			{
				EnableStringPurge(child)
				if (!startswith(child.GetClassname(), "tf_wearable")) continue
				// do not kill wearables if they are needed for weapons!
				if (child.GetIDX() in WearableIDXs.Primarys || child.GetIDX() in WearableIDXs.Secondarys) continue
				KILLCHILDREN.append(child)
			}
			// KILL EM ALL ( mostly )
			foreach (child in KILLCHILDREN) child.Kill()
		}
	}
}

__CollectGameEventCallbacks(GameplayEvents)