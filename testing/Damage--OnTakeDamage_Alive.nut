/*
	Main Damage System is this

	CBaseEntity::TakeDamage // normally scripthook fires here
	|-	CTFPlayer::OnTakeDamage
		|- 	CBaseCombatCharacter::OnTakeDamage
			|- 	CTFPlayer::OnTakeDamage_Alive // fire New Script hook here
 */



::CRIT_NONE 						<- 4
::BASEDAMAGE_NOT_SPECIFIED 			<- FLT_MAX
::DAMAGE_NO							<- 0
::DAMAGE_EVENTS_ONLY				<- 1
::WL_NotInWater 					<- 0
::WL_Waist 							<- 2
::TF_WEAPON_SNIPERRIFLE_DAMAGE_MIN 	<- 50 
::TF_WEAPON_SNIPERRIFLE_DAMAGE_MAX 	<- 150

::HITGROUP_HEAD 	<- 1

::SF_PHURT_HURT_UBER <- 2

::LIFE_ALIVE		<- 0 // alive
::LIFE_DYING		<- 1 // playing death animation or still falling off of a ledge waiting to hit ground
::LIFE_DEAD			<- 2 // dead. lying still.

::SENTRY_MAX_RANGE <- 1100

::kBonusEffect_Crit 				<- 0
::kBonusEffect_MiniCrit				<- 1
::kBonusEffect_None					<- 4
::kBonusEffect_DragonsFury			<- 5
::kBonusEffect_Stomp				<- 6

::condition_to_attribute_translation <- [
	TF_COND_BURNING,					// 1 (1<<0)
	TF_COND_AIMING,						// 2 (1<<1)
	TF_COND_ZOOMED,						// 4 (1<<2)
	TF_COND_DISGUISING,					// 8 (...)
	TF_COND_DISGUISED,					// 16
	TF_COND_STEALTHED,					// 32
	TF_COND_INVULNERABLE,				// 64
	TF_COND_TELEPORTED,					// 128
	TF_COND_TAUNTING,					// 256
	TF_COND_INVULNERABLE_WEARINGOFF,	// 512
	TF_COND_STEALTHED_BLINK,			// 1024
	TF_COND_SELECTED_TO_TELEPORT,		// 2048
	TF_COND_CRITBOOSTED,				// 4096
	TF_COND_TMPDAMAGEBONUS,				// 8192
	TF_COND_FEIGN_DEATH,				// 16384
	TF_COND_PHASE,						// 32768
	TF_COND_STUNNED,					// 65536
	TF_COND_HEALTH_BUFF,				// 131072
	TF_COND_HEALTH_OVERHEALED,			// 262144
	TF_COND_URINE,						// 524288
	TF_COND_ENERGY_BUFF,				// 1048576
	TF_COND_LAST				// sentinel value checked against when iterating
]

::TF_BURNING_FLAME_LIFE <- 10.0
::TF_BURNING_DMG <- 4

::TF_DAMAGE_MINICRIT_MULTIPLIER <- 1.35
::TF_DAMAGE_CRIT_MULTIPLIER <- 3.0

enum MissionType
{
	NO_MISSION, // = 0
	MISSION_SEEK_AND_DESTROY,		// focus on finding and killing enemy players
	MISSION_DESTROY_SENTRIES,		// focus on finding and destroying enemy sentry guns (and buildings)
	MISSION_SNIPER,					// maintain teams of snipers harassing the enemy
	MISSION_SPY,					// maintain teams of spies harassing the enemy
	MISSION_ENGINEER,				// maintain engineer nests for harassing the enemy
	MISSION_REPROGRAMMED,			// MvM: robot has been hacked and will do bad things to their team
}

enum DebugOverlayBits_t
{
	OVERLAY_TEXT_BIT			=	0x00000001,		// show text debug overlay for this entity
	OVERLAY_NAME_BIT			=	0x00000002,		// show name debug overlay for this entity
	OVERLAY_BBOX_BIT			=	0x00000004,		// show bounding box overlay for this entity
	OVERLAY_PIVOT_BIT			=	0x00000008,		// show pivot for this entity
	OVERLAY_MESSAGE_BIT			=	0x00000010,		// show messages for this entity
	OVERLAY_ABSBOX_BIT			=	0x00000020,		// show abs bounding box overlay
	OVERLAY_RBOX_BIT			=   0x00000040,     // show the rbox overlay
	OVERLAY_SHOW_BLOCKSLOS		=	0x00000080,		// show entities that block NPC LOS
	OVERLAY_ATTACHMENTS_BIT		=	0x00000100,		// show attachment points
	OVERLAY_AUTOAIM_BIT			=	0x00000200,		// Display autoaim radius

	OVERLAY_NPC_SELECTED_BIT	=	0x00001000,		// the npc is current selected
	OVERLAY_NPC_NEAREST_BIT		=	0x00002000,		// show the nearest node of this npc
	OVERLAY_NPC_ROUTE_BIT		=	0x00004000,		// draw the route for this npc
	OVERLAY_NPC_TRIANGULATE_BIT =	0x00008000,		// draw the triangulation for this npc
	OVERLAY_NPC_ZAP_BIT			=	0x00010000,		// destroy the NPC
	OVERLAY_NPC_ENEMIES_BIT		=	0x00020000,		// show npc's enemies
	OVERLAY_NPC_CONDITIONS_BIT	=	0x00040000,		// show NPC's current conditions
	OVERLAY_NPC_SQUAD_BIT		=	0x00080000,		// show npc squads
	OVERLAY_NPC_TASK_BIT		=	0x00100000,		// show npc task details
	OVERLAY_NPC_FOCUS_BIT		=	0x00200000,		// show line to npc's enemy and target
	OVERLAY_NPC_VIEWCONE_BIT	=	0x00400000,		// show npc's viewcone
	OVERLAY_NPC_KILL_BIT		=	0x00800000,		// kill the NPC, running all appropriate AI.

	OVERLAY_WC_CHANGE_ENTITY	=	0x01000000,		// object changed during WC edit
	OVERLAY_BUDDHA_MODE			=	0x02000000,		// take damage but don't die

	OVERLAY_NPC_STEERING_REGULATIONS	=	0x04000000,	// Show the steering regulations associated with the NPC

	OVERLAY_TASK_TEXT_BIT		=	0x08000000,		// show task and schedule names when they start

	OVERLAY_PROP_DEBUG			=	0x10000000,

	OVERLAY_NPC_RELATION_BIT	=	0x20000000,		// show relationships between target and all children

	OVERLAY_VIEWOFFSET			=	0x40000000,		// show view offset
};

class CTakeDamageInfo {
	m_vecDamageForce			= Vector()
	m_vecDamagePosition	 		= Vector()
	m_vecReportedPosition   	= Vector()	// Position players are told damage is coming from
	m_hInflictor				= null
	m_hAttacker			 		= null
	m_hWeapon			 		= null
	m_flDamage			  		= 0.0
	m_flMaxDamage		   		= 0.0
	m_flBaseDamage		  		= 0.0		// The damage amount before skill leve adjustments are made. Used to get uniform damage forces.
	m_bitsDamageType			= 0
	m_iDamageCustom 			= 0
	m_iDamageStats 				= 0
	m_iAmmoType 				= 0			// AmmoType of the weapon used to cause this damage, if any
	m_iDamagedOtherPlayers 		= 0
	m_iPlayerPenetrationCount 	= 0
	m_flDamageBonus 			= 0			// Anything that increases damage (crit) - store the delta
	m_hDamageBonusProvider 		= null		// Who gave us the ability to do extra damage?
	m_bForceFriendlyFire 		= false		// Ideally this would be a dmg type, but we can't add more

	m_flDamageForForce 			= 0.0

	m_eCritType 				= 0

	ECritType = {
		CRIT_NONE = 0,
		CRIT_MINI = 1,
		CRIT_FULL = 2,
	}

	constructor(pInflictor, pAttacker, pWeapon, damageForce, damagePosition, reportedPosition, flDamage, bitsDamageType, iCustomDamage)
	{
		m_hInflictor = pInflictor
		if ( pAttacker )
		{
			m_hAttacker = pAttacker
		}
		else
		{
			m_hAttacker = pInflictor
		}

		m_hWeapon = pWeapon

		m_flDamage = flDamage

		m_flBaseDamage = BASEDAMAGE_NOT_SPECIFIED

		m_bitsDamageType = bitsDamageType
		m_iDamageCustom = iCustomDamage

		m_flMaxDamage = flDamage
		m_vecDamageForce = damageForce
		m_vecDamagePosition = damagePosition
		m_vecReportedPosition = reportedPosition
		m_iAmmoType = -1
		m_iDamagedOtherPlayers = 0
		m_iPlayerPenetrationCount = 0
		m_flDamageBonus = 0.0
		m_bForceFriendlyFire = false
		m_flDamageForForce = 0.0
		m_eCritType = CRIT_NONE
	}

	
	/**
	 * @returns {CBaseEntity|null}
	 */
	function GetInflictor() { return m_hInflictor }
	/**
	 * @param {CBaseEntity|null} pInflictor
	 */
	function SetInflictor( pInflictor ) { m_hInflictor = pInflictor }
	/**
	 * @returns {CBaseEntity|null}
	 */
	function GetAttacker() { return m_hAttacker }
	/**
	 * @param {CBaseEntity|null} pAttacker
	 */
	function SetAttacker( pAttacker ) { m_hAttacker = pAttacker }
	/**
	 * @returns {CBaseEntity|null}
	 */
	function GetWeapon() { return m_hWeapon }
	/**
	 * @param {CBaseEntity|null} pWeapon
	 */
	function SetWeapon( pWeapon ) { m_hWeapon = pWeapon }
	/**
	 * @returns {float}
	 */
	function GetDamage() { return m_flDamage }
	/**
	 * @param {float} flDamage
	 */
	function SetDamage( flDamage ) { m_flDamage = flDamage }
	/**
	 * @returns {float}
	 */
	function GetMaxDamage() { return m_flMaxDamage }
	/**
	 * @param {float} flMaxDamage
	 */
	function SetMaxDamage( flMaxDamage ) { m_flMaxDamage = flMaxDamage }
	/**
	 * @param {float} flScaleAmount
	 */
	function ScaleDamage( flScaleAmount ) { m_flDamage *= flScaleAmount }
	/**
	 * @param {float} flAddAmount
	 */
	function AddDamage( flAddAmount ) { m_flDamage += flAddAmount }
	/**
	 * @param {float} flSubtractAmount
	 */
	function SubtractDamage( flSubtractAmount ) { m_flDamage -= flSubtractAmount }
	/**
	 * @returns {float}
	 */
	function GetDamageBonus() { return m_flDamageBonus }
	/**
	 * @returns {CBaseEntity|null}
	 */
	function GetDamageBonusProvider() { return m_hDamageBonusProvider }
	function BaseDamageIsValid() { return (m_flBaseDamage != BASEDAMAGE_NOT_SPECIFIED) }
	/**
	 * @returns {Vector}
	 */
	function GetDamageForce() { return m_vecDamageForce }
	/**
	 * @param {Vector} damageForce
	 */
	function SetDamageForce( damageForce ) { m_vecDamageForce = damageForce }
	/**
	 * @param {float} flScaleAmount
	 */
	function ScaleDamageForce( flScaleAmount ) { m_vecDamageForce *= flScaleAmount }
	/**
	 * @returns {float}
	 */
	function GetDamageForForceCalc() { return m_flDamageForForce }
	/**
	 * @param {float} flDamage
	 */
	function SetDamageForForceCalc( flDamage ) { m_flDamageForForce = flDamage }
	/**
	 * @returns {Vector}
	 */
	function GetDamagePosition() { return m_vecDamagePosition }
	/**
	 * @param {Vector} damagePosition
	 */
	function SetDamagePosition( damagePosition ) { m_vecDamagePosition = damagePosition }
	/**
	 * @returns {Vector}
	 */
	function GetReportedPosition() { return m_vecReportedPosition }
	/**
	 * @param {Vector} reportedPosition
	 */
	function SetReportedPosition( reportedPosition ) { m_vecReportedPosition = reportedPosition }
	/**
	 * @param {integer} bitsDamageType
	 */
	function SetDamageType( bitsDamageType ) { m_bitsDamageType = bitsDamageType }
	/**
	 * @returns {integer}
	 */
	function GetDamageType() { return m_bitsDamageType }
	/**
	 * @param {integer} bitsDamageType
	 */
	function AddDamageType( bitsDamageType ) { m_bitsDamageType = m_bitsDamageType | bitsDamageType }
	/**
	 * @returns {integer}
	 */
	function GetDamageCustom() { return m_iDamageCustom }
	/**
	 * @param {integer} iDamageCustom
	 */
	function SetDamageCustom( iDamageCustom ) { m_iDamageCustom = iDamageCustom }
	/**
	 * @returns {integer}
	 */
	function GetDamageStats() { return m_iDamageCustom }
	/**
	 * @param {integer} iDamageCustom
	 */
	function SetDamageStats( iDamageCustom ) { m_iDamageCustom = iDamageCustom }
	/**
	 * @returns {integer}
	 */
	function GetAmmoType() { return m_iAmmoType }
	/**
	 * @param {integer} iAmmoType
	 */
	function SetAmmoType( iAmmoType ) { m_iAmmoType = iAmmoType }
	function CopyDamageToBaseDamage() { m_flBaseDamage = m_flDamage }

