if(!("SetLibraryVersion" in getroottable()) || ("FatCatLibForce" in ROOT && FatCatLibForce == true))
	IncludeScript("fatcat_library")
SetScriptVersion("Abilities", "3.0.0")

::Debug_Abilities <- false

// Base
// - - - - - - - - - Base - - - - - - - - - |
local BASE_spawn_cooldown = 5            // |
local BASE_attack_cooldown = 5           // |
// - - - - - - - - - - - - - - - - - - - - -|
// Scout
// Soldier
// Pyro
// Demoman
// Heavy
// - - - - - - - - - Rage - - - - - - - - - |
::RageSettings <- {
	SpawnCooldown 	= 180.0
	AttackCooldown 	= 105.0
	BombRange 		= 75.0
	ExplodeDmg 		= 750000.0
	ExplodeRad 		= 500.0
	ExplodeDmgSmall = 40000.0
	ExplodeRadSmall = 500.0
	CondDuration 	= 12.0
}
// - - - - - - - - - - - - - - - - - - - - -|
// Engineer
// Medic
// Sniper
// Spy
// Multi-Class
// - - - - - - - -  CHEERS  - - - - - - - - |
::CheersSettings <- {
	SpawnCooldown  = 20.0
	AttackCooldown = 75.0
	HealthMult     = 10.0
	Duration       = 20.0
	UseTimes       = array(TF_CLASS_MAXNORMAL+1, 4.0)
}
// CheersSettings.UseTimes[TF_CLASS_SCOUT] 		= 4.0
// CheersSettings.UseTimes[TF_CLASS_SOLDIER] 		= 4.0
CheersSettings.UseTimes[TF_CLASS_PYRO] 			= 3.85
CheersSettings.UseTimes[TF_CLASS_DEMOMAN] 		= 4.4
// CheersSettings.UseTimes[TF_CLASS_ENGINEER] 		= 4.0
CheersSettings.UseTimes[TF_CLASS_MEDIC] 		= 3.9
CheersSettings.UseTimes[TF_CLASS_HEAVYWEAPONS] 	= 4.1
CheersSettings.UseTimes[TF_CLASS_SNIPER] 		= 3.15
// CheersSettings.UseTimes[TF_CLASS_SPY] 			= 4.0
// - - - - - - - - - - - - - - - - - - - - -|
// - - - - - - - -   KART   - - - - - - - - |
::KartSettings <- {
	SpawnCooldown  = 30.0
	AttackCooldown = 75.0
	Duration       = 25.0
	UseTimes       = array(TF_CLASS_MAXNORMAL+1, 2.75)
}
// KartSettings.UseTimes[TF_CLASS_SCOUT] 			= 2.75
// KartSettings.UseTimes[TF_CLASS_SOLDIER] 		= 2.75
// KartSettings.UseTimes[TF_CLASS_PYRO] 			= 2.75
KartSettings.UseTimes[TF_CLASS_DEMOMAN] 		= 3.75
// KartSettings.UseTimes[TF_CLASS_ENGINEER] 		= 2.75
KartSettings.UseTimes[TF_CLASS_MEDIC] 			= 2.6
KartSettings.UseTimes[TF_CLASS_HEAVYWEAPONS] 	= 2.6
KartSettings.UseTimes[TF_CLASS_SNIPER] 			= 2.2
// KartSettings.UseTimes[TF_CLASS_SPY] 			= 2.75
// - - - - - - - - - - - - - - - - - - - - -|

//TODO: ADD SETTINGS FOR BAZAAR
function AbilityValid(player, player_class, idx)
{
	if(!player.IsAlive())
		return false
	if(!player.HasWeapon(idx))
		return false
	if(player_class > TF_CLASS_UNDEFINED && player_class < TF_CLASS_MAXNORMAL)
	{
		return player.GetPlayerClass() == player_class
	}
	return true
}

/**
 * Sets up the ability think for the weapon
 * 
 * @param {entity}		weapon 			The weapon to apply the ability to.
 * @param {float}		amount 			The Abilitys spawn cooldown or Damage needed amount when created.
 * @param {int}			type 			The Type of Ability This is.
 * @param {string}		name 			The NonTranslated name of the weapon.
 * @param {short}		player_class 	Which Class the player needs to be to use the ability (TF_CLASS_UNDEFINED or > TF_CLASS_MAXNORMAL to ignore).
 * @param {short}		idx				The ItemDefIndex of the Weapon.
 * @param {table}		text_parms		Table of Text parameters for the GlobalGameText.
 * @param {function}	ability_func	Function to use when the Ability is used
 */
