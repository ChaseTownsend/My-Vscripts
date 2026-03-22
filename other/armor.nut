IncludeScript("fatcat_library")

function ROOT::CTFPlayer::SetArmor(armor_num)
{
	GetScope(this).armor <- armor_num
}

::MaxArmors <- array(10, 0)
MaxArmors[TF_CLASS_UNDEFINED] 		= -1
MaxArmors[TF_CLASS_SCOUT] 			= 50
MaxArmors[TF_CLASS_SNIPER] 			= 50
MaxArmors[TF_CLASS_SOLDIER] 		= 85
MaxArmors[TF_CLASS_DEMOMAN] 		= 75
MaxArmors[TF_CLASS_MEDIC]		 	= 65
MaxArmors[TF_CLASS_HEAVYWEAPONS] 	= 100
MaxArmors[TF_CLASS_PYRO] 			= 75
MaxArmors[TF_CLASS_SPY] 			= 50
MaxArmors[TF_CLASS_ENGINEER] 		= 50

::PickupArmors <- array(10, 0)
PickupArmors[TF_CLASS_UNDEFINED] 		= -1
PickupArmors[TF_CLASS_SCOUT] 			= 25
PickupArmors[TF_CLASS_SNIPER] 			= 25
PickupArmors[TF_CLASS_SOLDIER] 			= 50
PickupArmors[TF_CLASS_DEMOMAN] 			= 40
PickupArmors[TF_CLASS_MEDIC]		 	= 35
PickupArmors[TF_CLASS_HEAVYWEAPONS] 	= 60
PickupArmors[TF_CLASS_PYRO] 			= 40
PickupArmors[TF_CLASS_SPY] 				= 25
PickupArmors[TF_CLASS_ENGINEER] 		= 25

// reduction for if damage to armor is above armor
// e.x. dmg = 100, armor_change = 25, if armor >= armor_change, dmg_reduction = this val
::Armor_reduc <- 0.75
// multiplier to the formula to for if damage to armor is below armor
// e.x. dmg = 100, armor_change = 25, if armor < armor_change, dmg_reduc = Armor_reduc + ( ( ( ( damage / Armor_dmg_mult ) - armor ) / damage ) * Armor_reduc_mult )
::Armor_reduc_mult <- 1

// De-Magic this value
::Armor_dmg_mult <- 4

// easy examples
// Armor_reduc == 0.5, then Armor_reduc_mult should be 2
// Armor_reduc == 0.75, then Armor_reduc_mult should be 1