	/** 
	 * @param {bool} bValue
	 */
	function SetForceFriendlyFire( bValue ) { m_bForceFriendlyFire = bValue }
	/** 
	 * @return {bool}
	 */
	function IsForceFriendlyFire() { return m_bForceFriendlyFire }

	/** 
	 * @returns {integer}
	 */
	function GetPlayerPenetrationCount() { return m_iPlayerPenetrationCount }
	/** 
	 * @param {integer} iPlayerPenetrationCount
	 */
	function SetPlayerPenetrationCount( iPlayerPenetrationCount ) { m_iPlayerPenetrationCount = iPlayerPenetrationCount }

	/** 
	 * @returns {integer}
	 */
	function GetDamagedOtherPlayers()     { return m_iDamagedOtherPlayers }
	/** 
	 * @param {integer} iVal
	 */
	function SetDamagedOtherPlayers( iVal ) { m_iDamagedOtherPlayers = iVal }


	function GetAmmoName() { return "Unknown" }
	/**
	 * @param {float} flBonus
	 * @param {CBaseEntity|null} pProvider
	 */
	function SetDamageBonus( flBonus, pProvider = null )
	{
		m_flDamageBonus = flBonus
		m_hDamageBonusProvider = pProvider
	}
	/**
	 * @returns {float}
	 */
	function GetBaseDamage() 
	{
		if( BaseDamageIsValid() )
			return m_flBaseDamage

		// No one ever specified a base damage, so just return damage.
		return m_flDamage
	}
	/**
	 * @param {integer} eType
	 */
	function SetCritType( eType )
	{
		if ( eType == CRIT_NONE )
		{
			m_eCritType = eType
		}
		else
		{
			m_eCritType = ( eType > m_eCritType ) ? eType : m_eCritType
		}
	}

	/**
	 * @returns {integer}
	 */
	function GetCritType() { return m_eCritType }

	function AdjustPlayerDamageInflictedForSkillLevel()
		CopyDamageToBaseDamage()
	function AdjustPlayerDamageTakenForSkillLevel()
		CopyDamageToBaseDamage()

	function DebugPrint()
	{
		/** 
		 * @param {CBaseEntity|null} t
		 * @returns {string}
		 */
		local function tostr(t) {return t? t.tostring() : "null"}
		/** 
		 * @param {bool} t
		 * @returns {string}
		 */
		local function tobstr(t) {return t.tostring()}
		printf(@"Final Damage:
			Damage: %f
			Max Damage: %f
			Base Damage: %f
			Custom: %d
			DamageBits: %d

			DmgForForce: %f
			DmgBonus: %f
			BonusProvider: %s

			Crit: %d
			OthersHit: %d
			PenetrationCount: %d

			Attacker: %s
			Inflictor: %s
			Weapon: %s

			AmmoType: %d
			FriendlyFire: %s

			DamageForce: %s
			DamagePos: %s
			ReportedPos: %s
			",
			GetDamage()
			GetMaxDamage()
			GetBaseDamage()
			GetDamageCustom()
			GetDamageType()

			GetDamageForForceCalc()
			GetDamageBonus()
			tostr(GetDamageBonusProvider())

			GetCritType()
			GetDamagedOtherPlayers()
			GetPlayerPenetrationCount()

			tostr(GetAttacker())
			tostr(GetInflictor())
			tostr(GetWeapon())

			GetAmmoType()
			tobstr(IsForceFriendlyFire())

			GetDamageForce().ToKVString()
			GetDamagePosition().ToKVString()
			GetReportedPosition().ToKVString()
		)
	}
}

function ROOT::IsInItemTestingMode()
	return GetPropBool(Gamerules, "m_bIsInItemTestingMode")

function ROOT::IsInCommentaryMode()
	return FindByClassname(null, "point_commentary_node") != null

/**
 * @param {CBaseEntity|null} ent
 * @param {string} attrib
 * @returns {integer}
 */
function ROOT::CALL_ATTRIB_HOOK_INT_ON_OTHER(ent, attrib, def = 0)
{
	if(!ent || !ent.IsValid())
		return def

	local base_val = def
	if(ent.IsPlayer())
		base_val = ent.GetCustomAttribute(attrib, def)
	else 
		base_val = ent.GetAttribute(attrib, def)
	local wep_mult = 1.0
	if(ent.IsPlayer())
	{
		foreach (weapon in GetAllWeapons())
		{
			if(weapon.GetAttribute("provide on active", 0) && weapon != ent.GetActiveWeapon())
				continue
			wep_mult *= weapon.GetAttribute(attrib, def)
		}
	}
	return base_val * wep_mult
}
/**
 * @param {CBaseEntity|null} ent
 * @param {string} attrib
 * @returns {float}
 */
function ROOT::CALL_ATTRIB_HOOK_FLOAT_ON_OTHER(ent, attrib, def = 0.0)
{
	if(!ent || !ent.IsValid())
		return def

	local base_val = def
	if(ent.IsPlayer())
		base_val = ent.GetCustomAttribute(attrib, def)
	else 
		base_val = ent.GetAttribute(attrib, def)
	local wep_mult = 1.0
	if(ent.IsPlayer())
	{
		foreach (weapon in GetAllWeapons())
		{
			if(weapon.GetAttribute("provide on active", 0) && weapon != ent.GetActiveWeapon())
				continue
			wep_mult *= weapon.GetAttribute(attrib, def)
		}
	}
	return base_val * wep_mult
}
/**
 * @param {CBaseEntity|null} ent
 * @returns {int}
 */
function ROOT::CanTakeDamage(ent)
{
	if(!ent || !ent.IsValid())
		return DAMAGE_NO
	return GetPropInt(ent, "m_takedamage")
}

/**
 * @param {integer} iType
 * @returns {bool}
 */
function ROOT::IsDOTDmg( iType )
{
	return	iType == TF_DMG_CUSTOM_BURNING ||
		 	iType == TF_DMG_CUSTOM_BURNING_FLARE ||
		 	iType == TF_DMG_CUSTOM_BURNING_ARROW ||
		 	iType == TF_DMG_CUSTOM_BLEEDING
}

/**
 * @param {int} iType
 * @returns {bool}
 */
function ROOT::IsHeadshot( iType ) 
	return iType == TF_DMG_CUSTOM_HEADSHOT || iType == TF_DMG_CUSTOM_HEADSHOT_DECAPITATION

/**
 * @param {CBaseEntity|null} ent
 * @returns {CTFPlayer|null}
 */
function ROOT::ToTFPlayer(ent)
{
	if(!ent || !ent.IsValid() || !ent.IsPlayer())
		return null
	return ent
}
/**
 * @param {CBaseEntity|null} ent
 * @returns {CTFBot|null}
 */
function ROOT::ToTFBot(ent)
{
	if(!ent || !ent.IsValid() || !ent.IsPlayer() || !ent.IsBot())
		return null
	return ent
}

/** 
 * @param {CBaseEntity|null} ent
 * @returns {CTFWeaponBase|null}
 */
function ROOT::ToBaseWeapon(ent)
{
	if(!ent || !ent.IsValid() || !startswith(ent.GetClassname(), "tf_wea"))
		return null
	return ent
}

/** 
 * @param {CBaseEntity|null} ent
 * @returns {CBaseEntity|null}
 */
function ROOT::ToBaseObject(ent)
{
	if(!ent || !ent.IsValid() || !IsBaseObject(ent))
		return null
	return ent
}

::PipeBombClassnames <- [
	"tf_projectile_pipe",
	"tf_projectile_pipe_remote",
	"tf_projectile_jar", 
	"tf_projectile_jar_gas", 
	"tf_projectile_jar_milk",
	"tf_projectile_stun_ball",
	"tf_projectile_ball_ornament",
	"tf_projectile_cleaver",

	"tf_projectile_spellbats",
	"tf_projectile_spellmirv",
	"tf_projectile_spelltransposeteleport",
	"tf_projectile_spellspawnzombie",
	"tf_projectile_spellspawnhorde",
	"tf_projectile_spellspawnboss",
	"tf_projectile_spellkartorb",
	"tf_projectile_spellmeteorshower",

	"tf_projectile_throwable",
	"tf_projectile_throwable_repel",
	"tf_projectile_throwable_brick",
	"tf_projectile_throwable_breadmonster",
]
::RocketClassnames <- [
	"tf_projectile_rocket",
	"tf_projectile_sentryrocket",
	"tf_projectile_arrow",
	"tf_projectile_healing_bolt",
	"tf_projectile_grapplinghook",
	"tf_projectile_energy_ball",
	"tf_projectile_flare",
	"tf_projectile_balloffire",
	"tf_projectile_mechanicalarmorb",

	"tf_projectile_spellfireball",
	"tf_projectile_lightningorb",
]
/**
 * reutrns if an entity is a projectile
 * @param {CBaseEntity|null} ent
 * @returns {bool}
 */
function ROOT::IsProjectile(ent)
{
	if(!ent || !ent.IsValid() || !startswith(ent.GetClassname(), "tf_proj"))
		return false
	return true
}
/** 
 * @param {CBaseEntity|null} ent
 * @returns {CBaseEntity|null}
 */
function ROOT::ToBaseGrenade(ent)
{
	if(!IsProjectile(ent) || !IsInArray(ent.GetClassname(), PipeBombClassnames))
		return null
	return ent
}
/** 
 * @param {CBaseEntity|null} ent
 * @returns {CBaseEntity|null}
 */
function ROOT::ToBaseRocket(ent)
{
	if(!IsProjectile(ent) || !IsInArray(ent.GetClassname(), RocketClassnames))
		return null
	return ent
}

/**
 * @param {CBaseEntity|null} ent
 * @returns {bool}
 */
function ROOT::IsBaseObject(ent)
{
	if(!ent || !ent.IsValid())
		return false
	return startswith(ent.GetClassname(), "obj_")
}
/**
 * @param {CBaseEntity|null} ent
 * @returns {bool}
 */
function ROOT::IsSentry(ent)
{
	if(!ent || !ent.IsValid() || !IsBaseObject(ent))
		return false
	return ent.GetClassname() == "obj_sentrygun"
}
/**
 * @param {CBaseEntity|null} ent
 * @returns {bool}
 */
function ROOT::IsSentryRocket(ent)
{
	if(!ent || !ent.IsValid())
		return false
	return ent.GetClassname() == "tf_projectile_sentry_rocket"
}


/**
 * @param {int} clas
 * @returns {bool}
 */
function CTFPlayer::IsPlayerClass(clas)
	return GetPlayerClass() == clas

function CTFPlayer::IsDominant()
	return InCond(TF_COND_POWERUPMODE_DOMINANT)

function CTFPlayer::LastHitGroup()
	return GetPropInt(this, "m_LastHitGroup")

function CTFPlayer::HasPasstimeBall()
	return GetPropBool(this, "m_Shared.m_bHasPasstimeBall")

function CTFPlayer::IsInPurgatory()
	return InCond( TF_COND_PURGATORY )

function IsTruceValidForEnt(entity)
{
	if(!entity)
		return false
	else if(entity.IsPlayer())
		return entity.IsTruceValidForEnt()
	else if(entity.GetClassname() == "obj_sentrygun")
		return true
	else
		return GetPropBool(entity, "m_bTruceValidForEnt")
}