function CreateAbility(weapon, amount, type, name, player_class, idx, text_parms, ability_func) {
	local scope = GetScope(weapon)
	if(type == ABILITY_TIME)
		weapon.SetAbilityTime(Time() + amount)
	else 
		weapon.SetAbilityDamage(amount.tofloat())
	weapon.SetAbilityType(type)

	scope.AbilityType <- type
	scope.WeaponIDX <- idx
	scope.PlayerClass <- player_class
	scope.TranslationName <- name
	scope.AbilityFunc <- ability_func

	scope.AbilityThink <- function() 
	{
		if(!self.IsValid())
			return 500

		local player = self.GetOwner()

		if ( player.IsAdmin() && Debug_Abilities)
		{
			local message = "Variable list:\n"
			foreach(k, v in this)
			{
				if(type(v) == "function")
					continue
				if (!startswith(k, "__"))
					message += (k + " : " + v + "\n")
			}
			player.PrintToHud(message)
		}

		if(!AbilityValid(player, PlayerClass, WeaponIDX))
			return 1.0

		// Setup Text
		local text_msg = ""
		if(!player.IsTaunting())
		{
			if(AbilityType == ABILITY_TIME)
			{
				if (self.IsAbilityReady()) 
					text_msg = player.GetTranslatedAndFormattedString("ABILITY_READY", "%T"+TranslationName)
				else 
					text_msg = player.GetTranslatedAndFormattedString("ABILITY_CHARGING", "%T"+TranslationName, player.GetTranslatedAndFormattedString("ABILITY_CHARGING_MSG", (Timestamp-Time()).tointeger().tostring()))
			}
			else if (AbilityType == ABILITY_DAMAGE)
			{
				if (self.IsAbilityReady()) 
					text_msg = player.GetTranslatedAndFormattedString("ABILITY_READY", "%T"+TranslationName)
				else 
					text_msg = player.GetTranslatedAndFormattedString("ABILITY_CHARGING", "%T"+TranslationName, player.GetTranslatedAndFormattedString("ABILITY_CHARGING_D_MSG", ( ( CurrentDamage / DamageNeeded ).tofloat() * 100 ).tointeger().tostring()))
			}
		}
		player.DisplayHudText(text_msg, text_parms.color, [text_parms.x, text_parms.y])

		//////////
		// MAIN //
		//////////
		if (player.IsUsingActionSlot() && player.IsOnGround() && player.GetActiveWeaponIDX() == WeaponIDX && self.IsAbilityReady())
		{
			if(AbilityType == ABILITY_TIME)
				self.AddAbilityTime(10) // only if the ability fails / was not set, or if we want to run a function with a delay, I.E. the below
			else if (AbilityType == ABILITY_DAMAGE)
				self.ResetAbilityDamage()
			this.AbilityFunc()
		}
		return 0.1
	}
	AddThinkToEnt(weapon, "AbilityThink")
}