::Armor <- {
	function OnGameEvent_post_inventory_application(params) {
		local player = GetPlayerFromUserID(params.userid)
		local scope = GetScope(player)
		scope.armor <- MaxArmors[player.GetPlayerClass()]
		SetPropInt( player, "m_ArmorValue", 0x80000000 )

		local text = FindByName(null, GetPropString(player, "m_szNetname") + " Armor_text")
		if(!text) {
			text = SpawnEntityFromTable("game_text",  {
				targetname = format("%s Armor_text", GetPropString(player, "m_szNetname"))
				message = format("Armor : %i", scope.armor)
				x = -1
				y = 0.75
				color = "0 255 0"
				holdtime = 1 
			})
		}
		local text_scope = GetScope(text)
		text_scope.player <- player
		text_scope.think <- function() {
			if(!player.IsValid())
			{
				ClearThinks(self)
				EntFireByHandle(self, "Kill", null, -1, self, self)
				return 500
			}
			self.KeyValueFromString("message", format("Armor : %i", GetScope(player).armor))
			self.AcceptInput("Display", "", player, player)
		}
		AddThinkToEnt(text, "think")
		scope.m_hText <- text
	}
	function OnGameEvent_player_death(params) {
		local victim = GetPlayerFromUserID(params.userid)
		local attacker = GetPlayerFromUserID(params.attacker)

		if(params.death_flags & TF_DEATH_FEIGN_DEATH)
			return
		
		local pickup = CreatePickup({
			origin = victim.GetCenter(),
			velocity = Vector(RandomInt(-300, 300), RandomInt(-300, 300), 150),
			angles = Vector()
			team = victim.GetTeam() == TF_TEAM_RED ? TF_TEAM_BLUE : TF_TEAM_RED,
			lifetime = 30
			model = "models/props_halloween/halloween_gift.mdl"
			sound = "weapons/vaccinator_charge_tier_02.wav",
			func = function() {
				(GetScope(activator).armor + PickupArmors[activator.GetPlayerClass()]) > MaxArmors[activator.GetPlayerClass()] ? 
				GetScope(activator).armor = MaxArmors[activator.GetPlayerClass()] : GetScope(activator).armor += PickupArmors[activator.GetPlayerClass()]
				EmitSoundEx({
					sound_name = "weapons/vaccinator_charge_tier_02.wav"
					channel = 3
					filter_type = RECIPIENT_FILTER_SINGLE_PLAYER
					entity = activator
				})
			}
		})
		pickup.SetModelScale(0.8, 0)
		// pickup.SetSkin(victim.GetTeam() == TF_TEAM_RED ? 0 : 1)
	}

	function OnScriptHook_OnTakeDamage(params) {
		local victim = params.const_entity
		local attacker = params.attacker
		local weapon = params.weapon
		local dmg_custom = params.damage_stats

		if(!victim.IsPlayer() || victim == attacker || attacker == Entities.First())
			return

		if(	dmg_custom == TF_DMG_CUSTOM_BACKSTAB || 
			dmg_custom == TF_DMG_CUSTOM_BOOTS_STOMP || 
			dmg_custom == TF_DMG_CUSTOM_CROC || 
			dmg_custom == TF_DMG_CUSTOM_TRIGGER_HURT ||
			dmg_custom == TF_DMG_CUSTOM_TELEFRAG ||
			dmg_custom == TF_DMG_CUSTOM_SUICIDE ||
			dmg_custom == TF_DMG_CUSTOM_DECAPITATION ||
			dmg_custom == TF_DMG_CUSTOM_TAUNTATK_ALLCLASS_GUITAR_RIFF ||
			dmg_custom == TF_DMG_CUSTOM_TAUNTATK_ARMAGEDDON ||
			dmg_custom == TF_DMG_CUSTOM_TAUNTATK_ARROW_STAB ||
			dmg_custom == TF_DMG_CUSTOM_TAUNTATK_BARBARIAN_SWING ||
			dmg_custom == TF_DMG_CUSTOM_TAUNTATK_ENGINEER_ARM_KILL ||
			dmg_custom == TF_DMG_CUSTOM_TAUNTATK_ENGINEER_GUITAR_SMASH ||
			dmg_custom == TF_DMG_CUSTOM_TAUNTATK_FENCING ||
			dmg_custom == TF_DMG_CUSTOM_TAUNTATK_GASBLAST ||
			dmg_custom == TF_DMG_CUSTOM_TAUNTATK_GRAND_SLAM ||
			dmg_custom == TF_DMG_CUSTOM_TAUNTATK_GRENADE ||
			dmg_custom == TF_DMG_CUSTOM_TAUNTATK_HADOUKEN ||
			dmg_custom == TF_DMG_CUSTOM_TAUNTATK_HIGH_NOON ||
			dmg_custom == TF_DMG_CUSTOM_TAUNTATK_UBERSLICE
		)
			return

		local victim_scope = GetScope(victim)

		if(victim_scope.armor <= 0)
		{
			victim_scope.armor = 0
			return
		}

		local dmg_reduc = 1.0
		if( (params.damage / Armor_dmg_mult) <= victim_scope.armor )
			dmg_reduc = Armor_reduc
		else // the stupid part
			// this formula results in a range of 0.5 minimum to 1.0 maximum, for 0.75 to 1.00, set * 2 to * 1
			dmg_reduc = Armor_reduc + ((((params.damage / Armor_dmg_mult) - victim_scope.armor) / params.damage) * Armor_reduc_mult)

		printl("Damage reduction is " + dmg_reduc)

		local message = format("Old vic Armor : %i\nNew vic Armor : %i", victim_scope.armor, victim_scope.armor - MATH.Clamp(params.damage / Armor_dmg_mult, 0, victim_scope.armor))

		victim_scope.armor -= MATH.Clamp(params.damage / Armor_dmg_mult, 0, victim_scope.armor)
		params.damage = params.damage * dmg_reduc

		if(attacker.IsPlayer() && !IsPlayerABot(attacker)) attacker.PrintToHud(message)

		if(victim.InMultiCond([TF_COND_STEALTHED, TF_COND_STEALTHED_BLINK, TF_COND_STEALTHED_USER_BUFF, TF_COND_STEALTHED_USER_BUFF_FADING]))
			return


		if(	dmg_custom == TF_DMG_CUSTOM_BLEEDING || 
			dmg_custom == TF_DMG_CUSTOM_BURNING )
			return

		PrecacheSound("weapons/vaccinator_charge_tier_01.wav")
		EmitSoundEx({
			sound_name = "weapons/vaccinator_charge_tier_01.wav"
			sound_level = 100
			entity = attacker
			filter_type = RECIPIENT_FILTER_SINGLE_PLAYER
		})

		/* local shield = CreateByClassname("prop_dynamic")
		shield.SetModel("models/effects/resist_shield/resist_shield.mdl")
		shield.SetAbsOrigin(victim.GetOrigin())
		shield.SetAbsVelocity(victim.GetAbsVelocity())
		shield.SetSkin(victim.GetTeam() == TF_TEAM_RED ? 0 : 1)
		shield.DispatchSpawn()
		GetScope(shield).player <- victim
		GetScope(shield).think <- function() {
			if(!player.IsValid() || !player.IsAlive())
			{
				ClearThinks(self)
				EntFireByHandle(self, "Kill", null, -1, self, self)
				return 500
			}
			self.SetAbsOrigin(player.GetOrigin())
			self.SetAbsVelocity(player.GetAbsVelocity())
			return -1
		}
		AddThinkToEnt(shield, "think")
		EntFireByHandle(shield, "Kill", null, 0.45, null, null) */
	}
}
__CollectGameEventCallbacks(Armor)