function CTFPlayer::CBaseCombatCharacter_OnTakeDamage( info )
{
	if (!CanTakeDamage(this))
		return 0

	SetPropInt(this, "m_iDamageCount", GetPropInt(this, "m_iDamageCount") + 1)

	switch( GetPropInt(this, "m_lifeState") )
	{
	case LIFE_ALIVE:
		return OnTakeDamage_Alive( info ) // Actually calls CTFPlayer::OnTakeDamage_Alive, Not CBaseCombatCharacter::OnTakeDamage_Alive
	case LIFE_DYING:
		return 1
	default:
		if ( GetHealth() <= 0 && ( ( info.GetDamageType() & ( DMG_CRUSH | DMG_FALL | DMG_BLAST | DMG_SONIC | DMG_CLUB ) ) != 0 ) && ShouldGib( info ) )
			return 0
		return 1
	}
}

function CTFPlayer::ShouldGib( info )
{
	// Check to see if we should allow players to gib.
	local tf_playergib = IsCvarAllowed("tf_playergib") ? GetCvarInt("tf_playergib") : 1

	if ( tf_playergib != 1 )
	{
		if ( tf_playergib < 1 )
			return false
		else
			return true
	}

	// normal players/bots don't gib in MvM
	if ( IsMannVsMachineMode() && IsBot() ) // remove IsBot for feature to return
		return false

	// Are we set up to gib always on critical hits?
	if ( info.GetDamageType() & DMG_CRITICAL )
	{
		local iAlwaysGibOnCrit = CALL_ATTRIB_HOOK_INT_ON_OTHER( info.GetWeapon(), "crit kill will gib" )
		if ( iAlwaysGibOnCrit )
			return true
	}

	if ( info.GetDamageCustom() == TF_DMG_CUSTOM_CROC )
		return true

	local iCritOnHardHit = CALL_ATTRIB_HOOK_INT_ON_OTHER( info.GetWeapon(), "crit on hard hit" )
	if ( iCritOnHardHit == 0 )
	{
		// Only blast & half falloff damage can gib.
		if ( ( (info.GetDamageType() & DMG_BLAST) == 0 ) &&
			( (info.GetDamageType() & DMG_HALF_FALLOFF) == 0 ) )
			return false;
	}

	// Explosive crits always gib.
	if ( info.GetDamageType() & DMG_CRITICAL )
		return true;

	// Hard hits also gib.
	if ( GetHealth() <= -10 )
		return true;
	
	if ( GetInternalVar("m_bGoingFeignDeath", false) )
	{
		// The player won't actually have negative health,
		// but spies often gib from explosive damage so we should make that likely here.
		local frand = rand().tofloat() / 0x7FFF
		return (frand>0.15) ? true : false;
	}

	return false
}


/**
 * the ROOT should actually be gamerules, but idgaf
 * @param {CTakeDamageInfo} info
 * @param {CBaseEntity} pVictimBaseEntity
 * @param {table} outParams
 * @returns {float}
 */
function ROOT::ApplyOnDamageAliveModifyRules( info, pVictimBaseEntity, outParams )
{
	// printl("[DEBUG] Made it to CTFGamerules::ApplyOnDamageAliveModifyRules")
	local pVictim = ToTFPlayer(pVictimBaseEntity)
	local pAttacker = info.GetAttacker()
	local pTFAttacker = ToTFPlayer(pAttacker)

	local flRealDamage = info.GetDamage()

	local iAttackIgnoresResists = CALL_ATTRIB_HOOK_INT_ON_OTHER( info.GetWeapon(), "mod_pierce_resists_absorbs" ) 

	if ( pVictimBaseEntity && CanTakeDamage(pVictimBaseEntity) != DAMAGE_EVENTS_ONLY && pVictim )
	{
		local iDamageTypeBits = info.GetDamageType() & DMG_IGNITE

		// Handle attributes that want to change our damage type, but only if we're taking damage from a non-DOT. This
		// stops fire DOT damage from constantly reigniting us. This will also prevent ignites from happening on the
		// damage *from-a-bleed-DOT*, but not from the bleed application attack.
		if ( !IsDOTDmg( info.GetDamageCustom() ) )
		{
			local iAddBurningDamageType = CALL_ATTRIB_HOOK_INT_ON_OTHER( info.GetWeapon(), "Set DamageType Ignite" )
			if ( iAddBurningDamageType )
				iDamageTypeBits = iDamageTypeBits | DMG_IGNITE
		}

		// Start burning if we took ignition damage
		outParams.bIgniting = ( ( iDamageTypeBits & DMG_IGNITE ) && ( !pVictim || pVictim.GetWaterLevel() < WL_Waist ) )

		if ( outParams.bIgniting && pVictim )
		{
			if ( pVictim.InCond( TF_COND_DISGUISED ) )
			{
				local iDisguiseNoBurn = CALL_ATTRIB_HOOK_INT_ON_OTHER( pVictim, "disguise no burn" )
				if ( iDisguiseNoBurn == 1 )// Do a hard out in the caller
					return -1.0
			}

			if ( pVictim.InCond( TF_COND_FIRE_IMMUNE ) )// Do a hard out in the caller
				return -1.0
		}

		// When obscured by smoke, attacks have a chance to miss
		if ( pVictim && pVictim.InCond( TF_COND_OBSCURED_SMOKE ) )
		{
			if ( RandomInt( 1, 4 ) >= 2 )
			{
				flRealDamage = 0.0
				return -1.0
			}
		}

		// Proc invicibility upon being hit
		local flUberChance = CALL_ATTRIB_HOOK_FLOAT_ON_OTHER( pVictim, "uber on damage taken", 0.0)
		if( RandomFloat(0.0, 1.0) < flUberChance )
		{
			pVictim.AddCondEx( TF_COND_INVULNERABLE_CARD_EFFECT, 3.0, pVictim)
			// Make sure we don't take any damage
			flRealDamage = 0.0
		}

		// Resists and Boosts
		local flDamageBonus = info.GetDamageBonus()
		local flDamageBase = flRealDamage - flDamageBonus

		local iPierceResists = CALL_ATTRIB_HOOK_INT_ON_OTHER( info.GetWeapon(), "mod_pierce_resists_absorbs" )

		// This raw damage wont get scaled.  Used for determining how much health to give resist medics.
		local flRawDamage = flDamageBase
		
		if ( !iPierceResists )
		{
			// Reduce only the crit portion of the damage with crit resist
			local bCrit = ( info.GetDamageType() & DMG_CRITICAL ) > 0
			if ( bCrit )
			{
				// Break the damage down and reassemble
				flDamageBonus *= CALL_ATTRIB_HOOK_FLOAT_ON_OTHER( pVictim, "dmg taken from crit reduced", 1.0)
				flDamageBonus *= CALL_ATTRIB_HOOK_FLOAT_ON_OTHER( pVictim, "dmg taken from crit increased", 1.0)
				flDamageBonus *= CALL_ATTRIB_HOOK_FLOAT_ON_OTHER( pVictim, "SET BONUS: dmg taken from crit reduced set bonus", 1.0)
			}

			// Apply general dmg type reductions. Should we only ever apply one of these? (Flaregun is DMG_BULLET|DMG_IGNITE, for instance)
			if ( info.GetDamageType() & (DMG_BURN|DMG_IGNITE) )
			{
				flDamageBase *= CALL_ATTRIB_HOOK_FLOAT_ON_OTHER( pVictim, "dmg taken from fire reduced", 1.0)
				flDamageBase *= CALL_ATTRIB_HOOK_FLOAT_ON_OTHER( pVictim, "dmg taken from fire increased", 1.0)
				flDamageBase *= CALL_ATTRIB_HOOK_FLOAT_ON_OTHER( pVictim, "SET BONUS: dmg taken from fire reduced set bonus", 1.0)
				flDamageBase *= CALL_ATTRIB_HOOK_FLOAT_ON_OTHER( pVictim.GetActiveWeapon(), "dmg taken from fire reduced on active", 1.0)
			}

			if ( pTFAttacker && pVictim && pVictim.InCond( TF_COND_BURNING ) )
				flDamageBase *= CALL_ATTRIB_HOOK_FLOAT_ON_OTHER( pTFAttacker.GetActiveWeapon(), "damage bonus vs burning", 1.0)

			if ( (info.GetDamageType() & (DMG_BLAST) ) )
			{
				local bReduceBlast = false

				// If someone else shot us or we're in MvM
				if( pAttacker != pVictimBaseEntity || IsMannVsMachineMode() )
				{
					bReduceBlast = true
				}

				if ( bReduceBlast )
				{
					flDamageBase *= CALL_ATTRIB_HOOK_FLOAT_ON_OTHER( pVictim, "dmg taken from blast reduced", 1.0)
					flDamageBase *= CALL_ATTRIB_HOOK_FLOAT_ON_OTHER( pVictim, "dmg taken from blast increased", 1.0)
				}
			}

			if ( info.GetDamageType() & (DMG_BULLET|DMG_BUCKSHOT) )
			{
				flDamageBase *= CALL_ATTRIB_HOOK_FLOAT_ON_OTHER( pVictim, "dmg taken from bullets reduced", 1.0 )
				flDamageBase *= CALL_ATTRIB_HOOK_FLOAT_ON_OTHER( pVictim, "dmg taken from bullets increased", 1.0 )
				flDamageBase *= CALL_ATTRIB_HOOK_FLOAT_ON_OTHER( pVictim, "SET BONUS: dmg taken from bullets increased", 1.0 )
				flDamageBase *= CALL_ATTRIB_HOOK_FLOAT_ON_OTHER( pVictim, "CARD: dmg taken from bullets reduced", 1.0 )
			}

			if ( info.GetDamageType() & DMG_MELEE )
			{
				flDamageBase *= CALL_ATTRIB_HOOK_FLOAT_ON_OTHER( pVictim, "dmg taken from melee", 1.0 )
				flDamageBase *= CALL_ATTRIB_HOOK_FLOAT_ON_OTHER( pVictim.GetActiveWeapon(), "dmg from melee increased", 1.0 )
			}

			if ( pVictim.IsPlayerClass( TF_CLASS_HEAVYWEAPONS ) && pVictim.InCond( TF_COND_AIMING ) && ( ( pVictim.GetHealth() - flRealDamage ) / pVictim.GetMaxHealth() ) <= 0.5 )
			{
				flDamageBase *= CALL_ATTRIB_HOOK_FLOAT_ON_OTHER( pVictim, "spunup_damage_resistance", 1.0 )
			}
		}

		// If the damage changed at all play the resist sound
		if ( flDamageBase != flRawDamage )
			outParams.bPlayDamageReductionSound = true

		// Stomp flRealDamage with resist adjusted values
		flRealDamage = flDamageBase + flDamageBonus

		// Some Powerups apply a damage multiplier. Backstabs are immune to resist protection
		if ( ( pVictim && info.GetDamageCustom() != TF_DMG_CUSTOM_BACKSTAB ) )
		{
			// Plague bleed damage is immune from resist calculation
			if ( ( !pVictim.InCond( TF_COND_PLAGUE ) && info.GetDamageCustom() != TF_DMG_CUSTOM_BLEEDING ) )
			{
				if ( pVictim.GetCurrentRune() == RUNE_RESIST )
				{
					flRealDamage *= ( pVictim.IsDominant() ? 0.65 : 0.5 )
					outParams.bPlayDamageReductionSound = true
				}
				else if ( ( pVictim.GetCurrentRune() == RUNE_VAMPIRE ) && !pVictim.IsDominant() )
				{
					flRealDamage *= 0.75
					outParams.bPlayDamageReductionSound = true
				}
				//Plague powerup carrier is resistant to infected enemies
				else if ( pTFAttacker && ( pVictim.GetCurrentRune() == RUNE_PLAGUE ) && pTFAttacker.InCond( TF_COND_PLAGUE ) )
				{
					outParams.bPlayDamageReductionSound = true
					if (pVictim.IsDominant() ) //dominant plague carrying players get less resistance to infected attackers
						flRealDamage *= 0.80
					else
						flRealDamage *= 0.5
				}
			}
		}

		// End Resists

		// Increased damage taken from all sources
		flRealDamage *= CALL_ATTRIB_HOOK_FLOAT_ON_OTHER( pVictim, "dmg taken increased", 1.0 )
		flRealDamage *= CALL_ATTRIB_HOOK_FLOAT_ON_OTHER( pVictim.GetActiveWeapon(), "mult_dmgtaken_active", 1.0 )

		if ( info.GetInflictor() )
		{
			if ( IsBaseObject( info.GetInflictor() ) )
			{
				if( IsSentry( info.GetInflictor() ) )
					flRealDamage *= CALL_ATTRIB_HOOK_FLOAT_ON_OTHER( pVictim, "SET BONUS: dmg from sentry reduced", 1.0 )
			}
			else
			{
				local pSentryRocket = info.GetInflictor()
				if( IsSentryRocket( pSentryRocket ) && pSentryRocket.GetOwner() )
				{
					local sentry = pSentryRocket.GetOwner()
					if ( IsSentry( sentry ) )
						flRealDamage *= CALL_ATTRIB_HOOK_FLOAT_ON_OTHER( pVictim, "SET BONUS: dmg from sentry reduced", 1.0 )
				}
			}
		}

		if ( IsMannVsMachineMode() )
		{
			if ( pTFAttacker && pTFAttacker.IsBot() && pAttacker != pVictimBaseEntity && pVictim && !pVictim.IsBot() )
			{
				if(IsConvarAllowed("tf_populator_damage_multiplier"))
					flRealDamage *= GetCvarFloat("tf_populator_damage_multiplier")
			}
		}

		// Heavy rage-based knockback+stun effect that also reduces their damage output
		if ( pTFAttacker && pTFAttacker.IsPlayerClass( TF_CLASS_HEAVYWEAPONS ) )
		{
			local iRage = CALL_ATTRIB_HOOK_INT_ON_OTHER( pTFAttacker, "generate rage on damage", 0 )
			if ( iRage && pTFAttacker.IsRageDraining() )
				flRealDamage *= 0.5
		}

		if ( pVictim && pVictim.GetActiveWeapon() && !iAttackIgnoresResists )
		{
			if ( info.GetDamageType() & (DMG_CLUB) )
				flRealDamage *= CALL_ATTRIB_HOOK_FLOAT_ON_OTHER( pVictim.GetActiveWeapon(), "mult_dmgtaken_active", 1.0 )
			else if ( info.GetDamageType() & (DMG_BLAST|DMG_BULLET|DMG_BUCKSHOT|DMG_IGNITE|DMG_SONIC) )
				flRealDamage *= CALL_ATTRIB_HOOK_FLOAT_ON_OTHER( pVictim.GetActiveWeapon(), "dmg from ranged reduced", 1.0 )
		}

		outParams.bSendPreFeignDamage = false
		if ( pVictim && pVictim.IsPlayerClass( TF_CLASS_SPY ) && ( info.GetDamageCustom() != TF_DMG_CUSTOM_TELEFRAG ) && !pVictim.IsTaunting() && !iAttackIgnoresResists )
		{
			// Reduce damage taken if we have recently feigned death.
			if ( pVictim.InCond( TF_COND_FEIGN_DEATH ) || pVictim.IsFeignDeathReady() )
			{
				// Damage reduction is proportional to cloak remaining (60%->20%)
				local tf_feign_death_damage_scale = IsConvarAllowed("tf_feign_death_damage_scale") ? GetCvarFloat("tf_feign_death_damage_scale") : 0.35
				local tf_stealth_damage_reduction = IsConvarAllowed("tf_stealth_damage_reduction") ? GetCvarFloat("tf_stealth_damage_reduction") : 0.8
				local flDamageReduction = MATH.RemapValClamped( pVictim.GetSpyCloakMeter(), 50.0, 0.0, tf_feign_death_damage_scale, tf_stealth_damage_reduction )

				// On Activate Reduce Remaining Cloak by 50%
				if ( pVictim.IsFeignDeathReady() )
					flDamageReduction = IsConvarAllowed("tf_feign_death_activate_damage_scale") ? GetCvarFloat("tf_feign_death_activate_damage_scale") : 0.25
				outParams.bSendPreFeignDamage = true

				flRealDamage *= flDamageReduction
			}
			// Standard Stealth gives small damage reduction
			else if ( pVictim.InCond( TF_COND_STEALTHED ) )
				flRealDamage *= IsConvarAllowed("tf_stealth_damage_reduction") ? GetCvarFloat("tf_stealth_damage_reduction") : 0.8
		}

		if ( IsConvarAllowed("sv_cheats") && GetCvarBool("sv_cheats") == false )
		{
			if ( flRealDamage <= 0.0 )// Do a hard out in the caller
				return -1
		}
		else
		{
			// allow negative health values for things like the hurtme command
			if ( flRealDamage == 0.0 )// Do a hard out in the caller
				return -1
		}

		if ( pAttacker == pVictimBaseEntity && (info.GetDamageType() & DMG_BLAST) &&
			 info.GetDamagedOtherPlayers() == 0 && (info.GetDamageCustom() != TF_DMG_CUSTOM_TAUNTATK_GRENADE) )
		{
			// If we attacked ourselves, hurt no other players, and it is a blast,
			// check the attribute that reduces rocket jump damage.
			flRealDamage *= CALL_ATTRIB_HOOK_FLOAT_ON_OTHER( info.GetAttacker(), "rocket jump damage reduction", 1.0)
			flRealDamage *= CALL_ATTRIB_HOOK_FLOAT_ON_OTHER( info.GetAttacker(), "rocket jump damage reduction HIDDEN", 1.0)
			outParams.bSelfBlastDmg = true
		}

		if ( pAttacker == pVictimBaseEntity )
		{
			if ( info.GetWeapon() )
			{
				local iNoSelfBlastDamage = CALL_ATTRIB_HOOK_INT_ON_OTHER( info.GetWeapon(), "no self blast dmg" )

				local bIgnoreThisSelfDamage = ( iNoSelfBlastDamage == 1 ) || ( (iNoSelfBlastDamage == 2) && (info.GetDamageCustom() == TF_DMG_CUSTOM_PRACTICE_STICKY) )
				if ( bIgnoreThisSelfDamage )
					flRealDamage = 0

				flRealDamage *= CALL_ATTRIB_HOOK_FLOAT_ON_OTHER( info.GetWeapon(), "blast dmg to self increased", 1.0)
			}
		}

		// Precision Powerup removes self damage
		if ( pTFAttacker == pVictim && pTFAttacker.GetCurrentRune() == RUNE_PRECISION )
			flRealDamage = 0.0
	}

	return flRealDamage
}