::AbilityEvents <- {
	function OnScriptEvent_HumanResupply(params)
	{
		local player = params.player

		local Primary 	= player.GetWeaponInSlotNew(SLOT_PRIMARY)
		local Secondary = player.GetWeaponInSlotNew(SLOT_SECONDARY)
		local Melee 	= player.GetWeaponInSlotNew(SLOT_MELEE)

		ClearThinks(Primary)
		ClearThinks(Secondary)
		ClearThinks(Melee)

		local IDXS = player.GetAbilityWeaponIDXs()

		if( IDXS == null )
			return

		foreach (idx in IDXS)
		{
			switch (idx)
			{
				case TF_ABILITY_HEAVY_RAGE:
				{
					CreateAbility(Melee, RageSettings.SpawnCooldown, ABILITY_TIME, "MEGACRUSH", TF_CLASS_HEAVYWEAPONS, TF_ABILITY_HEAVY_RAGE, {x = 0.75, y = 0.75, color = "255 25 5"}, function() {
						local player = self.GetOwner()
						player.ForceTaunt(TF_TAUNT_UNLEASHED_RAGE)

						if (GetFlagStatus(FindByClassnameWithin(null, "item_teamflag", player.GetOrigin(), RageSettings.BombRange)) == FLAG_DROPPED) 
							player.SetCond(TF_COND_MARKEDFORDEATH, 2.55)

						player.SetCond(TF_COND_IMMUNE_TO_PUSHBACK, 2.75)
						player.SetCond(TF_COND_STUNNED, 2.55)

						RunWithDelay(@() HeavyGoKaboom(player), 2.55)
					})
					break
				}
				case TF_ABILITY_CHEERS:
				{
					CreateAbility(Melee, CheersSettings.SpawnCooldown, ABILITY_TIME, "VITALRESURGENCE", TF_CLASS_UNDEFINED, TF_ABILITY_CHEERS, {x = 0.75, y = 0.75, color = "21 124 235"}, function() {
						local player = self.GetOwner()
						player.ForceTaunt(TF_TAUNT_CHEERS)

						RunWithDelay(@() GiveMeThyHealth(player), CheersSettings.UseTimes[player.GetPlayerClass()])
					})
					break
				}
				case TF_ABILITY_KART:
				{
					CreateAbility(Melee, KartSettings.SpawnCooldown, ABILITY_TIME, "VEHICULARMANNSLAUGHTER", TF_CLASS_UNDEFINED, TF_ABILITY_KART, {x = 0.7, y = 0.75, color = "95 25 255"}, function() {
						local player = self.GetOwner()
						player.ForceTaunt(TF_TAUNT_SECOND_RATE_SORCERY)

						RunWithDelay(@() SummonLasKart(player), KartSettings.UseTimes[player.GetPlayerClass()])
					})
					break
				}
				case TF_ABILITY_BAZARR:
				{
					player.PrintToHud("Hi")
					CreateAbility(Primary, 10000, ABILITY_DAMAGE, "TEST", TF_CLASS_SNIPER, TF_ABILITY_BAZARR, {x = 0.75, y = 0.65, color = "230 120 120"}, function() {
						local player = self.GetOwner()

						GetScope(player).PrimaryAbilityActive <- true
						GetScope(Primary).AbilityActive <- true
						// (player, health, scale, duration, broken_shit)
						MedShieldMakes(player, 100000, 0.666, 25.0, true)
					})
					if(player.DiedWithAbility() && "RetainAbilityCharge" in GetScope(player))
					{
						Primary.SetAbilityDamage(GetScope(Primary).DamageNeeded, GetScope(Primary).DamageNeeded/(100.0 / GetScope(player).RetainAbilityCharge))
						// printf("Added %f damage\n", GetScope(Primary).DamageNeeded/(100.0 / GetScope(player).RetainAbilityCharge))
						delete GetScope(player).DiedWithAbility
						delete GetScope(player).RetainAbilityCharge
					}
					break
				}
			}
		}
	}
	function OnScriptEvent_PostHumanHurt(params)
	// function OnScriptEvent_PostBotHurt(params)
	{
		local victim = params.victim
		local attacker = params.attacker

		if(!attacker || attacker.IsBot() || attacker.IsDead())
			return

		if(attacker.GetAbilityWeapons() == null)
			return


		foreach (ability in attacker.GetAbilityWeapons())
		{
			if(ability.GetAbilityType() != ABILITY_DAMAGE)
				continue
			if(ability.IsAbilityActive())
				continue
			ability.AddAbilityDamage(params.damage)

			// PrintToHudAll(format("Ability is now at %.2f dmg out of %.2f\n", GetScope(ability).CurrentDamage, GetScope(ability).DamageNeeded))
		}
	}
	function OnScriptEvent_HumanDeath(params)
	{
		local victim = params.victim
		local attacker = params.attacker

		if(!attacker/*  || !attacker.IsBot() */)
			return

		if(victim.GetAbilityWeapons() == null)
			return

		local scope = GetScope(victim)

		if("Shield" in scope && scope.Shield && scope.Shield.IsValid())
		{
			scope.Shield.Destroy()
			scope.Shield <- null
		}

		foreach (ability in victim.GetAbilityWeapons())
		{
			local wep_scope = GetScope(ability)

			if(ability.IsAbilityActive())
			{
				wep_scope.AbilityActive <- false
				scope.DiedWithAbility <- true
			}

			scope.RetainAbilityCharge <- (MATH.Min(ability.GetAbilityDamage(), wep_scope.DamageNeeded)/2.0 / wep_scope.DamageNeeded ).tofloat() * 100.0
			printf("Retatainted Damage %% %.0f\n", scope.RetainAbilityCharge)
			if(scope.RetainAbilityCharge < 1.0)
			{
				delete scope.DiedWithAbility
				delete scope.RetainAbilityCharge
			}
		}
	}
}
__CollectGameEventCallbacks(AbilityEvents)

