::table <- {
    // Initalize Listensers so game wont discard the events

	/**
	 * Fired when a Human touches a resupply cabinet or respawns.
	 * 
	 * `Note:` Fired after HumanUpgraded
	 * 
	 * @param {CTFPlayer}	player				The player who resupplied.
	 */
	function OnScriptEvent_HumanResupply( _params ) 				{}
	/**
	 * Fired when a Human Upgrades and Before `HumanResupply`
	 * 
	 * @param {CTFPlayer}	player				The player who Upgraded.
	 */
	function OnScriptEvent_HumanUpgraded( _params ) 				{}

	/**
	 * Fired when a Bot touches a resupply cabinet or respawns.
	 * 
	 * `Note:` Fired after BotUpgraded
	 * 
	 * @param {CTFBot}		player				The bot who resupplied.
	 */
	function OnScriptEvent_BotResupply( _params ) 				{}
	/**
	 * Fired when a Bot Upgrades and Before `BotResupply`
	 * 
	 * `Note:` i dont think this can actually "fire"
	 * 
	 * @param {CTFBot}		player				The bot who Upgraded.
	 */
	function OnScriptEvent_BotUpgraded( _params ) 				{}

	/**
	 * Fired when a bot dies. 
	 *
	 * @param {CTFBot}				victim				The bot that died.
	 * @param {CBaseEntity|null}	attacker			The player entity that killed the victim.
	 * @param {CBaseEntity|null}	assister			The player entity that assisted the kill.
	 * @param {CBaseEntity|null}	weapon				The weapon used to kill.
	 * @param {CBaseEntity|null}	inflictor			The entity that dealt the damage (e.g. rocket/sentry).
	 * @param {string}				logname				The weapon name that should be printed in console.
	 * @param {integer}				damagebits			Damage type bits.
	 * @param {integer}				weaponIDX			The definition index of the weapon.
	 * @param {integer}				death_flags			See TF_DEATH (ln~ 340).
	 * @param {integer}				custom				Custom kill type (e.g. headshot).
	 * @param {integer}				stun_flags			The victim's stun flags at the moment of death
	 * @param {bool}				rocket_jump			True if the attacker was rocket jumping.
	 */
	function OnScriptEvent_BotDeath( _params ) 					{}
	/**
	 * Fired when a human dies. 
	 *
	 * @param {CTFPlayer}			victim				The human that died.
	 * @param {CBaseEntity|null}	attacker			The player entity that killed the victim.
	 * @param {CBaseEntity|null}	assister			The player entity that assisted the kill.
	 * @param {CBaseEntity|null}	weapon				The weapon used to kill.
	 * @param {CBaseEntity|null}	inflictor			The entity that dealt the damage (e.g. rocket/sentry).
	 * @param {string}				logname				The weapon name that should be printed in console.
	 * @param {integer}				damagebits			Damage type bits.
	 * @param {integer}				weaponIDX			The definition index of the weapon.
	 * @param {integer}				death_flags			See TF_DEATH (ln~ 340).
	 * @param {integer}				custom				Custom kill type (e.g. headshot).
	 * @param {integer}				stun_flags			The victim's stun flags at the moment of death
	 * @param {bool}				rocket_jump			True if the attacker was rocket jumping.
	 */
	function OnScriptEvent_HumanDeath( _params ) 					{}

	/**
	 * Fired when a bot is about to take damage (Script Hook).
	 * 
	 * @param {CTFBot}				victim				The bot taking damage.
	 * @param {CBaseEntity|null}	attacker			The entity dealing damage.
	 * @param {CBaseEntity|null}	inflictor			The entity inflicting damage (weapon/projectile).
	 * @param {CBaseEntity|null}	weapon				The weapon used.
	 * @param {Vector}				damage_position		World position of where the damage came from. E.g. end position of a bullet or a rocket.
	 * @param {float}				damage				The actual damage amount ( Does not count number of bullets or falloff or rampup )
	 * @param {float}				base_damage			The base damage before modifiers.
	 * @param {integer}				damage_type			Damage type bits (e.g. DMG_GENERIC).
	 * @param {integer}				hit_group			Hitgroup index (e.g. HITGROUP_HEAD).
	 * @param {integer}				damage_custom		Custom damage type stats.
	 * @param {integer}				crit_type			Crit type (0=None, 1=Mini, 2=Full).
	 * @param {integer}				penetration_count	How many players the damage has penetrated so far.
	 * @param {integer}				others_damaged		How many players other than the attacker has the damage been applied to.
	 */
	function OnScriptEvent_PostTakeDamageBot( _params ) 			{}
	/**
	 * Fired when a human is about to take damage (Script Hook).
	 * 
	 * @param {CTFPlayer}			victim				The human taking damage.
	 * @param {CBaseEntity|null}	attacker			The entity dealing damage.
	 * @param {CBaseEntity|null}	inflictor			The entity inflicting damage (weapon/projectile).
	 * @param {CBaseEntity|null}	weapon				The weapon used.
	 * @param {Vector}				damage_position		World position of where the damage came from. E.g. end position of a bullet or a rocket.
	 * @param {float}				damage				The actual damage amount ( Does not count number of bullets or falloff or rampup )
	 * @param {float}				base_damage			The base damage before modifiers.
	 * @param {integer}				damage_type			Damage type bits (e.g. DMG_GENERIC).
	 * @param {integer}				hit_group			Hitgroup index (e.g. HITGROUP_HEAD).
	 * @param {integer}				damage_custom		Custom damage type stats.
	 * @param {integer}				crit_type			Crit type (0=None, 1=Mini, 2=Full).
	 * @param {integer}				penetration_count	How many players the damage has penetrated so far.
	 * @param {integer}				others_damaged		How many players other than the attacker has the damage been applied to.
	 */
	function OnScriptEvent_PostTakeDamageHuman( _params ) 		{}

	/**
	 * Fired when the world is about to take damage (Script Hook).
	 * 
	 * @param {CBaseEntity}			victim				The world taking damage.
	 * @param {CBaseEntity|null}	attacker			The entity dealing damage.
	 * @param {CBaseEntity|null}	inflictor			The entity inflicting damage (weapon/projectile).
	 * @param {CBaseEntity|null}	weapon				The weapon used.
	 * @param {Vector}				damage_position		World position of where the damage came from. E.g. end position of a bullet or a rocket.
	 * @param {float}				damage				The actual damage amount ( Does not count number of bullets or falloff or rampup )
	 * @param {float}				base_damage			The base damage before modifiers.
	 * @param {integer}				damage_type			Damage type bits (e.g. DMG_GENERIC).
	 * @param {integer}				damage_custom		Custom damage type stats.
	 * @param {integer}				crit_type			Crit type (0=None, 1=Mini, 2=Full).
	 * @param {integer}				penetration_count	How many players the damage has penetrated so far.
	 * @param {integer}				others_damaged		How many players other than the attacker has the damage been applied to.
	 */
	function OnScriptEvent_PostTakeDamageWorld( _params ) 		{}
	/**
	 * Fired when any other entity is about to take damage (Script Hook).
	 * 
	 * @param {CBaseEntity}			victim				The entity taking damage.
	 * @param {CBaseEntity|null}	attacker			The entity dealing damage.
	 * @param {CBaseEntity|null}	inflictor			The entity inflicting damage (weapon/projectile).
	 * @param {CBaseEntity|null}	weapon				The weapon used.
	 * @param {Vector}				damage_position		World position of where the damage came from. E.g. end position of a bullet or a rocket.
	 * @param {float}				damage				The actual damage amount ( Does not count number of bullets or falloff or rampup )
	 * @param {float}				base_damage			The base damage before modifiers.
	 * @param {integer}				damage_type			Damage type bits (e.g. DMG_GENERIC).
	 * @param {integer}				damage_custom		Custom damage type stats.
	 * @param {integer}				crit_type			Crit type (0=None, 1=Mini, 2=Full).
	 * @param {integer}				penetration_count	How many players the damage has penetrated so far.
	 * @param {integer}				others_damaged		How many players other than the attacker has the damage been applied to.
	 */
	function OnScriptEvent_PostTakeDamage( _params ) 				{}

	/**
	 * Fired when a bot is hurt (after damage calculation).
	 * 
	 * @param {CTFBot}				victim				The bot who was hurt.
	 * @param {CBaseEntity|null}	attacker			The entity who attacked.
	 * @param {integer}				damage				Final damage amount applied.
	 * @param {integer}				health				Remaining health of the victim.
	 * @param {integer}				over_damage			Overkill damage (if dead).
	 * @param {integer}				damage_custom		Custom damage type.
	 * @param {integer}				bonuseffect			Bonus effect (e.g. BONUS_EFFECT_CRIT).
	 * @param {bool}				killed				True if this damage killed the victim.
	 * @param {bool}				showdisguisedcrit 	True if crit should be shown freely.
	 * @param {bool}				allseecrit			True if everyone sees the crit.
	 */
	function OnScriptEvent_PostBotHurt( _params ) 				{}
	/**
	 * Fired when a human is hurt (after damage calculation).
	 * 
	 * @param {CTFPlayer}			victim				The human who was hurt.
	 * @param {CBaseEntity|null}	attacker			The entity who attacked.
	 * @param {integer}				damage				Final damage amount applied.
	 * @param {integer}				health				Remaining health of the victim.
	 * @param {integer}				over_damage			Overkill damage (if dead).
	 * @param {integer}				damage_custom		Custom damage type.
	 * @param {integer}				bonuseffect			Bonus effect (e.g. BONUS_EFFECT_CRIT).
	 * @param {bool}				killed				True if this damage killed the victim.
	 * @param {bool}				showdisguisedcrit 	True if crit should be shown freely.
	 * @param {bool}				allseecrit			True if everyone sees the crit.
	 */
	function OnScriptEvent_PostHumanHurt( _params ) 				{}

	/**
	 * Fired when a bot spawns for the first time.
	 * 
	 * @param {CTFBot}				player				The bot who spawned.
	 * @param {integer}				class				The class index of the player.
	 * @param {integer}				team				The team index.
	 */
	function OnScriptEvent_BotInitialSpawn( _params ) 			{}
	/**
	 * Fired when a bot spawns.
	 * 
	 * @param {CTFBot}				player				The bot who spawned.
	 * @param {integer}				class				The class index of the player.
	 * @param {integer}				team				The team index.
	 */
	function OnScriptEvent_BotSpawn( _params ) 					{}

	/**
	 * Fired when a human spawns for the first time.
	 * 
	 * @param {CTFPlayer}			player				The human who spawned.
	 * @param {integer}				class				The class index of the player.
	 * @param {integer}				team				The team index.
	 */
	function OnScriptEvent_HumanInitialSpawn( _params ) 			{}
		/**
	 * Fired when a human spawns.
	 * 
	 * @param {CTFPlayer}			player				The human who spawned.
	 * @param {integer}				class				The class index of the player.
	 * @param {integer}				team				The team index.
	 */
	function OnScriptEvent_HumanSpawn( _params ) 					{}

	/**
	 * Fired when a bot changes team.
	 * 
	 * @param {CTFBot}				player				The bot who changed team.
	 * @param {integer}				team				The new team index.
	 * @param {integer}				oldteam				The old team index.
	 * @param {bool}				disconnect			True if player is disconnecting.
	 * @param {bool}				autoteam			True if auto-assigned.
	 * @param {bool}				silent				True if silent change.
	 * @param {string}				username			Username of the client.
	 */
	function OnScriptEvent_BotTeam( _params ) 					{}
	/**
	 * Fired when a human changes team.
	 * 
	 * @param {CTFPlayer}			player				The human who changed team.
	 * @param {integer}				team				The new team index.
	 * @param {integer}				oldteam				The old team index.
	 * @param {bool}				disconnect			True if player is disconnecting.
	 * @param {bool}				autoteam			True if auto-assigned.
	 * @param {bool}				silent				True if silent change.
	 * @param {string}				username			Username of the client.
	 */
	function OnScriptEvent_HumanTeam( _params ) 					{}

	/**
	 * Fired when a bot speaks.
	 * 
	 * @param {CTFBot}					player			The bot who spoke.
	 * @param {string}					message			The text message.
	 * @param {bool}					teamonly		True if team-only chat.
	 */
	function OnScriptEvent_BotSay( _params ) 						{}
	/**
	 * Fired when a player speaks.
	 * 
	 * @param {CTFPlayer}				player			The human who spoke.
	 * @param {string}					message			The text message.
	 * @param {bool}					teamonly		True if team-only chat.
	 */
	function OnScriptEvent_HumanSay( _params ) 					{}
	/**
	 * Fired when the console speaks.
	 * 
	 * @param {null}					player			The entity who spoke (always null, leftover from above).
	 * @param {string}					message			The text message.
	 * @param {bool}					teamonly		True if team-only chat.
	 */
	function OnScriptEvent_ConsoleSay( _params ) 					{}

	/**
	 * Fired when a building is hurt.
	 * 
	 * @param {CBaseEntity}				object			The building being hurt.
	 * @param {CBaseEntity|null}		attacker		The attacker entity.
	 * @param {integer}					damage			Damage amount.
	 * @param {integer}					health			How much health the object is currently at.
	 * @param {bool}					crit			If the attack was a Crit (minicrit or full).
	 */	
	function OnScriptEvent_BuildingHurt( _params ) 				{}

	/**
	 * Fired when a tank is hurt.
	 * 
	 * @param {CTFBaseBoss}				object			The tank being hurt.
	 * @param {CBaseEntity|null}		attacker		The attacker entity.
	 * @param {integer}					damage			Damage amount.
	 * @param {integer}					health			How much health the object is currently at.
	 * @param {bool}					crit			If the attack was a Crit (minicrit or full).
	 */	
	function OnScriptEvent_TankHurt( _params ) 					{}
	/**
	 * Fired when a tank is hurt.
	 * 
	 * @param {CTFBaseBoss}				object			The tank being hurt.
	 * @param {CBaseEntity|null}		attacker		The attacker entity.
	 * @param {integer}					damage			Damage amount.
	 * @param {integer}					health			How much health the object is currently at.
	 * @param {bool}					crit			If the attack was a Crit (minicrit or full).
	 */	
	function OnScriptEvent_BaseBossHurt( _params ) 				{}

	/**
	 * Fired when a boss is hurt.
	 * 
	 * @param {CBaseEntity}				object			The boss being hurt.
	 * @param {CBaseEntity|null}		attacker		The attacker entity.
	 * @param {integer}					damage			Damage amount.
	 * @param {integer}					health			How much health the object is currently at.
	 * @param {bool}					crit			If the attack was a Crit (minicrit or full).
	 */	
	function OnScriptEvent_HHHHurt( _params ) 					{}
	/**
	 * Fired when a boss is hurt.
	 * 
	 * @param {CBaseEntity}				object			The boss being hurt.
	 * @param {CBaseEntity|null}		attacker		The attacker entity.
	 * @param {integer}					damage			Damage amount.
	 * @param {integer}					health			How much health the object is currently at.
	 * @param {bool}					crit			If the attack was a Crit (minicrit or full).
	 */	
	function OnScriptEvent_MonoculusHurt( _params ) 				{}
	/**
	 * Fired when a boss is hurt.
	 * 
	 * @param {CBaseEntity}				object			The boss being hurt.
	 * @param {CBaseEntity|null}		attacker		The attacker entity.
	 * @param {integer}					damage			Damage amount.
	 * @param {integer}					health			How much health the object is currently at.
	 * @param {bool}					crit			If the attack was a Crit (minicrit or full).
	 */	
	function OnScriptEvent_MerasmusHurt( _params ) 				{}

	/**
	 * Fired when a building is killed.
	 * 
	 * @param {CBaseEntity}				object			The building being killed.
	 * @param {CBaseEntity|null}		attacker		The attacker entity.
	 * @param {integer}					damage			Damage amount.
	 * @param {integer}					health			How much health the object is currently at (always <= 0).
	 * @param {integer}					over_damage		Amount of damage that exceeded the building's remaining health.
	 * @param {bool}					crit			If the attack was a Crit (minicrit or full).
	 */
	function OnScriptEvent_BuildingKilled( _params ) 				{}
	
	/**
	 * Fired when a tank is killed.
	 * 
	 * @param {CTFBaseBoss}				object			The tank being killed.
	 * @param {CBaseEntity|null}		attacker		The attacker entity.
	 * @param {integer}					damage			Damage amount.
	 * @param {integer}					health			How much health the object is currently at (always <= 0).
	 * @param {integer}					over_damage		Amount of damage that exceeded the tank's remaining health.
	 * @param {bool}					crit			If the attack was a Crit (minicrit or full).
	 */
	function OnScriptEvent_TankKilled( _params ) 					{}
	/**
	 * Fired when a tank is killed.
	 * 
	 * @param {CTFBaseBoss}				object			The tank being killed.
	 * @param {CBaseEntity|null}		attacker		The attacker entity.
	 * @param {integer}					damage			Damage amount.
	 * @param {integer}					health			How much health the object is currently at (always <= 0).
	 * @param {integer}					over_damage		Amount of damage that exceeded the tank's remaining health.
	 * @param {bool}					crit			If the attack was a Crit (minicrit or full).
	 */
	function OnScriptEvent_BaseBossKilled( _params ) 				{}
	
	/**
	 * Fired when HHH is killed.
	 * 
	 * @param {CBaseEntity}				object			The boss being killed.
	 * @param {CBaseEntity|null}		attacker		The attacker entity.
	 * @param {integer}					damage			Damage amount.
	 * @param {integer}					health			How much health the object is currently at (always <= 0).
	 * @param {integer}					over_damage		Amount of damage that exceeded the bosses remaining health.
	 * @param {bool}					crit			If the attack was a Crit (minicrit or full).
	 */
	function OnScriptEvent_HHHKilled( _params ) 					{}
	/**
	 * Fired when Monoculus is killed.
	 * 
	 * @param {CBaseEntity}				object			The boss being killed.
	 * @param {CBaseEntity|null}		attacker		The attacker entity.
	 * @param {integer}					damage			Damage amount.
	 * @param {integer}					health			How much health the object is currently at (always <= 0).
	 * @param {integer}					over_damage		Amount of damage that exceeded the bosses remaining health.
	 * @param {bool}					crit			If the attack was a Crit (minicrit or full).
	 */
	function OnScriptEvent_MonoculusKilled( _params ) 			{}
	/**
	 * Fired when Merasmus is killed.
	 * 
	 * @param {CBaseEntity}				object			The boss being killed.
	 * @param {CBaseEntity|null}		attacker		The attacker entity.
	 * @param {integer}					damage			Damage amount.
	 * @param {integer}					health			How much health the object is currently at (always <= 0).
	 * @param {integer}					over_damage		Amount of damage that exceeded the bosses remaining health.
	 * @param {bool}					crit			If the attack was a Crit (minicrit or full).
	 */
	function OnScriptEvent_MerasmusKilled( _params ) 				{}

	/**
	 * Fired when a bot/player is healed.
	 * 
	 * @param {CTFBot}						patient			The bot being healed.
	 * @param {CTFPlayer|CBaseEntity|null}	healer			The healer entity (e.g. Medic/Dispenser).
	 * @param {integer}						amount			Heal amount.
	 */
	function OnScriptEvent_BotHealed( _params ) 					{}
	/**
	 * Fired when a human is healed.
	 * 
	 * @param {CTFPlayer}					patient			The human being healed.
	 * @param {CTFPlayer|CBaseEntity|null}	healer			The healer entity (e.g. Medic/Dispenser).
	 * @param {integer}						amount			Heal amount.
	 */
	function OnScriptEvent_HumanHealed( _params ) 				{}

	/**
	 * Fired when a Dispenser is Created
	 *
	 * @param {CTFPlayer} 				player	 		The player that created the Dispenser.
	 * @param {CBaseEntity|null} 		object	 		The Dispenser that was Created.
	 */
	function OnScriptEvent_DispenserBuilt( _params )				{}
	/**
	 * Fired when a Teleporter is Created
	 *
	 * @param {CTFPlayer} 				player	 		The player that created the Teleporter.
	 * @param {CBaseEntity|null} 		object	 		The Teleporter that was Created.
	 */
	function OnScriptEvent_TeleporterBuilt( _params )				{}
	/**
	 * Fired when a Sentry is Created
	 *
	 * @param {CTFPlayer} 				player	 		The player that created the Sentry.
	 * @param {CBaseEntity|null} 		object	 		The Sentry that was Created.
	 */
	function OnScriptEvent_SentryBuilt( _params )					{}
	/**
	 * Fired when a Sapper is Created
	 *
	 * @param {CTFPlayer} 				player	 		The player that created the Sapper.
	 * @param {CBaseEntity|null} 		object	 		The Sapper that was Created.
	 */
	function OnScriptEvent_SapperBuilt( _params )					{}

	/** 
	 * Fired when a Player is deflected
	 * 
	 * @param {CBaseEntity|null} 		deflector		The entity that deflected object.
	 * @param {CBaseEntity|null} 		object			The player that was deflected.
	 * @param {CBaseEntity|null} 		old_owner		The owner of object before deflection.
	 */
	function OnScriptEvent_PlayerDeflected( _params ) 			{}
	/** 
	 * Fired when a Rocket is deflected
	 * 
	 * @param {CBaseEntity|null} 		deflector		The entity that deflected object.
	 * @param {CBaseEntity|null} 		object			The rocket that was deflected.
	 * @param {CBaseEntity|null} 		old_owner		The owner of object before deflection.
	 */		
	function OnScriptEvent_RocketDeflected( _params ) 			{}
	/** 
	 * Fired when a Grenade is deflected
	 * 
	 * @param {CBaseEntity|null} 		deflector		The entity that deflected object.
	 * @param {CBaseEntity|null} 		object			The grenade that was deflected.
	 * @param {CBaseEntity|null} 		old_owner		The owner of object before deflection.
	 */
	function OnScriptEvent_GrenadeDeflected( _params ) 			{}
	/** 
	 * Fired when a different Object is deflected
	 * 
	 * @param {CBaseEntity|null} 		deflector		The entity that deflected object.
	 * @param {CBaseEntity|null} 		object			The entity that was deflected.
	 * @param {CBaseEntity|null} 		old_owner		The owner of object before deflection.
	 */
	function OnScriptEvent_ObjectDeflected( _params ) 			{}


	/**
	 * @param {string}					command			The chat commmand that was triggered.
	 * @param {CTFPlayer|null}			player			The player that triggered this chat command (null for console).
	 * @param {table}					data			Any other data the chat command was passed.
	 */
	function OnScriptEvent_ChatCommand( _params )					{}

	/**
	 * Fired when a player is Stunned
	 * 
	 * @param {CTFPlayer|null} 			stunner 		The Player who stunned the victim.
	 * @param {CTFPlayer|null} 			victim 			The Player who got stunned.
	 * @param {bool} 					big_stun 		Wether the stun was a Big Stun.
	 * @param {bool} 					victim_capping 	If the victim was attempting to cap before getting stunned.
	 */
	function OnScriptEvent_PlayerStunned( _params )				{}

	/**
	 * Fired when a wave fails/completes
	 * . . . literally 0 parameters
	 */
	function OnScriptEvent_WaveFailed( _ )						{}
	function OnScriptEvent_WaveComplete( _ )						{}

	/**
	 * Fired whenever a primary or secondary weapon fires
	 * 
	 * **Note:** Melee attacks need to be fixed
	 * @param {CTFPlayer}				player			The Player who shot this weapon.
	 * @param {CTFWeaponBase}			weapon			The Weapon the player fired.
	 */
	function OnScriptEvent_PlayerFireWeapon( _params )			{}

	/**
	 * Fired After we Handle our Custom Attributes
	 * 
	 * @param {CTFBot}					player			The bot who spawned.
	 */
	function OnScriptEvent_PostBotSpawn( _params )				{}
	/**
	 * Fired After we Handle our Custom Attributes
	 * 
	 * @param {CTFPlayer}				player			The player who spawned.
	 */
	function OnScriptEvent_PostHumanSpawn( _params )				{}
}
__CollectGameEventCallbacks(table)