/**
 * the ROOT should actually be gamerules, but idgaf
 * @param {CTakeDamageInfo} info
 * @param {CBaseEntity} pVictimBaseEntity
 * @param {bool} bAllowDamage
 * @returns {bool}
 */
function ROOT::ApplyOnDamageModifyRules( info, pVictimBaseEntity, bAllowDamage )
{
	// printf("[DEBUG]: \n\tStarting Damage: %f\n", info.GetDamage())
	if ( !info.GetDamageForForceCalc() ) 
		info.SetDamageForForceCalc( info.GetDamage() )

	/** @type {CTFPlayer|null} */
	local pVictim = ToTFPlayer( pVictimBaseEntity )
	local pAttacker = info.GetAttacker()
	/** @type {CTFPlayer|null} */
	local pTFAttacker = ToTFPlayer( pAttacker )
	/** @type {CTFWeaponBase|null} */
	local pWeapon = ToBaseWeapon( info.GetWeapon() )

	local iAttackIgnoresResists = CALL_ATTRIB_HOOK_INT_ON_OTHER( pWeapon, "dmg pierces resists absorbs" )

	local function MakeCrit()
	{
		info.AddDamageType( DMG_CRITICAL )
		info.SetCritType( CTakeDamageInfo.ECritType.CRIT_FULL )
	}

	local function MakeMinicrit() 
	{
		info.SetCritType( CTakeDamageInfo.ECritType.CRIT_MINI )
		eBonusEffect = kBonusEffect_MiniCrit
	}

	local function RemoveCrit( bits = -1)
	{
		info.SetDamageType( (bits == -1 ? info.GetDamageType() : bits ) & (~DMG_CRITICAL) )
		info.SetCritType( CTakeDamageInfo.ECritType.CRIT_NONE )
	}

	// damage may not come from a weapon (ie: Bosses, etc)
	// The existing code below already checked for null pWeapon, anyways
	local flDamage = info.GetDamage()

	local bShowDisguisedCrit = false
	local bAllSeeCrit = false
	local eBonusEffect = kBonusEffect_None

	if ( pVictim )
	{
		pVictim.SetInternalVar("m_bAllSeeCrit", false)
		pVictim.SetInternalVar("m_bMiniCrit", false)
		pVictim.SetInternalVar("m_bShowDisguisedCrit", false)
		pVictim.SetInternalVar("m_eBonusAttackEffect", kBonusEffect_None)
	}

	local bitsDamage = info.GetDamageType()

	// Capture this before anybody mucks with it
	if ( !info.BaseDamageIsValid() )
		info.CopyDamageToBaseDamage()

	// Damage type was already crit (Flares / headshot)
	if ( bitsDamage & DMG_CRITICAL )
		info.SetCritType( CTakeDamageInfo.ECritType.CRIT_FULL )

	// First figure out whether this is going to be a full forced crit for some specific reason. It's
	// important that we do this before figuring out whether we're going to be a minicrit or not.

	// Allow attributes to force critical hits on players with specific conditions
	if ( pVictim )
	{
		// Crit against players that have these conditions
		local iCritDamageTypes = 0
		iCritDamageTypes += CALL_ATTRIB_HOOK_INT_ON_OTHER( pWeapon, "crit vs burning players")
		iCritDamageTypes += CALL_ATTRIB_HOOK_INT_ON_OTHER( pWeapon, "crit vs disguised players")
		iCritDamageTypes += CALL_ATTRIB_HOOK_INT_ON_OTHER( pWeapon, "crit vs disguised players")

		if ( iCritDamageTypes )
		{
			// iCritDamageTypes is an or'd list of types. We need to pull each bit out and
			// then test against what that bit in the items_master file maps to.
			for ( local i = 0; condition_to_attribute_translation[i] != TF_COND_LAST; i++ )
			{
				if ( iCritDamageTypes & ( 1 << i ) )
				{
					if ( pVictim.InCond( condition_to_attribute_translation[ i ] ) )
					{
						bitsDamage = bitsDamage | DMG_CRITICAL
						MakeCrit()

						if ( condition_to_attribute_translation[i] == TF_COND_DISGUISED || 
							 condition_to_attribute_translation[i] == TF_COND_DISGUISING )
						{
							// if our attribute specifically crits disguised enemies we need to show it on the client
							bShowDisguisedCrit = true
						}
						break
					}
				}
			}
		}

		local iCritVsWet = CALL_ATTRIB_HOOK_INT_ON_OTHER( pWeapon, "crit vs wet players" )
		if ( iCritVsWet )
		{
			if ( pVictim.InCond( TF_COND_URINE ) || pVictim.InCond( TF_COND_MAD_MILK ) || pVictim.InCond( TF_COND_GAS ) || ( pVictim.GetWaterLevel() > WL_NotInWater ))
			{
				bitsDamage = bitsDamage | DMG_CRITICAL
				MakeCrit()
			}
		}
 
		// Crit against players that don't have these conditions
		local iCritDamageNotTypes = CALL_ATTRIB_HOOK_INT_ON_OTHER( pWeapon, "crit vs non burning players" )

		if ( iCritDamageNotTypes )
		{
			// iCritDamageTypes is an or'd list of types. We need to pull each bit out and
			// then test against what that bit in the items_master file maps to.
			for ( local i = 0; condition_to_attribute_translation[i] != TF_COND_LAST; i++ )
			{
				if ( iCritDamageNotTypes & ( 1 << i ) )
				{
					if ( !pVictim.InCond( condition_to_attribute_translation[ i ] ) )
					{
						bitsDamage = bitsDamage | DMG_CRITICAL
						MakeCrit()

						if ( condition_to_attribute_translation[ i ] == TF_COND_DISGUISED || 
							 condition_to_attribute_translation[ i ] == TF_COND_DISGUISING )
						{
							// if our attribute specifically crits disguised enemies we need to show it on the client
							bShowDisguisedCrit = true
						}
						break
					}
				}
			}
		}

		// Crit burning behind
		local iCritBurning = CALL_ATTRIB_HOOK_INT_ON_OTHER( pWeapon, "axtinguisher properties" )
		if ( iCritBurning && pVictim.InCond( TF_COND_BURNING ) )
		{
			local toEnt = pVictim.GetOrigin() - pTFAttacker.GetOrigin()
			// Full crit in back, mini in front
			local entForward = pVictim.EyeAngles().Forward()
			toEnt.z = 0
			toEnt.Norm()
			
			if ( toEnt.Dot( entForward ) > 0.0 )	// 90 degrees from center (total of 180)
			{
				bitsDamage = bitsDamage | DMG_CRITICAL
				MakeCrit()
			}
			else
			{
				bAllSeeCrit = true
				MakeMinicrit()
			}
		}
	}
	// no airborne crit bonus in Mannpower
	if ( !IsPowerupMode() )
	{
		local iCritWhileAirborne = CALL_ATTRIB_HOOK_INT_ON_OTHER( pWeapon, "mod crit while airborne" )
		if ( iCritWhileAirborne && pTFAttacker )
		{
			if ( pTFAttacker.InAirDueToExplosion() )
			{
				bitsDamage = bitsDamage | DMG_CRITICAL
				MakeCrit()
			}
		}
	}
	
	// Some forms of damage override long range damage falloff
	local bIgnoreLongRangeDmgEffects = false

	// Figure out if it's a minicrit or not
	// But we never minicrit ourselves.
	if ( pAttacker != pVictimBaseEntity )
	{
		// attack_minicrits_and_consumes_burning
		if ( pWeapon && pTFAttacker && pVictim && pVictim.InCond( TF_COND_BURNING ) )
		{
			local iConsumeFlames = CALL_ATTRIB_HOOK_INT_ON_OTHER( pTFAttacker.GetActiveWeapon(), "attack_minicrits_and_consumes_burning" )
			if ( iConsumeFlames && pWeapon == pTFAttacker.GetActiveWeapon() && ( info.GetDamageType() & DMG_MELEE ) )
			{
				local flConsumeBonus = MATH.RemapValClamped( pVictim.GetCondDuration(TF_COND_BURNING), 0.5, TF_BURNING_FLAME_LIFE, 20., ( TF_BURNING_DMG * 20 ).tofloat() )
				
				printf("[DEBUG]: \n\tAdding %f Damage to Bonus\n", flConsumeBonus)
				flDamage += flConsumeBonus
				pVictim.RemoveCondEx( TF_COND_BURNING, true )
				pVictim.EmitSound( "TFPlayer.FlameOut" )

				if ( info.GetCritType() == CTakeDamageInfo.ECritType.CRIT_NONE )
					MakeMinicrit()

				info.SetDamageCustom( TF_DMG_CUSTOM_AXTINGUISHER_BOOSTED )
			}
		}

		if ( info.GetCritType() == CTakeDamageInfo.ECritType.CRIT_NONE )
		{
			/* local function MakeMinicrit()
			{
				local t = getstackinfos(2)
				if(t)
				{
					printf("Line %d called MakeMinicrit\n", t.line)
				}
				info.SetCritType( CTakeDamageInfo.ECritType.CRIT_MINI )
				eBonusEffect = kBonusEffect_MiniCrit
			} */

			local pInflictor = info.GetInflictor()
			local pBaseGrenade = ToBaseGrenade( pInflictor )
			local pBaseRocket = ToBaseRocket( pInflictor )

			if ( ( pVictim && pVictim.IsMinicritDebuffed() ) || ( pTFAttacker && pTFAttacker.IsMinicritBuffed() ) ||
				 ( pTFAttacker && ( bitsDamage & DMG_RADIUS_MAX ) && pWeapon && ( pWeapon.CanChargeCrit() ) )
			) // Attackers buffed by the soldier do mini-crits.
			  // First sword or bottle attack after a charge is a mini-crit.
			{
				bAllSeeCrit = true
				MakeMinicrit()
			}
			else if ( ( pInflictor && !pInflictor.IsPlayer() ) && ( ( pBaseRocket || pBaseGrenade ) && GetPropInt( pInflictor, "m_iDeflected" ) != 0 ) )
			{
				// Reflected rockets, grenades (non-remote detonate), arrows always mini-crit
				MakeMinicrit()
			}
			else if ( info.GetDamageCustom() == TF_DMG_CUSTOM_PLASMA_CHARGED || info.GetDamageCustom() == TF_DMG_CUSTOM_CLEAVER_CRIT )
			{
				// Charged plasma shots do minicrits. // Long range cleaver hit
				MakeMinicrit()
			}
			else if ( ( info.GetDamageType() & DMG_IGNITE ) && pVictim && pVictim.InCond( TF_COND_BURNING ) && info.GetDamageCustom() == TF_DMG_CUSTOM_BURNING_FLARE )
			{
				if ( pWeapon && pWeapon.GetAttribute( "lunchbox adds minicrits", 0 ) == 2 )
					MakeMinicrit()
			}
			else if ( pTFAttacker && pWeapon && pWeapon.GetIDX() == 1178 && info.GetDamageCustom() == TF_DMG_CUSTOM_DRAGONS_FURY_BONUS_BURNING )
				eBonusEffect = kBonusEffect_DragonsFury
			else if ( pTFAttacker && pTFAttacker.IsPlayerClass( TF_CLASS_SCOUT ) && !( pTFAttacker.GetFlags() & FL_ONGROUND ) )
			{
				// Make sure the weapon that did this damage is the same as the one that grants mini-crits
				if ( info.GetWeapon() == pTFAttacker.GetActiveWeapon() && CALL_ATTRIB_HOOK_INT_ON_OTHER( pTFAttacker.GetActiveWeapon(), "air dash count" ) )
					MakeMinicrit()
			}
			else if ( pVictim && pTFAttacker && pTFAttacker.IsPlayerClass( TF_CLASS_SNIPER ) && pWeapon && pWeapon.IsSniperRifle() )
			{
				if ( IsHeadshot( info.GetDamageCustom() ) || pVictim.LastHitGroup() == HITGROUP_HEAD && pWeapon.IsZoomed() && pWeapon.GetJarateTime() >= 1.0 )
					MakeMinicrit()
			}
			else
			{
				// Allow Attributes to shortcut out if found, no need to check all of them
				for ( local i = 0; i < 1; ++i )
				{
					// Some weapons force minicrits on burning targets.
					// Does not work for burn but works for ignite
					local iForceMiniCritOnBurning = CALL_ATTRIB_HOOK_INT_ON_OTHER( pWeapon, "minicrit vs burning player" )
					if ( iForceMiniCritOnBurning == 1 && pVictim && pVictim.InCond( TF_COND_BURNING ) && !( info.GetDamageType() & DMG_BURN ) )
					{
						bAllSeeCrit = true
						MakeMinicrit()
						break
					}

					// Some weapons mini-crit airborne targets. Airborne targets are any target that has been knocked 
					// into the air by an explosive force from an enemy.
					// no airborne crits or mini crits in Mannpower since the whole idea is to fly around. It's too easy to score crits against grappling players, and we don't want to penalize airborne targets
					if ( !IsPowerupMode() )
					{
						local iMiniCritAirborne = CALL_ATTRIB_HOOK_INT_ON_OTHER( pWeapon, "mod mini-crit airborne" )
						if ( iMiniCritAirborne == 1 && pVictim && ( pVictim.InAirDueToExplosion() ) )
						{
							bAllSeeCrit = true
							MakeMinicrit()
							break
						}
					}

					//// Some weapons minicrit *any* target in the air, regardless of how they got there.
					local iMiniCritAirborneDeploy = CALL_ATTRIB_HOOK_INT_ON_OTHER( pWeapon, "mod mini-crit airborne deploy" )
					if ( iMiniCritAirborneDeploy > 0 && pWeapon && pVictim && !( pVictim.GetFlags() & FL_ONGROUND ) && ( pVictim.GetWaterLevel() == WL_NotInWater ) )
					{
						bAllSeeCrit = true
						MakeMinicrit()
						break
					}
				}
			}

			// Some Powerups remove distance damage falloff
			if ( pTFAttacker && ( pTFAttacker.GetCurrentRune() == RUNE_STRENGTH || pTFAttacker.GetCurrentRune() == RUNE_PRECISION ) )
				bIgnoreLongRangeDmgEffects = true

			if ( pTFAttacker && pVictim )
			{
				// MiniCrit a victims back at close range
				local iMiniCritBackAttack = CALL_ATTRIB_HOOK_INT_ON_OTHER( pWeapon, "closerange backattack minicrits" )
				local toEnt = pVictim.GetOrigin() - pTFAttacker.GetOrigin()
				if ( iMiniCritBackAttack == 1 && toEnt.LengthSqr() < 512.0*512.0 )
				{
					toEnt.z = 0
					toEnt.Norm()

					if ( toEnt.Dot( pVictim.EyeAngles().Forward() ) > 0.259 )	// 75 degrees from center (total of 150)
					{
						bAllSeeCrit = true
						MakeMinicrit()
					}
				}
			}
		}
	}

	if ( info.GetCritType() == CTakeDamageInfo.ECritType.CRIT_MINI )
	{
		if ( IsPowerupMode() && ( info.GetDamageType() & DMG_MELEE ) )
		{
			// printf("[DEBUG]: \n\tDividing bonus by 1.3 from %f Damage %f\n", flDamage, flDamage/1.3)
			flDamage /= 1.3
		}
			
		local iPromoteMiniCritToCrit = CALL_ATTRIB_HOOK_INT_ON_OTHER( pWeapon, "minicrits become crits" )
		if ( iPromoteMiniCritToCrit == 1 )
		{
			eBonusEffect = kBonusEffect_Crit
			bitsDamage = bitsDamage | DMG_CRITICAL
			MakeCrit()
		}
	}

	if ( info.GetDamageCustom() == TF_DMG_CUSTOM_BOOTS_STOMP )
		eBonusEffect = kBonusEffect_Stomp

	if ( pVictim )
	{
		pVictim.SetInternalVar("m_bAllSeeCrit", bAllSeeCrit)
		pVictim.SetInternalVar("m_bMiniCrit", info.GetCritType() == CTakeDamageInfo.ECritType.CRIT_MINI)
		pVictim.SetInternalVar("m_bShowDisguisedCrit", bShowDisguisedCrit)
		pVictim.SetInternalVar("m_eBonusAttackEffect", eBonusEffect)
	}

	// If we're invulnerable, force ourselves to only take damage events only, so we still get pushed
	if ( pVictim && pVictim.IsInvulnerable() )
	{
		if ( !bAllowDamage )
		{
			// NOTE: Deliberately skip base player OnTakeDamage, because we don't want all the stuff it does re: suit voice
			pVictim.CBaseCombatCharacter_OnTakeDamage( info )
			return false
		}
	}

	// Apply attributes that increase damage vs players
	if ( pWeapon )
	{
		// printf("[DEBUG]: \n\tMulting bonus by %f from %f Damage %f\n",CALL_ATTRIB_HOOK_FLOAT_ON_OTHER( pWeapon, "dmg penalty vs players", 1.0 ), flDamage, flDamage * CALL_ATTRIB_HOOK_FLOAT_ON_OTHER( pWeapon, "dmg penalty vs players", 1.0 ))
		flDamage *= CALL_ATTRIB_HOOK_FLOAT_ON_OTHER( pWeapon, "dmg penalty vs players", 1.0 )

		// Check if we're to boost damage against the same class
		if( pVictim && pTFAttacker && pVictim.GetPlayerClass() == pTFAttacker.GetPlayerClass() )
		{
			// printf("[DEBUG]: \n\tMulting bonus by %f from %f Damage %f\n",CALL_ATTRIB_HOOK_FLOAT_ON_OTHER( pWeapon, "mult dmg vs same class", 1.0 ), flDamage, flDamage * CALL_ATTRIB_HOOK_FLOAT_ON_OTHER( pWeapon, "mult dmg vs same class", 1.0 ))
			// Same class? Potentially boost damage
			flDamage *= CALL_ATTRIB_HOOK_FLOAT_ON_OTHER( pWeapon, "mult dmg vs same class", 1.0 )
		}
	}

	if ( pVictim && !pVictim.InCond( TF_COND_BURNING ) )
	{
		if ( bitsDamage & DMG_CRITICAL )
		{
			if ( pTFAttacker && !pTFAttacker.IsCritBoosted() )
			{
				local iNonBurningCritsDisabled = CALL_ATTRIB_HOOK_INT_ON_OTHER( pWeapon, "no crit vs nonburning" )
				if ( iNonBurningCritsDisabled )
				{
					bitsDamage = bitsDamage & ~DMG_CRITICAL
					RemoveCrit()
				}
			}
		}

		// printf("[DEBUG]: \n\tMulting bonus by %f from %f Damage %f\n",CALL_ATTRIB_HOOK_FLOAT_ON_OTHER( pWeapon, "dmg penalty vs nonburning" 1.0 ), flDamage, flDamage * CALL_ATTRIB_HOOK_FLOAT_ON_OTHER( pWeapon, "dmg penalty vs nonburning", 1.0 ))
		flDamage *= CALL_ATTRIB_HOOK_FLOAT_ON_OTHER( pWeapon, "dmg penalty vs nonburning", 1.0)
	}

	// Alien Isolation SetBonus Checking
	if ( pVictim && pTFAttacker && pWeapon )
	{
		// Alien->Merc melee bonus
		if ( ( info.GetDamageType() & (DMG_CLUB|DMG_SLASH) ) && info.GetDamageCustom() != TF_DMG_CUSTOM_BASEBALL )
		{
			local pMelee = pWeapon
			if ( pMelee )
			{
				local iAttackerAlien = CALL_ATTRIB_HOOK_INT_ON_OTHER( pTFAttacker, "SET BONUS: alien isolation xeno bonus pos" )
				local iVictimMerc = CALL_ATTRIB_HOOK_INT_ON_OTHER( pVictim, "SET BONUS: alien isolation merc bonus neg" )

				if ( iAttackerAlien && iVictimMerc )
					flDamage *= 5.0
			}
		}

		// Merc->Alien MK50 damage, aka flamethrower
		if ( ( info.GetDamageType() & DMG_IGNITE ) && pWeapon.IsFlamethrower() )
		{
			local iAttackerMerc = CALL_ATTRIB_HOOK_INT_ON_OTHER( pTFAttacker, "SET BONUS: alien isolation merc bonus pos" )
			local iVictimAlien = CALL_ATTRIB_HOOK_INT_ON_OTHER( pVictim, "SET BONUS: alien isolation xeno bonus neg" )

			if ( iAttackerMerc && iVictimAlien )
				flDamage *= 3.0
		}
	}

	// Use defense buffs if it's not a backstab or direct crush damage (telefrage, etc.)
	if ( pVictim && info.GetDamageCustom() != TF_DMG_CUSTOM_BACKSTAB && ( info.GetDamageType() & DMG_CRUSH ) == 0 )
	{
		if ( pVictim.InCond( TF_COND_DEFENSEBUFF ) )
		{
			// We take no crits of any kind...
			if( eBonusEffect == kBonusEffect_MiniCrit || eBonusEffect == kBonusEffect_Crit )
				eBonusEffect = kBonusEffect_None

			bitsDamage = bitsDamage & ~DMG_CRITICAL
			RemoveCrit(bitsDamage)
			bAllSeeCrit = false
			bShowDisguisedCrit = false

			pVictim.SetInternalVar("m_bAllSeeCrit", false)
			pVictim.SetInternalVar("m_bMiniCrit", false)
			pVictim.SetInternalVar("m_bShowDisguisedCrit", false)
			pVictim.SetInternalVar("m_eBonusAttackEffect", eBonusEffect)
		}

		if ( !iAttackIgnoresResists )
		{
			// If we are defense buffed...
			if ( pVictim.InCond( TF_COND_DEFENSEBUFF_HIGH ) )
			{
				// We take 75% less damage... still take crits
				flDamage *= 0.25
			}
			else if ( pVictim.InCond( TF_COND_DEFENSEBUFF ) || pVictim.InCond( TF_COND_DEFENSEBUFF_NO_CRIT_BLOCK ) )
			{
				// defense buffs gives 50% to sentry dmg and 35% from all other sources
				local pSentry = ToBaseObject( info.GetInflictor() )
				if ( pSentry && pSentry.GetClassname() == "obj_sentrygun" )
					flDamage *= 0.50
				else // And we take 35% less damage...
					flDamage *= 0.65
			}
		}
	}

	// A note about why crits now go through the randomness/variance code:
	// Normally critical damage is not affected by variance.  However, we always want to measure what that variance 
	// would have been so that we can lump it into the DamageBonus value inside the info.  This means crits actually
	// boost more than 3X when you factor the reduction we avoided.  Example: a rocket that normally would do 50
	// damage due to range now does the original 100, which is then multiplied by 3, resulting in a 6x increase.
	local bCrit = ( bitsDamage & DMG_CRITICAL ) ?  true : false

	// If we're not damaging ourselves, apply randomness
	if ( pAttacker != pVictimBaseEntity && !(bitsDamage & (DMG_DROWN | DMG_FALL)) ) 
	{
		local flDmgVariance = 0.0
		local iForceCritDmgFalloff = CALL_ATTRIB_HOOK_INT_ON_OTHER( pWeapon, "crit_dmg_falloff" )

		// Minicrits still get short range damage bonus
		local bForceCritFalloff = ( bitsDamage & DMG_USEDISTANCEMOD ) && 
								 ( ( bCrit && GetBoolCvar("tf_weapon_criticals_distance_falloff", false) ) || 
								 ( info.GetCritType() == CTakeDamageInfo.ECritType.CRIT_MINI && GetBoolCvar("tf_weapon_minicrits_distance_falloff", false) ) || 
								 ( iForceCritDmgFalloff ) )

		local bDoShortRangeDistanceIncrease = !bCrit || info.GetCritType() == CTakeDamageInfo.ECritType.CRIT_MINI 
		local bDoLongRangeDistanceDecrease = !bIgnoreLongRangeDmgEffects && ( bForceCritFalloff || ( !bCrit && info.GetCritType() != CTakeDamageInfo.ECritType.CRIT_MINI  ) )

		// If we're doing any distance modification, we need to do that first
		local flRandomDamage = info.GetDamage() * GetFloatCvar("tf_damage_range", 0.5)

		local flRandomDamageSpread = 0.10
		local flMin = 0.5 - flRandomDamageSpread
		local flMax = 0.5 + flRandomDamageSpread

		if ( bitsDamage & DMG_USEDISTANCEMOD )
		{
			local vAttackerPos = pAttacker.GetCenter()
			local flOptimalDistance = 512.0

			// Use Sentry position for distance mod
			local pSentry = ToBaseObject( info.GetInflictor() )
			if ( pSentry )
			{
				vAttackerPos = pSentry.GetCenter()
				// Sentries have a much further optimal distance
				flOptimalDistance = SENTRY_MAX_RANGE
			}
			// The base sniper rifle doesn't have DMG_USEDISTANCEMOD, so this isn't used. Unlockable rifle had it for a bit.
			else if ( pWeapon && pWeapon.IsSniperRifle() )
				flOptimalDistance *= 2.5

			local flDistance = MATH.Max( 1.0, ( pVictimBaseEntity.GetCenter() - vAttackerPos).Length() )
				
			local flCenter = MATH.RemapValClamped( flDistance / flOptimalDistance, 0.0, 2.0, 1.0, 0.0 )
			if ( ( flCenter > 0.5 && bDoShortRangeDistanceIncrease ) || flCenter <= 0.5 )
			{
				if ( bitsDamage & DMG_NOCLOSEDISTANCEMOD )
				{
					// Reduce the damage bonus at close range
					if ( flCenter > 0.5 )
						flCenter = MATH.RemapVal( flCenter, 0.5, 1.0, 0.5, 0.65 )
				}
				flMin = MATH.Max( 0.0, flCenter - flRandomDamageSpread )
				flMax = MATH.Min( 1.0, flCenter + flRandomDamageSpread )
			}
		}
		// only reason it may be off
		local flRandomRangeVal = RandomFloat( flMin, flMax )
		if ( GetBoolCvar("tf_damage_disablespread", true) || ( pTFAttacker && pTFAttacker.GetCurrentRune() == RUNE_PRECISION ) )
			flRandomRangeVal = flMin + flRandomDamageSpread

		// Weapon Based Damage Mod
		if ( pWeapon && pAttacker && pAttacker.IsPlayer() )
		{
			// Rocket launcher only has half the bonus of the other weapons at short range
			if( pWeapon.IsRocketLauncher() && flRandomRangeVal > 0.5 )
				flRandomDamage *= 0.5

			if( pWeapon.IsPipeLauncher() || pWeapon.IsStickyLauncher() || pWeapon.IsStickbomb() && !( bitsDamage & DMG_NOCLOSEDISTANCEMOD ) )
				flRandomDamage *= 0.2

			if( pWeapon.IsScattergun() && flRandomRangeVal > 0.5 )
				flRandomDamage *= 1.5
		}

		// Random damage variance.
		flDmgVariance = MATH.SimpleSplineRemapValClamped( flRandomRangeVal, 0, 1, -flRandomDamage, flRandomDamage )
		if ( ( bDoShortRangeDistanceIncrease && flDmgVariance > 0.0 ) || bDoLongRangeDistanceDecrease )
		{
			// printf("[DEBUG]: \n\tAdding Distance bonus %f damage from %f Damage %f\n",flDmgVariance, flDamage, flDamage + flDmgVariance)
			flDamage += flDmgVariance
		}
			

		// Save any bonus damage as a separate value
		local flCritDamage = 0.0
		// Yes, it's weird that we sometimes fabs flDmgVariance.  Here's why: In the case of a crit rocket, we
		// know that number will generally be negative due to dist or randomness.  In this case, we want to track
		// that effect - even if we don't apply it.  In the case of our crit rocket that normally would lose 50 
		// damage, we fabs'd so that we can account for it as a bonus - since it's present in a crit.
		local flBonusDamage = bForceCritFalloff ? 0.0 : fabs( flDmgVariance )
		local function lambdaDoMinicrit( bDemote = false )
		{
			// We should never have both of these flags set or Weird Things will happen with the damage numbers
			// that aren't clear to the players. Or us, really.
			Assert( !(bitsDamage & DMG_CRITICAL) )

			flCritDamage = ( TF_DAMAGE_MINICRIT_MULTIPLIER - 1.0 ) * flDamage

			bitsDamage = bitsDamage | DMG_CRITICAL
			info.AddDamageType( DMG_CRITICAL )
			info.SetCritType( CTakeDamageInfo.ECritType.CRIT_MINI )
			if ( pVictim && bDemote )
				pVictim.SetInternalVar("m_eBonusAttackEffect", kBonusEffect_MiniCrit)
		}

		local function lambdaDoFullCrit()
		{
			if ( info.GetCritType() != CTakeDamageInfo.ECritType.CRIT_MINI  )
				flCritDamage = ( TF_DAMAGE_CRIT_MULTIPLIER - 1.0 ) * flDamage
		}

		if ( info.GetCritType() == CTakeDamageInfo.ECritType.CRIT_MINI )
			lambdaDoMinicrit( false )
		else if ( bCrit )
		{
			local iDemoteCritToMinicrit = CALL_ATTRIB_HOOK_INT_ON_OTHER( pWeapon, "crits_become_minicrits" )
			if ( iDemoteCritToMinicrit != 0 )
			{
				bitsDamage = bitsDamage & ~DMG_CRITICAL // this is to shutup the assert in lambdaDoMinicrit
				lambdaDoMinicrit( true )
			}
			else
				lambdaDoFullCrit()
		}
		
		if ( pAttacker && pAttacker.IsPlayer() && pTFAttacker.InCond(TF_COND_TMPDAMAGEBONUS)) // Modify damage based on bonuses
			flDamage *= pTFAttacker.GetInternalVar("m_flTmpDamageBonusAmount", 1.0)
			

		// Store the extra damage and update actual damage
		if ( bCrit || info.GetCritType() == CTakeDamageInfo.ECritType.CRIT_MINI  )
			info.SetDamageBonus( flCritDamage + flBonusDamage, null )	// Order-of-operations sensitive, but fine as long as TF_COND_CRITBOOSTED is last

		// Crit-A-Cola and Steak Sandwich - only increase normal damage
		if ( pVictim && pVictim.InCond( TF_COND_ENERGY_BUFF ) && !bCrit && info.GetCritType() != CTakeDamageInfo.ECritType.CRIT_MINI  )
			flDamage *= CALL_ATTRIB_HOOK_FLOAT_ON_OTHER( pVictim, "energy buff dmg taken multiplier", 1.0 )

		// printf("[DEBUG]: \n\tAdding Crit bonus %f damage from %f Damage %f\n", flCritDamage, flDamage, flDamage + flCritDamage)
		flDamage += flCritDamage
	}

	if ( info.GetDamageCustom() == TF_DMG_CUSTOM_BACKSTAB )
	{
		if ( pVictim && pVictim.CheckBlockBackstab( pTFAttacker ) )
			flDamage = 0.0
			// The backstab was absorbed by a shield.
	}

	/* 	printf(@"[DEBUG]:
	Old Damage: %f
	New Damage: %f
	",
	info.GetDamage(),
	flDamage
	) */

	info.SetDamage( flDamage )

	// Apply on-hit attributes (after damage has been updated)
	if ( pVictim && pAttacker && pAttacker.GetTeam() != pVictim.GetTeam() && pAttacker.IsPlayer() && pWeapon )
		pWeapon.ApplyOnHitAttributes( pVictimBaseEntity, pTFAttacker, info )
	return true
}
/**
 * the ROOT should actually be gamerules, but idgaf
 * @param {CTFPlayer} pPlayer
 * @param {CBaseEntity} pAttacker
 * @param {CTakeDamageInfo} info
 * @returns {bool}
 */