function HeavyGoKaboom(player)
{
	if (!player.IsAlive()) return
	if (!player.IsTaunting()) return

	if (player.GetAbilityWeapon() == null) return

	player.AddAbilityTime(RageSettings.AttackCooldown + 0.2) // cancel taunt delay

	player.RunScriptCode("CancelTaunt()", 0.1)
	player.RunScriptCode("SetCond(TF_COND_CRITBOOSTED, RageSettings.CondDuration)", 0.1)
	player.RunScriptCode("SetCond(TF_COND_DEFENSEBUFF, RageSettings.CondDuration)", 0.1)
	player.RunScriptCode("SetCond(TF_COND_REGENONDAMAGEBUFF, RageSettings.CondDuration)", 0.1)

	PrecacheSound("weapons/airstrike_small_explosion_02.wav")
	PrecacheSound("items/cart_explode.wav")

	local bomb = FindByClassnameWithin(null, "item_teamflag", player.GetOrigin(), RageSettings.BombRange)
	if (GetFlagStatus(bomb) == FLAG_DROPPED)
	{
		DispatchParticleEffect("hightower_explosion", bomb.GetOrigin(), QAngle(-90, 0, 0).Forward())
		bomb.EmitSound("items/cart_explode.wav")

		player.TakeDamage(RageSettings.ExplodeDmg, 0, player)
		player.DamageEveryBotWithin(RageSettings.ExplodeRad, RageSettings.ExplodeDmg)
		player.DamageEveryTankWithin(RageSettings.ExplodeRad, RageSettings.ExplodeDmg)
		bomb.AcceptInput("ForceReset", "", player, player)
	}
	else
	{
		DispatchParticleEffect("ExplosionCore_Wall", (player.GetOrigin() + Vector(0,0,10)), QAngle(-90, 0, 0).Forward())
		player.EmitSound("weapons/airstrike_small_explosion_02.wav")

		player.DamageEveryBotWithin(RageSettings.ExplodeRadSmall, RageSettings.ExplodeDmgSmall)
		player.DamageEveryTankWithin(RageSettings.ExplodeRadSmall, RageSettings.ExplodeDmgSmall)
	}
}
function GiveMeThyHealth(player)
{
	if (!player.IsAlive()) return
	if (!player.IsTaunting()) return

	local weapon = player.GetAbilityWeapon()
	if (weapon == null) return

	if(player.GetHealth() >= player.GetMaxHealth() * CheersSettings.HealthMult)
		return;
	player.SetHealth(player.GetMaxHealth() * CheersSettings.HealthMult)
	player.SetCond(TF_COND_IMMUNE_TO_PUSHBACK, CheersSettings.Duration)
	player.SetCond(TF_COND_GRAPPLINGHOOK_BLEEDING, CheersSettings.Duration)

	player.AddAbilityTime(CheersSettings.AttackCooldown + 3) // + 3 for taunt duration
}
function SummonLasKart(player)
{
	if (!player.IsAlive()) return
	if (!player.IsTaunting()) return

	if (player.GetAbilityWeapon() == null) return

	local trace = {
		start = player.GetOrigin() + Vector(0, 0, 35)
		end = player.GetOrigin() + Vector(0, 0, 35)
		mask = MASK_SOLID
		hullmax = GetPropVector(player, "m_Collision.m_vecMaxs") * 0.975
		hullmin = GetPropVector(player, "m_Collision.m_vecMins") * 0.975
		allsolid = false
		ignore = player
	}
	TraceHull(trace)
	if(trace.allsolid == true)
	{
		player.ForceRespawn()
		player.TranslateToHud("STUCK_RESPAWNED")
		return
	}

	player.SetAbsOrigin(player.GetOrigin() + Vector(0, 0, 35))
	player.SetCond(TF_COND_HALLOWEEN_KART, KartSettings.Duration)
	player.SetCond(TF_COND_HALLOWEEN_QUICK_HEAL, KartSettings.Duration)
	player.SetCond(TF_COND_INVULNERABLE_HIDE_UNLESS_DAMAGED, KartSettings.Duration)
	player.SetCond(TF_COND_HALLOWEEN_TINY, 0)
	player.SetScale(1.0)
	player.CancelTaunt()

	player.AddAbilityTime(KartSettings.AttackCooldown)
}
function MedShieldMakes(player, health = 100000, scale = 1.0, duration = 15.0, center_cross = false, scene = false)
{
	//TODO: Spawn Sound
	if(scene)
		player.PlayScene(scene, 0.0)
		// "scenes/Player/Heavy/low/3977.vcd"	
	// local shield = SpawnEntityFromTable("obj_teleporter", {})
	// local shield = CreateByClassname("entity_medigun_shield")
	local shield = SpawnEntityFromTable("entity_medigun_shield", { spawnflags = 1 })
	local shield_scope = GetScope(shield)
	local player_scope = GetScope(player)


	// shield.DispatchSpawn()

	player_scope.Shield <- shield
	player_scope.PrimaryAbilityActive <- true
	shield.SetOwner(player)
	shield.SetTeam(player.GetTeam())
	shield.SetSkin(player.GetTeam() == TF_TEAM_RED ? 0 : 1)

	shield_scope.kill_time <- Time() + duration
	shield_scope.UseCrosshairHeight <- center_cross

	// shield.SetCollisionGroup(TFCOLLISION_GROUP_COMBATOBJECT)
	// shield.SetEFlags(shield.GetEFlags() | EFL_DONTBLOCKLOS)
	SetPropInt(shield, "m_fEffects", EF_NOSHADOW|EF_NORECEIVESHADOW)

	/* if(health)
		shield.AcceptInput("SetHealth", health.tostring(), null, null)
	else
		SetPropInt(shield, "m_takedamage", DAMAGE_NO) */

	shield.SetSolid(SOLID_OBB)
	
	shield.SetAbsOrigin(Vector(0, 0, -20000))

	shield.SetModelScale(scale, 0)

	shield.SetSize(shield.GetBoundingMins()*scale, shield.GetBoundingMaxs()*scale)

	// shield.SetModel("models/props_mvm/mvm_player_shield.mdl")
	// thickness, width, height
	// shield.SetSize(Vector(-75,-120*scale, -10), Vector(15, 120*scale, 175*scale))
	// shield.SetModelScale(scale, 0.0)
	AddThinkToEnt(shield, "MedShieldThink")
}
function MedShieldThink()
{
	local player = self.GetOwner()
	if(!self || !self.IsValid())
	{
		GetScope(player).Shield <- null
		return 500
	}
	local vecForward = player.EyeAngles().Forward()
	vecForward.z = 0.0

	// shield.SetSize(shield.GetBoundingMins()*scale, shield.GetBoundingMaxs()*scale)

	player.PrintToHud(format("%s\n%s\n\n", self.GetBoundingMinsOriented().ToKVString(), self.GetBoundingMaxsOriented().ToKVString(),
	self.GetBoundingMins().ToKVString(), self.GetBoundingMaxs().ToKVString()))

	// player.PrintToHud("9.8")

	local origin = player.GetOrigin() + (vecForward * (130.0*self.GetModelScale())) + Vector(0, 0, UseCrosshairHeight ? self.GetModelScale()*(player.IsCrouching() ? 0 : 50) : 0)
	local angle = QAngle(0, player.EyeAngles().y, 0)
	self.Teleport(true, origin, false, QAngle(), false, Vector())
	self.SetAbsAngles(angle)

	// ShowOBB(self, Vector4D(255, 0, 0, 5), 0.033)
	if(Time() >= kill_time || player.IsDead())
	{
		if(self && self.IsValid())
		{
			GetScope(player).Shield <- null
			// This is Stupid, but i dont want to have to pass in the weapon through multiple different functions
			GetScope(player.GetWeaponInSlotNew(SLOT_PRIMARY)).AbilityActive <- false
			self.Destroy()
		}
		ClearThinks(self)
	}
	return -1
}