function ROOT::FPlayerCanTakeDamage( pPlayer, pAttacker, info )
{
	// guard against null pointers if players disconnect
	if ( !pPlayer || !pAttacker )
		return false

	if ( IsTruceActive() && ( pPlayer != pAttacker ) && ( pPlayer.GetTeam() != pAttacker.GetTeam() ) )
	{
		if ( ( ( pAttacker.GetTeam() == TF_TEAM_RED ) && ( pPlayer.GetTeam() == TF_TEAM_BLUE ) ) || ( ( pAttacker.GetTeam() == TF_TEAM_BLUE ) && ( pPlayer.GetTeam() == TF_TEAM_RED ) ) )
		{
			local pInflictor = info.GetInflictor()
			if ( pInflictor )
			{
				return !( IsTruceValidForEnt( pInflictor ) || IsTruceValidForEnt( pAttacker ) )
			}
			else
			{
				return !IsTruceValidForEnt( pAttacker )
			}
		}
	}

	// if pAttacker is an object, we can only do damage if pPlayer is our builder
	if ( IsBaseObject( pAttacker ) )
	{
		local pObj = ToBaseObject(pAttacker)

		if ( GetBuilder( pObj ) == pPlayer || pPlayer.GetTeam() != pObj.GetTeam() )
		{
			// Builder and enemies
			return true
		}
		else
		{
			// Teammates of the builder
			return false
		}
	}

	// prevent eyeball rockets from hurting teammates if it's a spell
	if ( info.GetDamageCustom() == TF_DMG_CUSTOM_SPELL_MONOCULUS && pAttacker.GetTeam() == pPlayer.GetTeam() )
	{
		return false
	}

	// in PvE modes, if entities are on the same team, they can't hurt each other
	// this is needed since not all entities will be players
	if ( IsPVEModeActive() && 
			pPlayer.GetTeam() == pAttacker.GetTeam() && 
			pPlayer != pAttacker && 
			!info.IsForceFriendlyFire() )
	{
		return false
	}

	if ( pAttacker && pPlayer.GetTeam() == pAttacker.GetTeam() && !info.IsForceFriendlyFire() )
	{
		// my teammate hit me.
		if(GetIntCvar("mp_friendlyfire", 0) == 0 && (pAttacker != pPlayer))
		{
			// friendly fire is off, and this hit came from someone other than myself,  then don't get hurt
			return false
		}
	}

	return true
}

function ROOT::HasSpawnFlags(entity, flag)
	return Math.BitWise(GetPropInt(entity, "m_spawnflags"), flag)

function GetIntCvar(cvar, def)
{
	if(!IsCvarAllowed(cvar))
		return def
	return GetCvarInt(cvar)
}

function GetBoolCvar(cvar, def)
{
	if(!IsCvarAllowed(cvar))
		return def
	return GetCvarBool(cvar)
}

function GetFloatCvar(cvar, def)
{
	if(!IsCvarAllowed(cvar))
		return def
	return GetCvarFloat(cvar)
}

/**
 * Description
 * @param {CTakeDamageInfo} info
 * @returns {integer}
 */
function CTFPlayer::OnTakeDamage_Alive( info )
{
	// printl("[DEBUG] Made it to CTFPlayer::OnTakeDamage_Alive")
	if ( IsInItemTestingMode() && !IsFakeClient() )
		return 0

	local bUsingUpgrades = GameModeUsesUpgrades()

	// Always null check this below
	/**
	 * @type {CTFPlayer|null}
	 */
	local pTFAttacker = ToTFPlayer( info.GetAttacker() )

	local outParams = {}
	outParams.bIgniting <- false
	outParams.bSelfBlastDmg <- false
	outParams.bSendPreFeignDamage <- false
	outParams.bPlayDamageReductionSound <- false
	local realDamage = info.GetDamage()
	realDamage = ApplyOnDamageAliveModifyRules( info, this, outParams )
	

	if ( realDamage == -1 )// Hard out requested from ApplyOnDamageAliveModifyRules 
		return 0

	// Do the damage.
	// SetPropInt( this, "m_bitsDamageType", GetPropInt( this, "m_bitsDamageType" ) | info.GetDamageType() )

	local flBleedingTime = 0.0
	if ( CanTakeDamage(this) != DAMAGE_EVENTS_ONLY )
	{
		if ( info.GetDamageCustom() != TF_DMG_CUSTOM_BLEEDING && !outParams.bSelfBlastDmg )
			flBleedingTime = CALL_ATTRIB_HOOK_FLOAT_ON_OTHER( info.GetWeapon(), "bleeding duration", 0.0 )

		// Take damage - round to the nearest integer.
		local iOldHealth = GetHealth()
		// TODO: this is what actually deals the damage
		// SetHealth( GetHealth() - ( realDamage + 0.5 ).tointeger() )

		if ( IsHeadshot( info.GetDamageCustom() ) && ( GetHealth() <= 0 ) && ( iOldHealth != 1 ) )
		{
			local iNoDeathFromHeadshots = CALL_ATTRIB_HOOK_INT_ON_OTHER( this, "SET BONUS: no death from headshots" )
			if ( iNoDeathFromHeadshots == 1 )
				SetHealth(1)
		}
	}

	SetPropFloat(this, "m_flLastDamageTime", Time()) // not networked
	if ( IsMannVsMachineMode() )// We only need damage time networked while in MvM
		SetPropFloat(this, "m_flMvMLastDamageTime", Time())

	// Apply a damage force.
	local pAttacker = info.GetAttacker()
	if ( !pAttacker )
		return 0

	local pTFWeapon = info.GetWeapon()
	if ( pTFWeapon && pTFWeapon.IsKnife() )
	{
		if ( bUsingUpgrades && pTFAttacker && info.GetDamageCustom() == TF_DMG_CUSTOM_BACKSTAB && ! ( info.GetDamageType() & DMG_BLAST) )
		{
			local iExplosiveStab = CALL_ATTRIB_HOOK_INT_ON_OTHER( pTFAttacker, "explosive backstab" )
			if ( iExplosiveStab )
			{
				CreateKnifeAoE({
					owner = pTFAttacker
					weapon = pTFWeapon
					radius = 250
					damage = MATH.Max(512, realDamage)
					center = GetCenter()
					ignore = [this]
					SoundRadius = 1500
					/**
					 * @param {CTFPlayer|CTFBot|CBaseEntity} player
					 */
					function func(player) {
						if(!player || !player.IsValid() || !player.IsPlayer())
							return
						player.StunPlayer(MATH.Clamp(iExplosiveBackstab - 1, 0, 2), 0.6, TF_STUN_MOVEMENT, attacker )
					}
				})
			}
		}
	}

	info.DebugPrint()

	// Done.
	return 1
}

/**
 * @param {CTakeDamageInfo} info
 */
function CTFPlayer::TakeDamageInfo( info )
{
	TakeDamageCustom(info.GetInflictor(), info.GetAttacker(), info.GetWeapon(), info.GetDamageForce(), info.GetDamagePosition(), info.GetDamage(), info.GetDamageType(), info.GetDamageCustom())
}

/** 
 * @param {string} var_name
 * @param {any} def
 * @returns {any}
 */
function CTFPlayer::GetInternalVar(var_name, def = 0)
{
	if(!("Internal_Vars" in GetScope(this)))
		GetScope(this).Internal_Vars <- {}
	if(!(var_name in GetScope(this).Internal_Vars))
		GetScope(this).Internal_Vars[var_name] <- def
		
	return GetScope(this).Internal_Vars[var_name]
}

/** 
 * @param {string} var_name
 * @param {any} value
 */
function CTFPlayer::SetInternalVar(var_name, value)
{
	GetInternalVar(var_name) // cheeky to fix it up so its not missing
	GetScope(this).Internal_Vars[var_name] <- value
}

/** 
 * Called after script hook and
 * @param {CTakeDamageInfo} inputInfo
 * @returns {integer}
 */
function CTFPlayer::OnTakeDamage( inputInfo )
{
	local info = inputInfo

	/** @type {bool} */
	local bIsObject = info.GetInflictor() && IsBaseObject(info.GetInflictor())

	// damage may not come from a weapon (ie: Bosses, etc)
	// The existing code below already checked for null pWeapon, 
	/** @type {CTFWeaponBase} */
	local pWeapon = ToBaseWeapon( inputInfo.GetWeapon() )

	if ( GetFlags() & FL_GODMODE )
		return 0

	if ( IsInCommentaryMode() )
		return 0

	local bBuddha = ( GetPropInt(this, "m_debugOverlays") & DebugOverlayBits_t.OVERLAY_BUDDHA_MODE ) ? true : false

	if ( bBuddha )
	{
		if ( ( GetHealth() - info.GetDamage() ).tointeger() <= 0 )
		{
			SetHealth(1)
			return 0
		}
	}

	if ( !IsAlive() )
		return 0

	// Early out if there's no damage
	if ( !info.GetDamage() )
		return 0

	// Ghosts dont take damage
	if ( InCond( TF_COND_HALLOWEEN_GHOST_MODE ) )
		return 0

	local pInflictor = info.GetInflictor()
	local pAttacker = info.GetAttacker()
	/** @type {CTFPlayer|null} */
	local pTFAttacker = ToTFPlayer( pAttacker )

	// If attacker has Strength Powerup Rune, apply damage multiplier, but not if you're a building or a crit
	local bCrit = ( info.GetDamageType() & DMG_CRITICAL ) > 0
	if ( !bIsObject && pTFAttacker && pTFAttacker.GetCurrentRune() == RUNE_STRENGTH && !bCrit )
	{
		if ( pTFAttacker.InCond( TF_COND_POWERUPMODE_DOMINANT ) ) 
			info.ScaleDamage( 1.4 )
		else
			info.ScaleDamage( 2.0 )
	}

	// Make sure the player can take damage from the attacking entity
	if ( !FPlayerCanTakeDamage( this, pAttacker, info ) )
		return 0

	if ( IsBot() && IsMannVsMachineMode() )
	{
		// Don't let Sentry Busters die until they've done their spin-up
		/**@type {CTFBot|null} */
		local bot = ToTFBot( this )
		if ( bot )
		{
			if ( bot.HasMission( MissionType.MISSION_DESTROY_SENTRIES ) )
			{
				if ( ( GetHealth() - info.GetDamage() ).tointeger() <= 0 )
				{
					SetHealth(1)
					return 0
				}
			}

			// Sentry Busters hurt teammates when they explode.
			// Force damage value when the victim is a giant.
			if ( pTFAttacker && pTFAttacker.IsBot() )
			{
				/**@type {CTFBot|null} */
				local pTFAttackerBot = ToTFBot( pTFAttacker )
				if ( pTFAttackerBot && 
						( pTFAttackerBot != this ) && 
						pTFAttackerBot.GetPrevMission() == MissionType.MISSION_DESTROY_SENTRIES &&
						info.IsForceFriendlyFire() && 
						GetTeam() == pTFAttackerBot.GetTeam() &&
						IsMiniBoss() )
				{
					info.SetDamage( 600.0 )
				}
			}
		}
	}

	// Halloween 2011
	if ( IsInPurgatory() )
		info.SetDamage( GetInternalVar("m_purgatoryPainMultiplier", 1.0) * info.GetDamage() )

	if ( ( info.GetDamageType() & DMG_FALL ) && info.GetDamageCustom() != TF_DMG_CUSTOM_BOOTS_STOMP )
	{
		// Are we transferring falling damage to someone else?
		if ( GetGroundEntity() && GetGroundEntity().IsPlayer() && CanStomp() )
		{
			// Did we land on a guy from the enemy team?
			/**@type {CTFPlayer|null} */
			local pOther = ToTFPlayer( GetGroundEntity() )
			if ( pOther && pOther.GetTeam() != GetTeam() )
			{
				pOther.TakeDamageInfo(CTakeDamageInfo(this, this, GetWeaponInSlotNew(SLOT_SECONDARY), Vector(), Vector(), Vector(), 10.0 + info.GetDamage() * 3.0, DMG_FALL, TF_DMG_CUSTOM_BOOTS_STOMP))
				info.SetDamage( 0.0 )
			}
		}

		// Apply an impact effect (intensity determined by velocity)
		if ( InCond( TF_COND_ROCKETPACK ) )
			info.SetDamage( MATH.Max( info.GetDamage() * 0.25, 1.0 ) )
	}

	// If this is our own rocket, scale down the damage if we're rocket jumping
	if ( ( IsPlayerClass( TF_CLASS_SOLDIER ) && (pAttacker == this) && !(GetFlags() & FL_ONGROUND) && !(GetFlags() & FL_INWATER)) && (inputInfo.GetDamageType() & DMG_BLAST) )
		info.SetDamage( info.GetDamage() * GetFloatCvar("tf_damagescale_self_soldier", 0.60) )

	local bTookDamage = 0
	local bAllowDamage = false

	if ( pInflictor && pInflictor.GetClassname() == "point_hurt" )
	{
		// check to see if our attacker is a point_hurt entity (and allow it to kill us even if we're invuln with the flag)
		if ( HasSpawnFlags( pInflictor, SF_PHURT_HURT_UBER ) )
		{
			bAllowDamage = true
			info.SetDamageCustom( TF_DMG_CUSTOM_TRIGGER_HURT )
		}
	}
	else if ( pInflictor && pInflictor.IsSolidFlagSet( FSOLID_TRIGGER ) )
	{
		// check to see if our attacker is a trigger_hurt entity (and allow it to kill us even if we're invuln)
		if(pInflictor.GetClassname() == "trigger_hurt" )
		{
			bAllowDamage = true
			info.SetDamageCustom( TF_DMG_CUSTOM_TRIGGER_HURT )
		}
		else if( pInflictor.GetClassname() == "func_croc" )
		{
			bAllowDamage = true
			info.SetDamageCustom( TF_DMG_CUSTOM_CROC )
		}
	}
	else if ( info.GetDamageCustom() == TF_DMG_CUSTOM_TELEFRAG )
		bAllowDamage = true

	if ( !ApplyOnDamageModifyRules( info, this, bAllowDamage ) )
		return 0

	// If player has Reflect Powerup, reflect damage to attacker. 
	// We do this here, after damage modify rules to ensure distance falloff calculations have already been made before we pass that damage back to the attacker
	if ( pTFAttacker && GetCurrentRune() == RUNE_REFLECT && pTFAttacker != this && !pTFAttacker.IsInvulnerable() && pTFAttacker.IsAlive() && InputInfo.GetDamageCustom() != TF_DMG_CUSTOM_RUNE_REFLECT )
	{
		local dmg = info
		local sentryRocket = IsSentryRocket(info.GetInflictor()) ? info.GetInflictor() : null

		dmg.SetDamageCustom( TF_DMG_CUSTOM_RUNE_REFLECT )
		dmg.SetDamageType( DMG_SHOCK )
		dmg.SetAttacker( this )

		if ( bIsObject )
		{
			local pInflictor = info.GetInflictor()
			dmg.SetDamage( info.GetDamage() )
			pInflictor.TakeDamageCustom( dmg.GetInflictor(), dmg.GetAttacker(), dmg.GetWeapon(), dmg.GetDamageForce(), dmg.GetDamagePosition(), dmg.GetDamage(), dmg.GetDamageType(), dmg.GetDamageCustom())
		}
		// Sentry rockets are not included in bIsobject so we deal with them separately
		else
		{
			if ( sentryRocket )
			{
				dmg.SetDamage( info.GetDamage() )
				info.GetInflictor().GetOwner().TakeDamageCustom(dmg.GetInflictor(), dmg.GetAttacker(), dmg.GetWeapon(), dmg.GetDamageForce(), dmg.GetDamagePosition(), dmg.GetDamage(), dmg.GetDamageType(), dmg.GetDamageCustom())
			}
			else
			{
				// Take damage unless you have Resist or Vampire (they are immune to reflect damage)
				if ( pTFAttacker.GetCurrentRune() != RUNE_RESIST && pTFAttacker.GetCurrentRune() != RUNE_VAMPIRE )
				{
					dmg.SetDamage( info.GetDamage() * ( IsDominant() ? 0.5 : 0.8 ) )
					pTFAttacker.TakeDamageInfo(dmg)
				}
			}
		}
	}

	//Don't take damage while I'm phasing.
	if ( ( InCond( TF_COND_PHASE ) || InCond( TF_COND_PASSTIME_INTERCEPTION ) ) && bAllowDamage == false )
		bTookDamage = false
	else
	{
		// This should kill us
		if ( ( GetHealth() - info.GetDamage() ).tointeger() <= 0 )
		{
			// Damage could have been modified since we started
			// Try to prevent death with buddha one more time
			if ( bBuddha )
			{
				SetHealth(1)
				return 0
			}

			// Check to see if we have the cheat death attribute that makes
			// us teleport to base rather than die
			local flCheatDeathChance = HookAdditiveAttributes("teleport instead of die")
			if( RandomFloat(0, 1) < flCheatDeathChance )
			{
				// Send back to base
				ForceRegenerateAndRespawn()

				SetHealth(1)
				return 0
			}

			// Avoid one death
			if ( InCond( TF_COND_PREVENT_DEATH ) )
			{
				RemoveCond( TF_COND_PREVENT_DEATH )
				SetHealth(1)
				return 0
			}

			// Powerup-sourced reflected damage should not kill player
			if ( info.GetDamageCustom() == TF_DMG_CUSTOM_RUNE_REFLECT )
			{
				SetHealth(1)
				return 0
			}
		}

		// NOTE: Deliberately skip base player OnTakeDamage, because we don't want all the stuff it does re: suit voice
		bTookDamage = CBaseCombatCharacter_OnTakeDamage( info )

		// Early out if the base class took no damage
		if ( !bTookDamage )
			return 0

		if(!("gs_pRecursivePlayerCheck" in ROOT))
			::gs_pRecursivePlayerCheck <- null
		// Check to see if we need to pass along the damage to other players
		if ( pWeapon && ( gs_pRecursivePlayerCheck == null ) )
		{
			local iDamageAllConnected = CALL_ATTRIB_HOOK_INT_ON_OTHER( pWeapon, "damage all connected" )

			if ( iDamageAllConnected > 0 )
			{
				// Am I healing someone or being healed?
				local pTempPlayerQueue = []
				/** 
				 * @param {[CTFPlayer]} vecPlayers
				 * @param {CTFPlayer} pPlayerToConsider
				 * @returns {[CTFPlayer]}
				 */
				local function AddConnectedPlayers( vecPlayers, pPlayerToConsider )
				{
					if ( !pPlayerToConsider )
						return /* vecPlayers */

					if ( vecPlayers.find(pPlayerToConsider) != null )
						return /* vecPlayers */

					vecPlayers.append(pPlayerToConsider)
					
					if ( pPlayerToConsider.GetHealTarget() )
						AddConnectedPlayers( vecPlayers, ToTFPlayer( pPlayerToConsider.GetHealTarget() ) )

					foreach (pMedic in pPlayerToConsider.GetActiveHealers())
					{
						AddConnectedPlayers( vecPlayers, pMedic )
					}
				}
				AddConnectedPlayers( pTempPlayerQueue, this )
				gs_pRecursivePlayerCheck = this
				foreach (pTFPlayer in pTempPlayerQueue)
				{
					if(pTFPlayer != this)
					pTFPlayer.TakeDamageInfo(inputInfo)
				}
				gs_pRecursivePlayerCheck = null
			}
		}
	}

	if ( bTookDamage == false )
		return 0

	if ( pWeapon && pWeapon.IsFish() && GetHealth() <= 0)
		info.SetDamageCustom( pWeapon.GetWeaponClass() == "bat_fish" ? TF_DMG_CUSTOM_FISH_KILL : TF_DMG_CUSTOM_SLAP_KILL )

	if ( bTookDamage && InCond( TF_COND_GAS ) )
	{
		// CTFPlayer *pTFGasTosser = dynamic_cast< CTFPlayer* >( m_Shared.GetConditionProvider( TF_COND_GAS ) )
		local pTFGasTosser = null

		local pGasCan = null
		if ( pTFGasTosser )
			pGasCan = pTFGasTosser.GetWeaponInSlotNew(SLOT_SECONDARY)

		//TODO
		// m_Shared.Burn( pTFGasTosser ? pTFGasTosser : this, ( pGasCan && pGasCan->GetWeaponID() == TF_WEAPON_JAR_GAS ) ? pGasCan : null, tf_afterburn_max_duration )
		RemoveCond( TF_COND_GAS )

		// Explode?
		if ( pTFGasTosser && pGasCan )
		{
			local iExplodeOnIgnite = CALL_ATTRIB_HOOK_INT_ON_OTHER( pGasCan, "explode_on_ignite" )
			if ( iExplodeOnIgnite )
			{
				local bExploded = false

				CreateBaseExplosion({
					owner = pTFGasTosser
					radius = 200.0 + 50.0
					damage = 350
					MinDamage = 350
					OnlyPlayers = true
					origin = GetOrigin()
					/** 
					 * @param {CTFPlayer} player
					 */
					function ExplodeFunc(player) {
						DispatchParticleEffect("dragons_fury_effect", player.GetOrigin(), Vector())
						bExploded = true
					}
				})

				if ( bExploded )
					EmitSound( "Weapon_Grenade_Pipebomb.Explode" )
			}
		}
	}

	return info.GetDamage()
}

::TestThatShit <- {
	function OnScriptEvent_PostTakeDamageHuman(params)
	{
		/** @type {CBaseEntity|CTFPlayer} */
		local victim = params.victim
		// local attacker = params.attacker

		/** @type {CTakeDamageInfo} */
		local info = CTakeDamageInfo(params.inflictor, params.attacker, params.weapon, params.damage_force, params.damage_position, params.reported_position, params.damage, params.damage_type, params.damage_custom)

		if(victim.IsPlayer())
		{
			// start the chain
			victim.OnTakeDamage(info)
		}
	}

	function OnScriptEvent_PostHumanHurt(params)
	{
		printf("[FINAL FUCKING DAMAGE]:\t %f\n", params.damage)
	}
}

__CollectGameEventCallbacks(TestThatShit)

/* CreateThinker("HealthTest", function() {
	local plr_idx = 0
	foreach (player in Players)
	{
		if(player == Host)
			continue
		// DebugDrawScreenTextLine(0.2, 0.25 + (plr_idx * 0.05), 0, format("%s : %f", player.tostring(), player.GetHealth()), 255, 255, 255, 0, 5)
		DebugDrawText(player.EyePosition(), format("%s : %f", player.tostring(), player.GetHealth()), false, 0.15)
		plr_idx++
	}
	return 0.1
}) */