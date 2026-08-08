::CRIT_NONE 						<- 4
::BASEDAMAGE_NOT_SPECIFIED 			<- FLT_MATH.Max
::DAMAGE_NO							<- 0
::DAMAGE_EVENTS_ONLY				<- 1
::DAMAGE_YES						<- 2
::DAMAGE_AIM						<- 3
::WL_NotInWater 					<- 0
::WL_Feet 							<- 1
::WL_Waist 							<- 2
::WL_Eyes 							<- 3
::TF_WEAPON_SNIPERRIFLE_DAMAGE_MIN 	<- 50 
::TF_WEAPON_SNIPERRIFLE_DAMAGE_MATH.Max 	<- 150

::HITGROUP_GENERIC 	<- 0
::HITGROUP_HEAD 	<- 1
::HITGROUP_CHEST 	<- 2
::HITGROUP_STOMACH 	<- 3
::HITGROUP_LEFTARM 	<- 4
::HITGROUP_RIGHTARM <- 5
::HITGROUP_LEFTLEG 	<- 6
::HITGROUP_RIGHTLEG <- 7
::HITGROUP_GEAR 	<- 10


::TF_PLAYER_ROCKET_JUMPED		<- ( 1 << 0 )
::TF_PLAYER_STICKY_JUMPED		<- ( 1 << 1 )
::TF_PLAYER_ENEMY_BLASTED_ME	<- ( 1 << 2 )

::SF_PHURT_HURT_UBER <- 2

::SENTRY_MATH.Max_RANGE <- 1100

::kBonusEffect_Crit 				<- 0
::kBonusEffect_MiniCrit				<- 1
::kBonusEffect_DoubleDonk			<- 2
::kBonusEffect_WaterBalloonSploosh	<- 3
::kBonusEffect_None					<- 4
::kBonusEffect_DragonsFury			<- 5
::kBonusEffect_Stomp				<- 6
::kBonusEffect_Count				<- 7

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

enum lunchbox_weapontypes_t
{
	LUNCHBOX_STANDARD,		// Careful, can be the Scout BONK drink, or the Heavy sandvich.
	LUNCHBOX_CHOCOLATE_BAR,
	LUNCHBOX_ADDS_MINICRITS,
	LUNCHBOX_STANDARD_ROBO,
	LUNCHBOX_STANDARD_FESTIVE,
	LUNCHBOX_ADDS_AMMO,
	LUNCHBOX_BANANA,
	LUNCHBOX_FISHCAKE,
}

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
	function BaseDamageIsValid( ) { return (m_flBaseDamage != BASEDAMAGE_NOT_SPECIFIED ) }
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
		if ( BaseDamageIsValid() )
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
	{
		CopyDamageToBaseDamage()
		// SetDamage( g_pGameRules->AdjustPlayerDamageInflicted(GetDamage()) )
	}
	function AdjustPlayerDamageTakenForSkillLevel()
	{
		CopyDamageToBaseDamage()
		// g_pGameRules->AdjustPlayerDamageTaken(this)
	}
}

function ROOT::IsInItemTestingMode()
	return GetPropBool(Gamerules, "m_bIsInItemTestingMode")

/**
 * @param {CBaseEntity|null} ent
 * @param {string} attrib
 * @returns {integer}
 */
function ROOT::CALL_ATTRIB_HOOK_INT_ON_OTHER( ent, attrib, def = 0 )
{
	if (!ent || !ent.IsValid())
		return def

	local base_val = ent.GetAttribute(attrib, def)
	local wep_mult = 1.0
	if (ent.IsPlayer())
	{
		foreach (weapon in GetAllWeapons())
		{
			if (weapon.GetAttribute("provide on active", 0) && weapon != ent.GetActiveWeapon())
				continue
			wep_mult *= weapon.GetAttribute(attribute, dev)
		}
	}
	return base_val * wep_mult
}
/**
 * @param {CBaseEntity|null} ent
 * @param {string} attrib
 * @returns {float}
 */
function ROOT::CALL_ATTRIB_HOOK_FLOAT_ON_OTHER( ent, attrib, def = 0.0 )
{
	if (!ent || !ent.IsValid())
		return def

	local base_val = ent.GetAttribute(attrib, def)
	local wep_mult = 1.0
	if (ent.IsPlayer())
	{
		foreach (weapon in GetAllWeapons())
		{
			if (weapon.GetAttribute("provide on active", 0) && weapon != ent.GetActiveWeapon())
				continue
			wep_mult *= weapon.GetAttribute(attribute, dev)
		}
	}
	return base_val * wep_mult
}
/**
 * @param {CBaseEntity|null} ent
 * @returns {int}
 */
function ROOT::CanTakeDamage( ent )
{
	if (!ent || !ent.IsValid())
		return DAMAGE_NO
	return GetPropInt("m_takedamage")
}

/**
 * @param {integer} iType
 * @returns {bool}
 */
function ROOT::IsDOTDmg( iType )
{
	if ( iType == TF_DMG_CUSTOM_BURNING ||
		 iType == TF_DMG_CUSTOM_BURNING_FLARE ||
		 iType == TF_DMG_CUSTOM_BURNING_ARROW ||
		 iType == TF_DMG_CUSTOM_BLEEDING )
	{
		return true
	}
	else
	{
		return false
	}
}
/**
 * @param {int} iType
 * @returns {bool}
 */
function ROOT::IsHeadshot( iType ) 
	return (iType == TF_DMG_CUSTOM_HEADSHOT || iType == TF_DMG_CUSTOM_HEADSHOT_DECAPITATION)

/**
 * @param {CBaseEntity|null} ent
 * @returns {CTFPlayer|null}
 */
function ROOT::ToTFPlayer( ent )
{
	if (!ent || !ent.IsValid() || !ent.IsPlayer())
		return null
	return ent
}
/**
 * @param {CBaseEntity|null} ent
 * @returns {CTFBot|null}
 */
function ROOT::ToTFBot( ent )
{
	if (!ent || !ent.IsValid() || !ent.IsPlayer() || !ent.IsBot())
		return null
	return ent
}

/** 
 * @type {function}
 * @param {CBaseEntity|null} ent
 * @returns {CTFWeaponBase|null}
 */
function ROOT::ToBaseWeapon( ent )
{
	if (!ent || !ent.IsValid() || !startswith(ent.GetClassname(), "tf_wea"))
		return null
	return ent
}

/** 
 * @type {function}
 * @param {CBaseEntity|null} ent
 * @returns {CBaseEntity|null}
 */
function ROOT::ToBaseObject( ent )
{
	if (!ent || !ent.IsValid() || !IsBaseObject(ent))
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
function ROOT::IsProjectile( ent )
{
	if (!ent || !ent.IsValid() || !startswith(ent.GetClassname(), "tf_proj"))
		return false
	return true
}
/** 
 * @param {CBaseEntity|null} ent
 * @returns {CBaseEntity|null}
 */
function ROOT::ToBaseGrenade( ent )
{
	if (!IsProjectile(ent) || !IsInArray(ent.GetClassname(), PipeBombClassnames))
		return null
	return ent
}
/** 
 * @param {CBaseEntity|null} ent
 * @returns {CBaseEntity|null}
 */
function ROOT::ToBaseRocket( ent )
{
	if (!IsProjectile(ent) || !IsInArray(ent.GetClassname(), RocketClassnames))
		return null
	return ent
}

/**
 * @param {CBaseEntity|null} ent
 * @returns {bool}
 */
function ROOT::IsBaseObject( ent )
{
	if (!ent || !ent.IsValid())
		return false
	return startswith(ent.GetClassname(), "obj_")
}
/**
 * @param {CBaseEntity|null} ent
 * @returns {bool}
 */
function ROOT::IsSentry( ent )
{
	if (!ent || !ent.IsValid() || !IsBaseObject(ent))
		return false
	return ent.GetClassname() == "obj_sentrygun"
}
/**
 * @param {CBaseEntity|null} ent
 * @returns {bool}
 */
function ROOT::IsSentryRocket( ent )
{
	if (!ent || !ent.IsValid())
		return false
	return ent.GetClassname() == "tf_projectile_sentry_rocket"
}
/**
 * @param {CBaseEntity|null} ent
 * @returns {bool}
 */
function ROOT::IsDisposableBuilding( ent )
{
	if (!IsBaseObject(ent))
		return false
	return GetPropBool(ent, "m_bDisposableBuilding")
}


/**
 * @param {int} clas
 * @returns {bool}
 */
function CTFPlayer::IsPlayerClass( clas )
	return GetPlayerClass() == clas

function CTFPlayer::IsDominant()
	return InCond(TF_COND_POWERUPMODE_DOMINANT)

function CTFPlayer::GetSpyCloakMeter()
	return GetPropFloat(this, "m_Shared.m_flSpyCloakMeter")

function CTFPlayer::LastHitGroup()
	return GetPropInt(this, "m_LastHitGroup")

function CTFPlayer::HasPasstimeBall()
	return GetPropBool(this, "m_Shared.m_bHasPasstimeBall")

function CTFPlayer::IsInPurgatory()
	return InCond( TF_COND_PURGATORY )

function IsTruceValidForEnt( entity )
{
	if (!entity)
		return false
	else if (entity.IsPlayer())
		return entity.IsTruceValidForEnt()
	else if (entity.GetClassname() == "obj_sentrygun")
		return true
	else
		return GetPropBool(entity, "m_bTruceValidForEnt")
}

/** 
 * @type {function}
 * @param {CTakeDamageInfo} info
 * @returns {Vector}
 */
function CTFPlayer::CBaseCombatCharacter_CalcDamageForceVector( info )
{
	// Already have a damage force in the data, use that.
	local bNoPhysicsForceDamage =  ( ( iDmgType & ( DMG_FALL | DMG_BURN | DMG_PLASMA | DMG_DROWN | ( DMG_PARALYZE | DMG_NERVEGAS | DMG_POISON | DMG_RADIATION | DMG_DROWNRECOVER | DMG_ACID | DMG_SLOWBURN ) | DMG_CRUSH | DMG_PHYSGUN | DMG_PREVENT_PHYSICS_FORCE ) ) != 0 )
	if ( info.GetDamageForce() != Vector() || bNoPhysicsForceDamage )
	{
		if ( info.GetDamageType() & DMG_BLAST )
		{
			// Fudge blast forces a little bit, so that each
			// victim gets a slightly different trajectory. 
			// This simulates features that usually vary from
			// person-to-person variables such as bodyweight,
			// which are all indentical for characters using the same model.
			local scale = RandomFloat( 0.85, 1.15 )
			local force = info.GetDamageForce()
			force.x *= scale
			force.y *= scale
			// Try to always exaggerate the upward force because we've got pretty harsh gravity
			force.z *= (force.z > 0) ? 1.15 : scale
			return force
		}

		return info.GetDamageForce()
	}

	local pForce = info.GetInflictor()
	if ( !pForce )
	{
		pForce = info.GetAttacker()
	}

	if ( pForce )
	{
		// Calculate an impulse large enough to push a 75kg man 4 in/sec per point of damage
		local forceScale = info.GetDamage() * 75 * 4

		local forceVector
		// If the damage is a blast, point the force vector higher than usual, this gives 
		// the ragdolls a bodacious "really got blowed up" look.
		if ( info.GetDamageType() & DMG_BLAST )
		{
			// exaggerate the force from explosions a little (37.5%)
			forceVector = (GetLocalOrigin() + Vector(0, 0, (GetBoundingMins() - GetBoundingMaxs()).z) ) - pForce.GetLocalOrigin();
			forceVector.Norm()
			forceVector *= 1.375;
		}
		else
		{
			// taking damage from self?  Take a little random force, but still try to collapse on the spot.
			if ( this == pForce )
			{
				forceVector.x = RandomFloat( -1.0, 1.0 )
				forceVector.y = RandomFloat( -1.0, 1.0 )
				forceVector.z = 0.0
				forceScale = RandomFloat( 1000.0, 2000.0 )
			}
			else
			{
				// UNDONE: Collision forces are baked in to CTakeDamageInfo now
				// UNDONE: Is this MOVETYPE_VPHYSICS code still necessary?
				if ( pForce.GetMoveType() == MOVETYPE_VPHYSICS )
				{	
					// no physics objects
					// killed by a physics object
					/* IPhysicsObject *pPhysics = VPhysicsGetObject();
					if ( !pPhysics )
					{
						pPhysics = pForce->VPhysicsGetObject();
					}
					pPhysics->GetVelocity( &forceVector, null );
					forceScale = pPhysics->GetMass(); */
				}
				else
				{
					forceVector = GetLocalOrigin() - pForce.GetLocalOrigin()
					forceVector.Norm()
				}
			}
		}
		return forceVector * forceScale;
	}
	return Vector();
}
/** 
 * @type {function}
 * @param {CTakeDamageInfo} info
 */
function CTFPlayer::CBaseCombatCharacter_Event_Killed( info )
{
	// Advance life state to dying
	SetPropInt(this, "m_lifeState", LIFE_DYING)

	// Calculate death force
	local forceVector = CalcDamageForceVector( info );

	// See if there's a ragdoll magnet that should influence our force.
	// CRagdollMagnet *pMagnet = CRagdollMagnet::FindBestMagnet( this );
	// if ( pMagnet )
	// {
	// 	forceVector += pMagnet->GetForceVector( this );
	// }

	local pDroppedWeapon = GetActiveWeapon()

	// Drop any weapon that I own
	//Weapon_Drop does not function
	/* if ( VPhysicsGetObject() )
	{
		Vector weaponForce = forceVector * VPhysicsGetObject()->GetInvMass();
		Weapon_Drop( m_hActiveWeapon, null, &weaponForce );
	}
	else
	{
		Weapon_Drop( m_hActiveWeapon );
	} */
	
	// if flagged to drop a health kit
	if (HasSpawnFlags( 1<<3 ))
	{
		local kit = SpawnEntityFromTable("item_healthvial", {})
		kit.SetAbsOrigin(GetOrigin())
		kit.SetAbsAngles(GetAbsAngles())
	}
	// clear the deceased's sound channels.(may have been firing or reloading when killed)
	EmitSound( "BaseCombatCharacter.StopWeaponSounds" )

	// Tell my killer that he got me!
	if ( info.GetAttacker() )
	{ 
		// info.GetAttacker()->Event_KilledOther(this, info); // TODO:
		// g_EventQueue.AddEvent( info.GetAttacker(), "KilledNPC", 0.3, this, this );
	}
	SendGlobalGameEvent("entity_killed", {
		entindex_killed = entindex()
		entindex_attacker = info.GetAttacker() ? info.GetAttacker().entindex() : -1
		entindex_inflictor = info.GetInflictor() ? info.GetInflictor().entindex() : -1
		damagebits = info.GetDamageType()
	})

	// Ragdoll unless we've gibbed
	if ( ShouldGib( info ) == false )
	{
		local bRagdollCreated = false
		if ( (info.GetDamageType() & DMG_DISSOLVE) && !(GetFlags() & FL_TRANSRAGDOLL))
		{
			local nDissolveType = 0
			if ( info.GetDamageType() & DMG_SHOCK )
			{
				nDissolveType = 1
			}

			// bRagdollCreated = Dissolve( null, Time(), false, nDissolveType );

			// Also dissolve any weapons we dropped
			// if ( pDroppedWeapon )
			// {
			// 	pDroppedWeapon->Dissolve( null, Time(), false, nDissolveType );
			// }
		}
		if ( !bRagdollCreated && ( info.GetDamageType() & DMG_REMOVENORAGDOLL ) == 0 )
		{
			// BecomeRagdoll( info, forceVector );
		}
	}
	
	// no longer standing on a nav area
	// ClearLastKnownArea() // cant
	
	// TheNextBots().OnKilled( this, info ); // maybe

	SetPropBool(this, "m_bGlowEnabled", false)
}

function CTFPlayer::CBaseCombatCharacter_OnTakeDamage( info )
{
	local retVal = 0

	if (!CanTakeDamage(this))
		return 0

	SetPropInt(this, "m_iDamageCount", GetPropInt(this, "m_iDamageCount") + 1)

	// cant do
	// if ( info.GetDamageType() & DMG_SHOCK )
	// {
	// 	g_pEffects->Sparks( info.GetDamagePosition(), 2, 2 );
	// 	UTIL_Smoke( info.GetDamagePosition(), RandomInt( 10, 15 ), 10 );
	// }

	// track damage history
	if ( info.GetAttacker() )
	{
		local attackerTeam = info.GetAttacker().GetTeam()

		SetInternalVar("m_hasBeenInjured", GetInternalVar("m_hasBeenInjured", 0) | ( 1 << attackerTeam ))

		// for( int i=0; i<MAX_DAMAGE_TEAMS; ++i )
		// {
		// 	if ( m_damageHistory[i].team == attackerTeam )
		// 	{
		// 		// restart the injury timer
		// 		m_damageHistory[i].interval.Start();
		// 		break;
		// 	}

		// 	if ( m_damageHistory[i].team == TEAM_INVALID )
		// 	{
		// 		// team not registered yet
		// 		m_damageHistory[i].team = attackerTeam;
		// 		m_damageHistory[i].interval.Start();
		// 		break;
		// 	}
		// }
	}

	switch( GetPropInt("m_lifeState") )
	{
	case LIFE_ALIVE:
		retVal = CBaseCombatCharacter_OnTakeDamage_Alive( info );
		if ( GetHealth() <= 0 )
		{
			// no Physics
			// IPhysicsObject *pPhysics = VPhysicsGetObject();
			// if ( pPhysics )
			// {
			// 	pPhysics->EnableCollisions( false );
			// }
			
			local bGibbed = false;

			Event_Killed( info )

			// Only classes that specifically request it are gibbed
			if ( ShouldGib( info ) )
			{
				SetPropInt(this, "m_takedamage", DAMAGE_NO)
				AddSolidFlags( FSOLID_NOT_SOLID )
				SetPropInt(this, "m_lifeState", LIFE_DEAD)
			}
		}
		return retVal;

	case LIFE_DYING:
		return CBaseCombatCharacter_OnTakeDamage_Dying( info );

	default:
	case LIFE_DEAD:
		retVal = CBaseCombatCharacter_OnTakeDamage_Dead( info );
		if ( GetHealth() <= 0 && ( ( info.GetDamageType() & ( DMG_CRUSH | DMG_FALL | DMG_BLAST | DMG_SONIC | DMG_CLUB ) ) != 0 ) && ShouldGib( info ) )
		{
			SetPropInt(this, "m_takedamage", DAMAGE_NO)
			AddSolidFlags( FSOLID_NOT_SOLID )
			SetPropInt(this, "m_lifeState", LIFE_DEAD)
			return 0
		}
	}
}

function CTFPlayer::CBaseCombatCharacter_OnTakeDamage_Alive( info )
{
	if ( CanTakeDamage(this) != DAMAGE_EVENTS_ONLY )
	{
		// Separate the fractional amount of damage from the whole
		local flFractionalDamage = info.GetDamage() - floor( info.GetDamage() );
		/** @type {integer} */
		local flIntegerDamage = info.GetDamage() - flFractionalDamage

		// Add fractional damage to the accumulator
		SetPropFloat(this, "m_flDamageAccumulator", GetPropFloat(this, "m_flDamageAccumulator") + flFractionalDamage)
		// If the accumulator is holding a full point of damage, move that point
		// of damage into the damage we're about to inflict.
		if ( GetPropFloat(this, "m_flDamageAccumulator") >= 1.0 )
		{
			flIntegerDamage += 1
			SetPropFloat(this, "m_flDamageAccumulator", GetPropFloat(this, "m_flDamageAccumulator") - 1.0)
		}

		if ( flIntegerDamage <= 0 )
			return 0

		SetHealth(GetHealth() - flIntegerDamage)
	}
	return 1;
}

function CTFPlayer::CBaseCombatCharacter_OnTakeDamage_Dying( info )
	return 1

function CTFPlayer::CBaseCombatCharacter_OnTakeDamage_Dead( info )
{
	// do the damage
	if ( CanTakeDamage(this) != DAMAGE_EVENTS_ONLY )
	{
		SetHealth(GetHealth() - info.GetDamage())
	}

	return 1
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

	// Suicide explode always gibs.
	if ( GetInternalVar("m_bSuicideExplode", false) )
	{
		SetInternalVar("m_bSuicideExplode", false)
		return true
	}

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
				if ( iDisguiseNoBurn == 1 )
				{
					// Do a hard out in the caller
					return -1
				}
			}

			if ( pVictim.InCond( TF_COND_FIRE_IMMUNE ) )
			{
				// Do a hard out in the caller
				return -1
			}
		}

		// When obscured by smoke, attacks have a chance to miss
		if ( pVictim && pVictim.InCond( TF_COND_OBSCURED_SMOKE ) )
		{
			if ( RandomInt( 1, 4 ) >= 2 )
			{
				flRealDamage = 0.0

				// pVictim.SpeakConceptIfAllowed( MP_CONCEPT_DODGE_SHOT )

				if ( pTFAttacker )
					DispatchParticleEffect("miss_test", pVictim.GetCenter() + Vector(0, 0, 32), Vector(0, 0, 1))

				// No damage
				return -1.0
			}
		}

		// Proc invicibility upon being hit
		local flUberChance = CALL_ATTRIB_HOOK_FLOAT_ON_OTHER( pVictim, "uber on damage taken", 0.0)
		if ( RandomFloat(0.0, 1.0) < flUberChance )
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
		
		// Check if we're immune
		outParams.bPlayDamageReductionSound = CheckForDamageTypeImmunity( info.GetDamageType(), pVictim, flDamageBase, flDamageBonus )

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
				// Check for medic resist
				outParams.bPlayDamageReductionSound = CheckMedicResist( TF_COND_MEDIGUN_SMALL_FIRE_RESIST, TF_COND_MEDIGUN_UBER_FIRE_RESIST, pVictim, flRawDamage, flDamageBase, bCrit, flDamageBonus )
			}

			if ( pTFAttacker && pVictim && pVictim.InCond( TF_COND_BURNING ) )
			{
				flDamageBase *= CALL_ATTRIB_HOOK_FLOAT_ON_OTHER( pTFAttacker.GetActiveWeapon(), "damage bonus vs burning", 1.0)
			}

			if ( (info.GetDamageType() & (DMG_BLAST) ) )
			{
				local bReduceBlast = false

				// If someone else shot us or we're in MvM
				if ( pAttacker != pVictimBaseEntity || IsMannVsMachineMode() )
				{
					bReduceBlast = true
				}

				if ( bReduceBlast )
				{
					flDamageBase *= CALL_ATTRIB_HOOK_FLOAT_ON_OTHER( pVictim, "dmg taken from blast reduced", 1.0)
					flDamageBase *= CALL_ATTRIB_HOOK_FLOAT_ON_OTHER( pVictim, "dmg taken from blast increased", 1.0)

					// Check for medic resist
					outParams.bPlayDamageReductionSound = CheckMedicResist( TF_COND_MEDIGUN_SMALL_BLAST_RESIST, TF_COND_MEDIGUN_UBER_BLAST_RESIST, pVictim, flRawDamage, flDamageBase, bCrit, flDamageBonus )
				}
			}

			if ( info.GetDamageType() & (DMG_BULLET|DMG_BUCKSHOT) )
			{
				flDamageBase *= CALL_ATTRIB_HOOK_FLOAT_ON_OTHER( pVictim, "dmg taken from bullets reduced", 1.0 )
				flDamageBase *= CALL_ATTRIB_HOOK_FLOAT_ON_OTHER( pVictim, "dmg taken from bullets increased", 1.0 )
				flDamageBase *= CALL_ATTRIB_HOOK_FLOAT_ON_OTHER( pVictim, "SET BONUS: dmg taken from bullets increased", 1.0 )
				flDamageBase *= CALL_ATTRIB_HOOK_FLOAT_ON_OTHER( pVictim, "CARD: dmg taken from bullets reduced", 1.0 )

				// Check for medic resist
				outParams.bPlayDamageReductionSound = CheckMedicResist( TF_COND_MEDIGUN_SMALL_BULLET_RESIST, TF_COND_MEDIGUN_UBER_BULLET_RESIST, pVictim, flRawDamage, flDamageBase, bCrit, flDamageBonus )
			}

			if ( info.GetDamageType() & DMG_MELEE )
			{
				flDamageBase *= CALL_ATTRIB_HOOK_FLOAT_ON_OTHER( pVictim, "dmg taken from melee", 1.0 )
				flDamageBase *= CALL_ATTRIB_HOOK_FLOAT_ON_OTHER( pVictim.GetActiveWeapon(), "dmg from melee increased", 1.0 )
			}

			if ( pVictim.IsPlayerClass( TF_CLASS_HEAVYWEAPONS ) && pVictim.InCond( TF_COND_AIMING ) && ( ( pVictim.GetHealth() - flRealDamage ) / pVictim.GetMaxHealth() ) <= 0.5 )
			{
				local flOriginalDamage = flDamageBase
				flDamageBase *= CALL_ATTRIB_HOOK_FLOAT_ON_OTHER( pVictim, "spunup_damage_resistance", 1.0 )
				if ( flOriginalDamage != flDamageBase )
				{
					pVictim.PlayDamageResistSound( flOriginalDamage, flDamageBase )
				}
			}
		}

		// If the damage changed at all play the resist sound
		if ( flDamageBase != flRawDamage )
		{
			outParams.bPlayDamageReductionSound = true
		}

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
					SendGlobalGameEvent("damage_resisted", {
						entindex = pVictim.entindex()
					})
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
				if ( IsSentry( info.GetInflictor() ) )
					flRealDamage *= CALL_ATTRIB_HOOK_FLOAT_ON_OTHER( pVictim, "SET BONUS: dmg from sentry reduced", 1.0 )
			}
			else
			{
				local pSentryRocket = info.GetInflictor()
				if ( IsSentryRocket( pSentryRocket ) && pSentryRocket.GetOwner() )
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
				if (IsConvarAllowed("tf_populator_damage_multiplier"))
					flRealDamage *= GetCvarFloat("tf_populator_damage_multiplier")
			}
		}

		// Heavy rage-based knockback+stun effect that also reduces their damage output
		if ( pTFAttacker && pTFAttacker.IsPlayerClass( TF_CLASS_HEAVYWEAPONS ) )
		{
			local iRage = CALL_ATTRIB_HOOK_INT_ON_OTHER( pTFAttacker, "generate rage on damage", 0 )
			if ( iRage && pTFAttacker.IsRageDraining() )
			{
				flRealDamage *= 0.5
			}
		}

		if ( pVictim && pTFAttacker && info.GetWeapon() )
		{
			local pWeapon = pTFAttacker.GetActiveWeapon()
			if ( pWeapon && pWeapon.IsSniperRifle() && info.GetWeapon() == pWeapon )
			{
				local flStun = CALL_ATTRIB_HOOK_FLOAT_ON_OTHER( pWeapon, "applies snare effect", 1.0 )
				if ( flStun != 1.0 )
				{
					local flDuration = 0.0
					local flMaxJarateTime = CALL_ATTRIB_HOOK_FLOAT_ON_OTHER( pWeapon, "jarate duration", 0.0 )
					if ( flMaxJarateTime > 0.0 )
						flDuration = MATH.RemapValClamped( GetPropFloat( weapon, "SniperRifleLocalData.m_flChargedDamage" ), TF_WEAPON_SNIPERRIFLE_DAMAGE_MIN, TF_WEAPON_SNIPERRIFLE_DAMAGE_MATH.Max, 2.0, flMaxJarateTime )

					pVictim.StunPlayer( flDuration, flStun, TF_STUN_MOVEMENT, pTFAttacker )
				}
			}
		}

		if ( pVictim && pVictim.GetActiveWeapon() && !iAttackIgnoresResists )
		{
			if ( info.GetDamageType() & (DMG_CLUB) )
			{
				flRealDamage *= CALL_ATTRIB_HOOK_FLOAT_ON_OTHER( pVictim.GetActiveWeapon(), "mult_dmgtaken_active", 1.0 )
			}
			else if ( info.GetDamageType() & (DMG_BLAST|DMG_BULLET|DMG_BUCKSHOT|DMG_IGNITE|DMG_SONIC) )
			{
				local flBeforeDamage = flRealDamage
				flRealDamage *= CALL_ATTRIB_HOOK_FLOAT_ON_OTHER( pVictim.GetActiveWeapon(), "dmg from ranged reduced", 1.0 )
				PotentiallyDamageMitigatedEvent( pVictim, pVictim, pVictim.GetActiveWeapon(), flBeforeDamage, flRealDamage )
			}
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
				local flDamageReduction = MATH.RemapValClamped( pVictim.GetSpyCloakMeter(), 50.0f, 0.0f, tf_feign_death_damage_scale, tf_stealth_damage_reduction )

				// On Activate Reduce Remaining Cloak by 50%
				if ( pVictim.IsFeignDeathReady() )
				{
					flDamageReduction = IsConvarAllowed("tf_feign_death_activate_damage_scale") ? GetCvarFloat("tf_feign_death_activate_damage_scale") : 0.25
				}
				outParams.bSendPreFeignDamage = true

				local flBeforeflRealDamage = flRealDamage

				flRealDamage *= flDamageReduction

				local pWatch = pVictim.GetWeaponClassname("tf_weapon_invis")
				PotentiallyDamageMitigatedEvent( pVictim, pVictim, pWatch, flBeforeflRealDamage, flRealDamage )

				// Original damage would've killed the player, but the reduced damage wont
				if ( flBeforeflRealDamage >= pVictim.GetHealth() && flRealDamage < pVictim.GetHealth() )
				{
					SendGlobalGameEvent("deadringer_cheat_death" {
						spy = pVictim.GetUserID()
						attacker = pTFAttacker ? pTFAttacker.GetUserID() : -1
					})
				}
			}
			// Standard Stealth gives small damage reduction
			else if ( pVictim.InCond( TF_COND_STEALTHED ) )
			{
				flRealDamage *= IsConvarAllowed("tf_stealth_damage_reduction") ? GetCvarFloat("tf_stealth_damage_reduction") : 0.8
			}
		}

		if ( IsConvarAllowed("sv_cheats") && GetCvarBool("sv_cheats") == false )
		{
			if ( flRealDamage <= 0.0 )
			{
				// Do a hard out in the caller
				return -1
			}
		}
		else
		{
			// allow negative health values for things like the hurtme command
			if ( flRealDamage == 0.0 )
			{
				// Do a hard out in the caller
				return -1
			}
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
				{
					flRealDamage = 0
				}

				flRealDamage *= CALL_ATTRIB_HOOK_FLOAT_ON_OTHER( info.GetWeapon(), "blast dmg to self increased", 1.0)
			}
		}

		// Precision Powerup removes self damage
		if ( pTFAttacker == pVictim && pTFAttacker.GetCurrentRune() == RUNE_PRECISION )
		{
			flRealDamage = 0.0
		}

		if ( pTFAttacker && ( pTFAttacker != pVictim ) )
		{
			// Vampire Powerup collects health based on damage received on victim. Does not apply to self damage. Do it here to factor in victim resistance calculations
			if ( pTFAttacker.GetCurrentRune() == RUNE_VAMPIRE && flRealDamage > 0 )
			{
				local pActiveWeapon = pTFAttacker.GetActiveWeapon()
				if ( pActiveWeapon && (pActiveWeapon.IsMinigun() || pActiveWeapon.IsFlamethrower()) )
				{
					pTFAttacker.HealPlayer( flRealDamage * 0.6 )
				}
				else if ( info.GetDamageType() & DMG_MELEE && pVictim.GetCurrentRune() != RUNE_RESIST ) //resist doesn't give the melee bonus
				{
					pTFAttacker.HealPlayer( flRealDamage * 1.25 )
				}
				else if ( info.GetDamageType() & DMG_BLAST )
				{
					local iMaxHealthOverboost = 120
					if ( ( pTFAttacker.GetHealth() - pTFAttacker.GetMaxHealth() ) < iMaxHealthOverboost )
					{
						local iMaxHealthToAdd = ( iMaxHealthOverboost + pTFAttacker.GetMaxHealth() ) - pTFAttacker.GetHealth()
						if ( flRealDamage < iMaxHealthToAdd )
							pTFAttacker.HealPlayer( flRealDamage, true )
						else
							pTFAttacker.HealPlayer( iMaxHealthToAdd, true )
					}
				}
				else
				{
					pTFAttacker.HealPlayer( flRealDamage )
				}
			}

			local iHypeOnDamage = CALL_ATTRIB_HOOK_INT_ON_OTHER( pTFAttacker, "hype on damage" )
			if ( iHypeOnDamage )
			{
				local flHype = MATH.RemapValClamped( flRealDamage, 1.0, 200.0, 1.0, 50.0 )
				pTFAttacker.SetScoutHypeMeter( MATH.Min( 100.0, flHype + pTFAttacker.GetScoutHypeMeter() ) )
			}
		}
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
	if ( !info.GetDamageForForceCalc() ) 
	{
		info.SetDamageForForceCalc( info.GetDamage() )
	}
	local bDebug = GetBoolCvar("tf_debug_damage", false)

	/** @type {CTFPlayer|null} */
	local pVictim = ToTFPlayer( pVictimBaseEntity )
	local pAttacker = info.GetAttacker()
	/** @type {CTFPlayer|null} */
	local pTFAttacker = ToTFPlayer( pAttacker )
	/** @type {CTFWeaponBase|null} */
	local pWeapon = ToBaseWeapon( info.GetWeapon() )

	local iAttackIgnoresResists = CALL_ATTRIB_HOOK_INT_ON_OTHER( pWeapon, "dmg pierces resists absorbs" )

	// damage may not come from a weapon (ie: Bosses, etc)
	// The existing code below already checked for null pWeapon, anyways
	local flDamage = info.GetDamage()

	// Universal damage modifier
	// if (pWeapon)
	// {
	// 	CALL_ATTRIB_HOOK_FLOAT_ON_OTHER(pWeapon, flDamage, mult_all_dmg)
	// }

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
	{
		info.CopyDamageToBaseDamage()
	}

	// Damage type was already crit (Flares / headshot)
	if ( bitsDamage & DMG_CRITICAL )
	{
		info.SetCritType( CTakeDamageInfo.ECritType.CRIT_FULL )
	}

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
						info.AddDamageType( DMG_CRITICAL )
						info.SetCritType( CTakeDamageInfo.ECritType.CRIT_FULL )

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
			local flWaterExitTime = pVictim.GetInternalVar("m_flWaterExitTime", Time())

			if ( pVictim.InCond( TF_COND_URINE ) ||
				 pVictim.InCond( TF_COND_MAD_MILK ) ||
				 pVictim.InCond( TF_COND_GAS ) ||
			   ( pVictim.GetWaterLevel() > WL_NotInWater ) ||
			   ( ( flWaterExitTime > 0 ) && ( Time() - flWaterExitTime < 5.0 ) ) ) // or they exited the water in the last few seconds
			{
				bitsDamage = bitsDamage | DMG_CRITICAL
				info.AddDamageType( DMG_CRITICAL )
				info.SetCritType( CTakeDamageInfo.ECritType.CRIT_FULL )

				if ( pWeapon && (pWeapon.GetIDX() == TF_WEAPON_NEON_ANNIHILATOR || pWeapon.GetIDX() == TF_WEAPON_NEON_ANNIHILATOR_GENUINE))
				{
					SetPropBool(pWeapon, "m_bBroken", true)
				}
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
						info.AddDamageType( DMG_CRITICAL )
						info.SetCritType( CTakeDamageInfo.ECritType.CRIT_FULL )

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
				info.AddDamageType( DMG_CRITICAL )
				info.SetCritType( CTakeDamageInfo.ECritType.CRIT_FULL )
			}
			else
			{
				bAllSeeCrit = true
				info.SetCritType( CTakeDamageInfo.ECritType.CRIT_MINI )
				eBonusEffect = kBonusEffect_MiniCrit
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
				info.AddDamageType( DMG_CRITICAL )
				info.SetCritType( CTakeDamageInfo.ECritType.CRIT_FULL )
			}
		}
	}
	
	// For awarding assist damage stat later
	local eDamageBonusCond = TF_COND_LAST

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
				flDamage += flConsumeBonus
				pVictim.RemoveCondEx( TF_COND_BURNING, true )
				pVictim.EmitSound( "TFPlayer.FlameOut" )

				if ( info.GetCritType() == CTakeDamageInfo.ECritType.CRIT_NONE )
				{
					info.SetCritType( CTakeDamageInfo.ECritType.CRIT_MINI )
					eBonusEffect = kBonusEffect_MiniCrit
				}

				info.SetDamageCustom( TF_DMG_CUSTOM_AXTINGUISHER_BOOSTED )
			}
		}

		if ( info.GetCritType() == CTakeDamageInfo.ECritType.CRIT_NONE )
		{
			local pInflictor = info.GetInflictor()
			local pBaseGrenade = ToBaseGrenade( pInflictor )
			local pBaseRocket = ToBaseRocket( pInflictor )

			if ( pVictim && ( pVictim.InCond( TF_COND_URINE ) ||
			                  pVictim.InCond( TF_COND_MARKEDFORDEATH ) ||
			                  pVictim.InCond( TF_COND_MARKEDFORDEATH_SILENT ) ||
			                  pVictim.InCond( TF_COND_PASSTIME_PENALTY_DEBUFF ) ) )
			{
				bAllSeeCrit = true
				info.SetCritType( CTakeDamageInfo.ECritType.CRIT_MINI )
				eBonusEffect = kBonusEffect_MiniCrit

				if ( !pVictim.InCond( TF_COND_MARKEDFORDEATH_SILENT ) )
					eDamageBonusCond = pVictim.InCond( TF_COND_URINE ) ? TF_COND_URINE : TF_COND_MARKEDFORDEATH
			}
			else if ( pTFAttacker && ( pTFAttacker.InCond( TF_COND_OFFENSEBUFF ) || pTFAttacker.InCond( TF_COND_NOHEALINGDAMAGEBUFF ) ) )
			{
				// Attackers buffed by the soldier do mini-crits.
				bAllSeeCrit = true
				info.SetCritType( CTakeDamageInfo.ECritType.CRIT_MINI )
				eBonusEffect = kBonusEffect_MiniCrit

				if ( pTFAttacker.InCond( TF_COND_OFFENSEBUFF ) )
					eDamageBonusCond = TF_COND_OFFENSEBUFF
			}
			else if ( pTFAttacker && (bitsDamage & DMG_RADIUS_MATH.Max) && pWeapon && ( pWeapon.CanChargeCrit() ) )
			{
				// First sword or bottle attack after a charge is a mini-crit.
				bAllSeeCrit = true
				info.SetCritType( CTakeDamageInfo.ECritType.CRIT_MINI )
				eBonusEffect = kBonusEffect_MiniCrit
			}
			else if ( ( pInflictor && pInflictor.IsPlayer() == false ) && ( ( pBaseRocket && GetPropInt( pBaseRocket, "m_iDeflected" ) ) || ( pBaseGrenade && GetPropInt( pBaseGrenade, "m_iDeflected" ) ) ) )
			{
				// Reflected rockets, grenades (non-remote detonate), arrows always mini-crit
				info.SetCritType( CTakeDamageInfo.ECritType.CRIT_MINI )
				eBonusEffect = kBonusEffect_MiniCrit
			}
			else if ( info.GetDamageCustom() == TF_DMG_CUSTOM_PLASMA_CHARGED )
			{
				// Charged plasma shots do minicrits.
				info.SetCritType( CTakeDamageInfo.ECritType.CRIT_MINI )
				eBonusEffect = kBonusEffect_MiniCrit
			}
			else if ( info.GetDamageCustom() == TF_DMG_CUSTOM_CLEAVER_CRIT )
			{
				// Long range cleaver hit
				info.SetCritType( CTakeDamageInfo.ECritType.CRIT_MINI )
				eBonusEffect = kBonusEffect_MiniCrit
			}
			else if ( pTFAttacker && ( pTFAttacker.InCond( TF_COND_ENERGY_BUFF ) ) )
			{
				// Scouts using crit drink do mini-crits, as well as receive them
				info.SetCritType( CTakeDamageInfo.ECritType.CRIT_MINI )
				eBonusEffect = kBonusEffect_MiniCrit
			}
			else if ( ( info.GetDamageType() & DMG_IGNITE ) && pVictim && pVictim.InCond( TF_COND_BURNING ) && info.GetDamageCustom() == TF_DMG_CUSTOM_BURNING_FLARE )
			{
				if ( pWeapon && pWeapon.GetAttribute( "lunchbox adds minicrits", 0 ) == 2 )
				{
					info.SetCritType( CTakeDamageInfo.ECritType.CRIT_MINI )
					eBonusEffect = kBonusEffect_MiniCrit
				}
			}
			else if ( info.GetDamageCustom() == TF_DMG_CUSTOM_FLARE_PELLET )
			{
				//TODO:
				// CBaseEntity *pInflictor = info.GetInflictor()
				// CTFProjectile_Flare *pFlare = dynamic_cast< CTFProjectile_Flare* >( pInflictor )
				// if ( pFlare && pFlare->IsFromTaunt() && pFlare->GetTimeAlive() < 0.05f )
				// {
					// Taunt crits fired from the scorch shot at short range are super powerful!
					// flDamage += Max( 400.f, flDamage )
				// }
			}
			else if ( pTFAttacker && pWeapon && pWeapon.GetIDX() == 996 && ( info.GetDamageType() & DMG_BLAST ) )
			{
				//TODO:
				// CTFGrenadeLauncher* pGrenadeLauncher = static_cast<CTFGrenadeLauncher*>( pWeapon )
				// if ( pGrenadeLauncher->IsDoubleDonk( pVictim ) )
				// {
				// 	info.SetCritType( CTakeDamageInfo.ECritType.CRIT_MINI )
				// 	eBonusEffect = kBonusEffect_DoubleDonk
				// 	flDamage = Max( flDamage, info.GetMaxDamage() ) // Double donk victims score max damage
				// 	EconEntity_OnOwnerKillEaterEvent( pGrenadeLauncher, pTFAttacker, pVictim, kKillEaterEvent_DoubleDonks )
				// }
			}
			else if ( pTFAttacker && pWeapon && pWeapon.GetIDX() == 1178 && info.GetDamageCustom() == TF_DMG_CUSTOM_DRAGONS_FURY_BONUS_BURNING )
			{
				eBonusEffect = kBonusEffect_DragonsFury
			}
			else if ( pTFAttacker && pTFAttacker.IsPlayerClass( TF_CLASS_SCOUT ) && !( pTFAttacker.GetFlags() & FL_ONGROUND ) )
			{
				// Make sure the weapon that did this damage is the same as the one that grants mini-crits
				if ( info.GetWeapon() == pTFAttacker.GetActiveWeapon() )
				{
					local iDashCount = CALL_ATTRIB_HOOK_INT_ON_OTHER( pTFAttacker.GetActiveWeapon(), "air dash count" )
					if ( iDashCount )
					{
						info.SetCritType( CTakeDamageInfo.ECritType.CRIT_MINI )
						eBonusEffect = kBonusEffect_MiniCrit
					}
				}
			}
			else if ( pVictim && pTFAttacker && pTFAttacker.IsPlayerClass( TF_CLASS_SNIPER ) && pWeapon && pWeapon.IsSniperRifle() )
			{
				if ( IsHeadshot( info.GetDamageCustom() ) || pVictim.LastHitGroup() == HITGROUP_HEAD )
				{
					local pSniper = pWeapon
					if ( pSniper.IsZoomed() && pSniper.GetJarateTime() )
					{
						local flJarateTime = pSniper.GetJarateTime()
						if ( flJarateTime >= 1.0 )
						{
							info.SetCritType( CTakeDamageInfo.ECritType.CRIT_MINI )
							eBonusEffect = kBonusEffect_MiniCrit
						}
					}
				}
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
						info.SetCritType( CTakeDamageInfo.ECritType.CRIT_MINI )
						eBonusEffect = kBonusEffect_MiniCrit
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
							info.SetCritType( CTakeDamageInfo.ECritType.CRIT_MINI )
							eBonusEffect = kBonusEffect_MiniCrit
							break
						}
					}

					//// Some weapons minicrit *any* target in the air, regardless of how they got there.
					local iMiniCritAirborneDeploy = CALL_ATTRIB_HOOK_INT_ON_OTHER( pWeapon, "mod mini-crit airborne deploy" )
					if ( iMiniCritAirborneDeploy > 0 && pWeapon && pVictim && !( pVictim.GetFlags() & FL_ONGROUND ) && ( pVictim.GetWaterLevel() == WL_NotInWater ) )
					{
						bAllSeeCrit = true
						info.SetCritType( CTakeDamageInfo.ECritType.CRIT_MINI )
						eBonusEffect = kBonusEffect_MiniCrit
						break
					}
				}
			}

			//TODO: cant do GetEnemy, try to find and store in scope maybe?
			// Don't do long range distance falloff when pAttacker has Rocket Specialist attrib and directly hits an enemy
			// if ( pBaseRocket && pBaseRocket->GetEnemy() && pBaseRocket->GetEnemy() == pVictimBaseEntity )
			// {
			// 	int iRocketSpecialist = 0
			// 	CALL_ATTRIB_HOOK_INT_ON_OTHER( pAttacker, iRocketSpecialist, rocket_specialist )
			// 	if ( iRocketSpecialist )
			// 		bIgnoreLongRangeDmgEffects = true
			// }

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
					local entForward = pVictim.EyeAngles().Forward()
					toEnt.z = 0
					toEnt.Norm()

					if ( toEnt.Dot( entForward ) > 0.259 )	// 75 degrees from center (total of 150)
					{
						bAllSeeCrit = true
						info.SetCritType( CTakeDamageInfo.ECritType.CRIT_MINI )
						eBonusEffect = kBonusEffect_MiniCrit
					}
				}
			}
		}
	}

	if ( info.GetCritType() == CTakeDamageInfo.ECritType.CRIT_MINI )
	{
		if ( IsPowerupMode() && ( info.GetDamageType() & DMG_MELEE ) )
			flDamage /= 1.3
		local iPromoteMiniCritToCrit = CALL_ATTRIB_HOOK_INT_ON_OTHER( pWeapon, "minicrits become crits" )
		if ( iPromoteMiniCritToCrit == 1 )
		{
			info.SetCritType( CTakeDamageInfo.ECritType.CRIT_FULL )
			eBonusEffect = kBonusEffect_Crit
			bitsDamage = bitsDamage | DMG_CRITICAL
			info.AddDamageType( DMG_CRITICAL )
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
			local iOldTakeDamage = CanTakeDamage(pVictim)
			SetPropInt(pVictim, "m_takedamage", DAMAGE_EVENTS_ONLY)
			// NOTE: Deliberately skip base player OnTakeDamage, because we don't want all the stuff it does re: suit voice
			pVictim.CBaseCombatCharacter_OnTakeDamage( info )
			SetPropInt(pVictim, "m_takedamage", iOldTakeDamage)

			// Burn sounds are handled in ConditionThink()
			if ( !(bitsDamage & DMG_BURN ) )
				EntFireNew(pVictim, "SpeakResponseConcept", "TLK_HURT")

			// If this is critical explosive damage, and the Medic giving us invuln triggered 
			// it in the last second, he's earned himself an achievement. 
			// if ( (bitsDamage & DMG_CRITICAL) && (bitsDamage & DMG_BLAST) )
			// {
			// 	pVictim->m_Shared.CheckForAchievement( ACHIEVEMENT_TF_MEDIC_SAVE_TEAMMATE )
			// } // No TOUCHY

			return false
		}
	}

	// Apply attributes that increase damage vs players
	if ( pWeapon )
	{
		flDamage *= CALL_ATTRIB_HOOK_FLOAT_ON_OTHER( pWeapon, "dmg penalty vs players", 1.0 )

		// Check if we're to boost damage against the same class
		if ( pVictim && pTFAttacker )
		{
			local nVictimClass		= pVictim.GetPlayerClass()
			local nAttackerClass	= pTFAttacker.GetPlayerClass()

			// Same class? Potentially boost damage
			if ( nVictimClass == nAttackerClass )
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
					info.SetDamageType( info.GetDamageType() & (~DMG_CRITICAL) )
					info.SetCritType( CTakeDamageInfo.ECritType.CRIT_NONE )
				}
			}
		}

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
			if ( eBonusEffect == kBonusEffect_MiniCrit || eBonusEffect == kBonusEffect_Crit )
				eBonusEffect = kBonusEffect_None
			info.SetCritType( CTakeDamageInfo.ECritType.CRIT_NONE )
			bAllSeeCrit = false
			bShowDisguisedCrit = false

			pVictim.SetInternalVar("m_bAllSeeCrit", bAllSeeCrit)
			pVictim.SetInternalVar("m_bMiniCrit", false)
			pVictim.SetInternalVar("m_bShowDisguisedCrit", bShowDisguisedCrit)
			pVictim.SetInternalVar("m_eBonusAttackEffect", eBonusEffect)

			bitsDamage = bitsDamage & ~DMG_CRITICAL
			info.SetDamageType( bitsDamage )
			info.SetCritType( CTakeDamageInfo.ECritType.CRIT_NONE )
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
				flOptimalDistance = SENTRY_MATH.Max_RANGE
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

				if ( bDebug )
					Warning("    RANDOM: Dist %.2f, Ctr: %.2f, Min: %.2f, Max: %.2f\n", flDistance, flCenter, flMin, flMax )
			}
			else
			{
				if ( bDebug )
					Warning("    NO DISTANCE MOD: Dist %.2f, Ctr: %.2f, Min: %.2f, Max: %.2f\n", flDistance, flCenter, flMin, flMax )
			}
		}
		//Msg("Range: %.2f - %.2f\n", flMin, flMax )
		local flRandomRangeVal
		if ( GetBoolCvar("tf_damage_disablespread", true) || ( pTFAttacker && pTFAttacker.GetCurrentRune() == RUNE_PRECISION ) )
			flRandomRangeVal = flMin + flRandomDamageSpread
		else
			flRandomRangeVal = RandomFloat( flMin, flMax )

		//if ( bDebug )
		//{
		//	Warning( "            Val: %.2f\n", flRandomRangeVal )
		//}

		// Weapon Based Damage Mod
		if ( pWeapon && pAttacker && pAttacker.IsPlayer() )
		{
			// Rocket launcher only has half the bonus of the other weapons at short range
			if ( pWeapon.IsRocketLauncher() && flRandomRangeVal > 0.5 )
				flRandomDamage *= 0.5

			if ( pWeapon.IsPipeLauncher() || pWeapon.IsStickyLauncher() || pWeapon.IsStickbomb() && !( bitsDamage & DMG_NOCLOSEDISTANCEMOD ) )
				flRandomDamage *= 0.2

			if ( pWeapon.IsScattergun() && flRandomRangeVal > 0.5 )
				flRandomDamage *= 1.5
		}

		// Random damage variance.
		flDmgVariance = SimpleSplineRemapValClamped( flRandomRangeVal, 0, 1, -flRandomDamage, flRandomDamage )
		if ( ( bDoShortRangeDistanceIncrease && flDmgVariance > 0.0 ) || bDoLongRangeDistanceDecrease )
			flDamage += flDmgVariance

		if ( bDebug )
			Warning("            Out: %.2f -> Final %.2f\n", flDmgVariance, flDamage )

		/*
		for ( float flVal = flMin flVal <= flMax flVal += 0.05 )
		{
			float flOut = SimpleSplineRemapValClamped( flVal, 0, 1, -flRandomDamage, flRandomDamage )
			Msg("Val: %.2f, Out: %.2f, Dmg: %.2f\n", flVal, flOut, info.GetDamage() + flOut )
		}
		*/

		// Burn sounds are handled in ConditionThink()
		if ( !(bitsDamage & DMG_BURN ) && pVictim )
			EntFireNew(pVictim, "SpeakResponseConcept", "TLK_HURT")


		// Save any bonus damage as a separate value
		local flCritDamage = 0.0
		// Yes, it's weird that we sometimes fabs flDmgVariance.  Here's why: In the case of a crit rocket, we
		// know that number will generally be negative due to dist or randomness.  In this case, we want to track
		// that effect - even if we don't apply it.  In the case of our crit rocket that normally would lose 50 
		// damage, we fabs'd so that we can account for it as a bonus - since it's present in a crit.
		local flBonusDamage = bForceCritFalloff ? 0.0 : fabs( flDmgVariance )
		local pProvider = null

		local function lambdaDoMinicrit( bDemote = false )
		{
			// We should never have both of these flags set or Weird Things will happen with the damage numbers
			// that aren't clear to the players. Or us, really.
			Assert( !(bitsDamage & DMG_CRITICAL) )

			if ( bDebug )
			{
				Warning( "    MINICRIT: Dmg %.2f -> ", flDamage )
			}

			// COMPILE_TIME_ASSERT( TF_DAMAGE_MINICRIT_MULTIPLIER > 1.f )
			flCritDamage = ( TF_DAMAGE_MINICRIT_MULTIPLIER - 1.0 ) * flDamage

			bitsDamage = bitsDamage | DMG_CRITICAL
			info.AddDamageType( DMG_CRITICAL )
			info.SetCritType( CTakeDamageInfo.ECritType.CRIT_MINI )
			if ( pVictim && bDemote )
				pVictim.SetInternalVar("m_eBonusAttackEffect", kBonusEffect_MiniCrit)

			// Any condition assist stats to send out?
			if ( eDamageBonusCond < TF_COND_LAST )
			{
				//TODO: cant get cond providers yet
				// if ( pVictim )
				// {
				// 	pProvider = ToTFPlayer( pVictim->m_Shared.GetConditionProvider( eDamageBonusCond ) )
				// 	if ( pProvider )
				// 	{
				// 		CTF_GameStats.Event_PlayerDamageAssist( pProvider, flCritDamage + flBonusDamage )
				// 	}
				// }
				// if ( pTFAttacker )
				// {
				// 	pProvider = ToTFPlayer( pTFAttacker->m_Shared.GetConditionProvider( eDamageBonusCond ) )
				// 	if ( pProvider && pProvider != pTFAttacker )
				// 	{
				// 		CTF_GameStats.Event_PlayerDamageAssist( pProvider, flCritDamage + flBonusDamage )
				// 	}
				// }
			}

			if ( bDebug )
				Warning( "reduced to %.2f before crit mult\n", flDamage )
		}

		local function lambdaDoFullCrit()
		{
			if ( info.GetCritType() != CTakeDamageInfo.ECritType.CRIT_MINI  )
			{
				// COMPILE_TIME_ASSERT( TF_DAMAGE_CRIT_MULTIPLIER > 1.0 )
				flCritDamage = ( TF_DAMAGE_CRIT_MULTIPLIER - 1.0 ) * flDamage
			}

			if ( bDebug )
				Warning( "    CRITICAL! Damage: %.2f\n", flDamage )

			// Burn sounds are handled in ConditionThink()
			if ( !(bitsDamage & DMG_BURN ) && pVictim )
				EntFireNew(pVictim, "SpeakResponseConcept", "TLK_HURT damagecritical:1")

			// No cond providers
			// if ( pTFAttacker && pTFAttacker.IsCritBoosted() )
			// {
			// 	pProvider = ToTFPlayer( pTFAttacker->m_Shared.GetConditionProvider( TF_COND_CRITBOOSTED ) )
			// 	if ( pProvider && pTFAttacker && pProvider != pTFAttacker )
			// 	{
			// 		CTF_GameStats.Event_PlayerDamageAssist( pProvider, flCritDamage + flBonusDamage )	
			// 	}
			// }
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
		
		if ( pAttacker && pAttacker.IsPlayer() ) // Modify damage based on bonuses
			flDamage *= pTFAttacker.InCond(TF_COND_TMPDAMAGEBONUS) ? pTFAttacker.GetInternalVar("m_flTmpDamageBonusAmount", 1.0) : 1.0

		// Store the extra damage and update actual damage
		if ( bCrit || info.GetCritType() == CTakeDamageInfo.ECritType.CRIT_MINI  )
			info.SetDamageBonus( flCritDamage + flBonusDamage, pProvider )	// Order-of-operations sensitive, but fine as long as TF_COND_CRITBOOSTED is last

		// Crit-A-Cola and Steak Sandwich - only increase normal damage
		if ( pVictim && pVictim.InCond( TF_COND_ENERGY_BUFF ) && !bCrit && info.GetCritType() != CTakeDamageInfo.ECritType.CRIT_MINI  )
			flDamage *= CALL_ATTRIB_HOOK_FLOAT_ON_OTHER( pVictim, "energy buff dmg taken multiplier", 1.0 )

		flDamage += flCritDamage
	}

	if ( pTFAttacker && pTFAttacker.IsPlayerClass( TF_CLASS_SPY ) )
	{
		if ( pTFAttacker.GetActiveWeapon() )
		{
			local iAddCloakOnHit = CALL_ATTRIB_HOOK_INT_ON_OTHER( pTFAttacker.GetActiveWeapon(), "add cloak on hit" )
			if ( iAddCloakOnHit > 0 )
			{
				pTFAttacker.AddToSpyCloakMeter( iAddCloakOnHit, true )
			}
		}
	}

	if ( info.GetDamageCustom() == TF_DMG_CUSTOM_BACKSTAB )
	{
		// Jarate backstabber
		local iJarateBackstabber = CALL_ATTRIB_HOOK_INT_ON_OTHER( pVictim, "jarate backstabber" )
		if ( iJarateBackstabber > 0 && pTFAttacker )
		{
			pTFAttacker.AddCondEx( TF_COND_URINE, 10.0, pVictim )
			// pTFAttacker->m_Shared.SetPeeAttacker( pVictim ) // cant do need m_hPeeAttacker
			EntFireNew(pVictim, "SpeakResponseConcept", "TLK_JARATE_HIT")
		}

		if ( pVictim && pVictim.CheckBlockBackstab( pTFAttacker ) )
		{
			// The backstab was absorbed by a shield.
			flDamage = 0.0

			// Shake nearby players' screens.
			ScreenShake(pVictim.GetOrigin(), 25.0, 150.0, 1.0, 50.0, 0, false)

			// Play the notification sound.
			pVictim.EmitSound( "Player.Spy_Shield_Break" )

			// Unzoom the sniper.
			local pWeapon2 = pVictim.GetActiveWeapon()
			if ( pWeapon2 && pWeapon2.IsSniperRifle() )
			{
				local pSniperRifle = pWeapon2
				if ( pSniperRifle.IsZoomed() )
				{
					pSniperRifle.ZoomOut()
				}
			}

			// Vibrate the spy's knife.
			if ( pTFAttacker && pTFAttacker.GetActiveWeapon() )
			{
				local pKnife = pTFAttacker.GetActiveWeapon()
				if ( pKnife && pKnife.IsKnife() )
				{
					pKnife.BackstabBlocked()
				}
			}

			// Tell the clients involved in the jarate
			// CRecipientFilter involved_filter
			// involved_filter.AddRecipient( pVictim )
			// involved_filter.AddRecipient( pTFAttacker )

			// UserMessageBegin( involved_filter, "PlayerShieldBlocked" )
			// WRITE_BYTE( pTFAttacker->entindex() )
			// WRITE_BYTE( pVictim->entindex() )
			// MessageEnd()
		}
	}

	info.SetDamage( flDamage )

	// Apply on-hit attributes (after damage has been updated)
	if ( pVictim && pAttacker && pAttacker.GetTeam() != pVictim.GetTeam() && pAttacker.IsPlayer() && pWeapon )
	{
		pWeapon.ApplyOnHitAttributes( pVictimBaseEntity, pTFAttacker, info )
	}

	// Give assist points to the provider of any stun on the victim - up to half the damage, based on the amount of stun
	if ( pVictim && pVictim.InCond( TF_COND_STUNNED ) )
	{
		// Cond providers again
		/* CTFPlayer *pProvider = ToTFPlayer( pVictim->m_Shared.GetConditionProvider( TF_COND_STUNNED ) )
		if ( pProvider && pTFAttacker && pProvider != pTFAttacker )
		{
			float flStunAmount = pVictim->m_Shared.GetAmountStunned( TF_STUN_MOVEMENT )
			if ( flStunAmount < 1.f && pVictim->m_Shared.IsControlStunned() )
				flStunAmount = 1.f

			int nAssistPoints = RemapValClamped( flStunAmount, 0.1f, 1.f, 1, ( info.GetDamage() / 2 ) )
			if ( nAssistPoints )
			{
				CTF_GameStats.Event_PlayerDamageAssist( pProvider, nAssistPoints )	
			}
		} */
	}

	return true
}

/** 
 * @param {CBaseEntity|null} pKiller
 * @param {CBaseEntity|null} pInflictor
 * @param {CBaseEntity|null} pVictim
 * @returns {CBasePlayer}
 */
function ROOT::GetDeathScorer( pKiller, pInflictor, pVictim )
{
	if ( ( pKiller == pVictim ) && ( pKiller == pInflictor ) )
	{
		// If this was an explicit suicide, see if there was a damager within a certain time window.  If so, award this as a kill to the damager.
		local pTFVictim = ToTFPlayer( pVictim )
		if ( pTFVictim )
		{
			// local pRecentDamager = GetRecentDamager( pTFVictim, 0, TF_TIME_SUICIDE_KILL_CREDIT ) // TODO
			local pRecentDamager = null
			if ( pRecentDamager )
				return pRecentDamager
		}
	}

	//Handle Pyro's Deflection credit.
	local pBaseGrenade = ToBaseGrenade(pInflictor)

	if ( pBaseGrenade && GetPropInt(pBaseGrenade, "m_iDeflected") )
	{
		local pDeflectOwner = ToTFPlayer( GetPropEntity(pBaseGrenade, "m_hDeflectOwner") )
		if ( pDeflectOwner )
		{
			if ( pDeflectOwner.GetTeam() != pVictim.GetTeam() )
				return pDeflectOwner
			else
			{
				SetPropInt(pBaseGrenade, "m_iDeflected", 0)
				SetPropEntity(pBaseGrenade, "m_hDeflectOwner", null)
			}
		}
	}

	return pKiller ? pKiller : pInflictor
}

/** 
 * @param {CBasePlayer|null} pVictim
 * @param {CBasePlayer|null} pScorer
 * @param {CBaseEntity|null} pInflictor
 * @returns {CBasePlayer}
 */
function ROOT::GetAssister( pVictim, pScorer, pInflictor )
{
	local pTFScorer = ToTFPlayer( pScorer )
	local pTFVictim = ToTFPlayer( pVictim )
	if ( pTFScorer && pTFVictim )
	{
		// if victim killed himself, don't award an assist to anyone else, even if there was a recent damager
		if ( pTFScorer == pTFVictim )
			return null

		// If an assist has been specified already, use it.
		if ( pTFVictim.GetInternalVar("m_hAssist", null) )
			return pTFVictim.GetInternalVar("m_hAssist", null) 

		local pHealer = ToTFPlayer( pTFScorer.GetActiveHealers()[0] )
		// Must be a medic to receive a healing assist, otherwise engineers get credit for assists from dispensers doing healing.
		// Also don't give an assist for healing if the inflictor was a sentry gun, otherwise medics healing engineers get assists for the engineer's sentry kills.
		if ( pHealer && ( TF_CLASS_MEDIC == pHealer.GetPlayerClass() ) && ( null == ToBaseObject(pInflictor)) )
			return pHealer

		// If we're under the effect of a condition that grants assists, give one to the player that buffed us
		// local pCondAssister = ToTFPlayer( pTFScorer->m_Shared.GetConditionAssistFromAttacker() ) // TODO
		local pCondAssister = ToTFPlayer( null )
		if ( pCondAssister )
			return pCondAssister

		// See who has damaged the victim 2nd most recently (most recent is the killer), and if that is within a certain time window.
		// If so, give that player an assist.  (Only 1 assist granted, to single other most recent damager.)
		// CTFPlayer *pRecentDamager = GetRecentDamager( pTFVictim, 1, TF_TIME_ASSIST_KILL ); // TODO
		local pRecentDamager = null
		if ( pRecentDamager && ( pRecentDamager != pScorer ) )
			return pRecentDamager;

		// if a teammate has recently helped this sentry (ie: wrench hit), they assisted in the kill
		local sentry = ToBaseObject( pInflictor )
		if ( sentry )
		{
			// CTFPlayer *pAssister = sentry->GetAssistingTeammate( TF_TIME_ASSIST_KILL ); // TODO
			local pAssister = null
			if ( pAssister )
				return pAssister;
		}
	}
	return null;
}

/** 
 * @type {function}
 * @param {CBasePlayer} pVictim
 * @param {CTakeDamageInfo} info
 * @param {string} eventName
 */
/* function ROOT::DeathNotice( pVictim, info, eventName )
{
	local killer_ID = 0

	// Find the killer & the scorer

	local pTFPlayerVictim = ToTFPlayer( pVictim )
	local pInflictor = info.GetInflictor()
	local pKiller = info.GetAttacker()

	local pScorer = ToTFPlayer( GetDeathScorer( pKiller, pInflictor, pVictim ) )
	local pAssister = ToTFPlayer( GetAssister( pVictim, pScorer, pInflictor ) )
	
	// You can't assist yourself!
	Assert( pScorer != pAssister || !pScorer )
	if ( pScorer == pAssister && pScorer )
		pAssister = null

	// Silent killers cause no death notices.
	local bSilentKill = false;
	local pAttacker = ToTFPlayer( info.GetAttacker() )
	if ( pAttacker )
	{
		local pWpn = pAttacker.GetActiveWeapon()
		if ( pWpn && pWpn.GetAttribute("silent killer", 0) == 1 && ( info.GetDamageCustom() == TF_DMG_CUSTOM_BACKSTAB ) )
			bSilentKill = true
	}

	// Determine whether it's a feign death fake death notice
	local bFeignDeath = pTFPlayerVictim.GetInternalVar("m_bGoingFeignDeath", false)
	if ( bFeignDeath )
	{
		local pDisguiseTarget = GetPropEntity(pTFPlayerVictim, "m_Shared.m_hDisguiseTarget")
		if ( pDisguiseTarget && (pTFPlayerVictim.GetTeam() == pDisguiseTarget.GetTeam()) )
		{
			// We're disguised as a team mate. Pretend to die as that player instead of us.
			pVictim = pTFPlayerVictim = pDisguiseTarget
		}
	}

	// Work out what killed the player, and send a message to all clients about it
	int iWeaponID;
	const char *killer_weapon_name = GetKillingWeaponName( info, pTFPlayerVictim, &iWeaponID );
	const char *killer_weapon_log_name = killer_weapon_name;

	// Kill eater events.
	{
		// Was this a sentry kill? If the sentry did the kill itself with bullets then it'll be the inflictor.
		// If it got the kill by firing a rocket, the rocket will be the inflictor and the sentry will be the
		// owner of the rocket.
		//
		// dynamic_cast quagmire of sadness below.
		CObjectSentrygun *pSentrygun = dynamic_cast<CObjectSentrygun *>( pInflictor );
		if ( !pSentrygun )
		{
			pSentrygun = pInflictor ? dynamic_cast<CObjectSentrygun *>( pInflictor->GetOwnerEntity() ) : NULL;
		}

		if ( pSentrygun )
		{
			// Try to grab the wrench that the engineer has equipped right now. We destroy sentries when wrenches
			// get changed so whatever they have equipped right now counts for the wrench that built this sentry.
			CTFPlayer *pBuilder = pSentrygun->GetBuilder();
			if ( pBuilder )
			{
				EconEntity_OnOwnerKillEaterEvent( dynamic_cast<CEconEntity *>( pBuilder->GetEntityForLoadoutSlot( LOADOUT_POSITION_MELEE ) ), pScorer, pTFPlayerVictim, kKillEaterEvent_PlayerKillsBySentry );
				// PDA's Also count Sentry kills
				EconEntity_OnOwnerKillEaterEvent( dynamic_cast<CEconEntity *>( pBuilder->GetEntityForLoadoutSlot( LOADOUT_POSITION_PDA ) ), pScorer, pTFPlayerVictim, kKillEaterEvent_PlayerKillsBySentry );

				// Check if the engineer is using a Wrangler on this sentry
				CTFLaserPointer* pLaserPointer = dynamic_cast< CTFLaserPointer * >( pBuilder->GetEntityForLoadoutSlot( LOADOUT_POSITION_SECONDARY ) );
				if ( pLaserPointer && pLaserPointer->HasLaserDot() )
				{
					EconEntity_OnOwnerKillEaterEvent( dynamic_cast<CEconEntity *>( pLaserPointer ), pScorer, pTFPlayerVictim, kKillEaterEvent_PlayerKillsByManualControlOfSentry );
				}
			}
		}

		// Should we award an assist kill to someone?
		if ( pAssister )
		{
			EconEntity_OnOwnerKillEaterEvent( dynamic_cast<CEconEntity *>( pAssister->GetActiveWeapon() ), pAssister, pTFPlayerVictim, kKillEaterEvent_PlayerKillAssist );
			HatAndMiscEconEntities_OnOwnerKillEaterEvent( pAssister, pTFPlayerVictim, kKillEaterEvent_CosmeticAssists );
		}
	}

	if ( pScorer )	// Is the killer a client?
	{
		killer_ID = pScorer->GetUserID();
	}

	CTFWeaponBase *pScorerWeapon = NULL;
	if ( pScorer )
	{
		pScorerWeapon = dynamic_cast< CTFWeaponBase * >( pScorer->Weapon_OwnsThisID( iWeaponID ) );
		if ( pScorerWeapon )
		{
			CEconItemView *pItem = pScorerWeapon->GetAttributeContainer()->GetItem();

			if ( pItem )
			{
				if ( pItem->GetStaticData()->GetIconClassname() )
				{
					killer_weapon_name = pItem->GetStaticData()->GetIconClassname();
				}
			
				if ( pItem->GetStaticData()->GetLogClassname() )
				{
					killer_weapon_log_name = pItem->GetStaticData()->GetLogClassname();
				}
			}
		}
	}

	// In Arena mode award first blood to the first player that kills an enemy.
	bool bKillWasFirstBlood = false;
	if ( IsFirstBloodAllowed() )
	{
		if ( pScorer && pVictim && pScorer != pVictim )
		{
			if ( !FStrEq( eventName, "fish_notice" ) && !FStrEq( eventName, "fish_notice__arm" ) && !FStrEq( eventName, "slap_notice" ) && !FStrEq( eventName, "throwable_hit" ) )
			{
#ifndef _DEBUG
				if ( GetGlobalTeam( pVictim->GetTeamNumber() ) && GetGlobalTeam( pVictim->GetTeamNumber() )->GetNumPlayers() > 1 )
#endif // !DEBUG
				{
					float flFastTime = IsCompetitiveMode() ? 120.f : TF_ARENA_MODE_FAST_FIRST_BLOOD_TIME;
					float flSlowTime = IsCompetitiveMode() ? 300.f : TF_ARENA_MODE_SLOW_FIRST_BLOOD_TIME;

					if ( ( Time() - m_flRoundStartTime ) <= flFastTime )
					{
						BroadcastSound( 255, "Announcer.AM_FirstBloodFast" );
					}
					else if ( ( Time() - m_flRoundStartTime ) >= flSlowTime )
					{
						BroadcastSound( 255, "Announcer.AM_FirstBloodFinally" );
					}
					else
					{
						BroadcastSound( 255, "Announcer.AM_FirstBloodRandom" );
					}

					m_bArenaFirstBlood = true;
					bKillWasFirstBlood = true;

					// if ( !IsCompetitiveMode() )
						// pScorer->m_Shared.AddCond( TF_COND_CRITBOOSTED_FIRST_BLOOD, TF_ARENA_MODE_FIRST_BLOOD_CRIT_TIME );
				}
			}
		}
	}
	else
	{
		// so you can't turn on the ConVar in the middle of a round and get the first blood reward
		m_bArenaFirstBlood = true;
	}

	// Awesome hack for pyroland silliness: if there was no other assister, and the person that got
	// the kill has some sort of "pet" item (balloonicorn, brainslug, etc.), we send the name of
	// that item down as the assister. We'll use a custom name if available and fall back to the
	// localization token (localized on the client) if not.
	CUtlConstString sAssisterOverrideDesc;

	if ( pScorer && !pAssister )
	{
		// Find out whether the killer has at least one item that will ask for kill assist credit.
		int iKillerHasPetItem = 0;
		CUtlVector<CBaseEntity *> vecItems;
		CALL_ATTRIB_HOOK_FLOAT_ON_OTHER_WITH_ITEMS( pScorer, iKillerHasPetItem, &vecItems, counts_as_assister );

		FOR_EACH_VEC( vecItems, i )
		{
			CEconEntity *pEconEntity = dynamic_cast<CEconEntity *>( vecItems[i] );
			if ( !pEconEntity )
				continue;

			CEconItemView *pEconItemView = pEconEntity->GetAttributeContainer()->GetItem();
			if ( !pEconItemView )
				continue;

			if ( pEconItemView->GetCustomName() )
			{
				sAssisterOverrideDesc = CFmtStr( "%c%s", iKillerHasPetItem == 2 ? kHorriblePyroVisionHack_KillAssisterType_CustomName_First : kHorriblePyroVisionHack_KillAssisterType_CustomName, pEconItemView->GetCustomName() );
			}
			else
			{
				sAssisterOverrideDesc = CFmtStr( "%c%s", iKillerHasPetItem == 2 ? kHorriblePyroVisionHack_KillAssisterType_LocalizationString_First : kHorriblePyroVisionHack_KillAssisterType_LocalizationString, pEconItemView->GetItemDefinition()->GetItemBaseName() ).Get();
			}
			break;
		}
	}

	IGameEvent * event = gameeventmanager->CreateEvent( eventName );

	if ( event )
	{
		event->SetInt( "userid", pVictim->GetUserID() );
		event->SetInt( "victim_entindex", pVictim->entindex() );
		event->SetInt( "attacker", killer_ID );
		event->SetInt( "assister", pAssister ? pAssister->GetUserID() : -1 );
		event->SetString( "weapon", killer_weapon_name );
		event->SetString( "weapon_logclassname", killer_weapon_log_name );
		event->SetInt( "weaponid", iWeaponID );
		event->SetInt( "damagebits", info.GetDamageType() );
		event->SetInt( "customkill", info.GetDamageCustom() );
		event->SetInt( "inflictor_entindex", pInflictor ? pInflictor->entindex() : -1 );
		event->SetInt( "priority", 7 );	// HLTV event priority, not transmitted

		if ( info.GetPlayerPenetrationCount() > 0 )
		{
			event->SetInt( "playerpenetratecount", info.GetPlayerPenetrationCount() );
		}

		if ( !sAssisterOverrideDesc.IsEmpty() )
		{
			event->SetString( "assister_fallback", sAssisterOverrideDesc.Get() );
		}

		event->SetBool( "silent_kill", bSilentKill );

		int iDeathFlags = pTFPlayerVictim->GetDeathFlags();

		if ( bKillWasFirstBlood )
		{
			iDeathFlags |= TF_DEATH_FIRST_BLOOD;
		}

		if ( bFeignDeath )
		{
			iDeathFlags |= TF_DEATH_FEIGN_DEATH;
		}

		if ( pTFPlayerVictim->WasGibbedOnLastDeath() )
		{
			iDeathFlags |= TF_DEATH_GIBBED;
		}

		if ( pTFPlayerVictim->IsInPurgatory() )
		{
			iDeathFlags |= TF_DEATH_PURGATORY;
		}

		if ( pTFPlayerVictim->IsMiniBoss() )
		{
			iDeathFlags |= TF_DEATH_MINIBOSS;
		}

		// Australium Guns get a Gold Background
		IHasAttributes *pAttribInterface = GetAttribInterface( info.GetWeapon() );
		if ( pAttribInterface )
		{
			int iIsAustralium = 0;
			CALL_ATTRIB_HOOK_INT_ON_OTHER( info.GetWeapon(), iIsAustralium, is_australium_item );
			if ( iIsAustralium )
			{
				iDeathFlags |= TF_DEATH_AUSTRALIUM;
			}

			int iIsGoldenWeapon = 0;
			CALL_ATTRIB_HOOK_INT_ON_OTHER( info.GetWeapon(), iIsGoldenWeapon, set_turn_to_gold );
			if ( iIsGoldenWeapon )
			{
				iDeathFlags |= TF_DEATH_AUSTRALIUM;
			}
		}

		// We call this directly since we need more information than provided in the event alone.
		if ( FStrEq( eventName, "player_death" ) )
		{
			CTF_GameStats.Event_KillDetail( pScorer, pTFPlayerVictim, pAssister, event, info );
			event->SetInt( "kill_streak_victim", pTFPlayerVictim->m_Shared.GetStreak( CTFPlayerShared::kTFStreak_Kills ) );
			event->SetBool( "rocket_jump", ( pTFPlayerVictim->RocketJumped() == 1 ) );
			event->SetInt( "crit_type", info.GetCritType() );

			// Kill streak updating
			if ( pTFPlayerVictim && pScorer && pTFPlayerVictim != pScorer )
			{
				// Propagate duckstreaks
				event->SetInt( "duck_streak_victim", pTFPlayerVictim->m_Shared.GetStreak( CTFPlayerShared::kTFStreak_Ducks ) );
				event->SetInt( "duck_streak_total", pScorer->m_Shared.GetStreak( CTFPlayerShared::kTFStreak_Ducks ) );
				event->SetInt( "ducks_streaked", pScorer->m_Shared.GetLastDuckStreakIncrement() );

				// Check if they have the appropriate attribute.
				int iKillStreak = 0;
				int iKills = 0;
				CBaseEntity *pKillStreakTarget = NULL;
				if ( !pAttribInterface )
				{
					// Check if you are a sentry and if so, use the wrench
					// For Sentries Inflictor can be the sentry (bullets) or the Sentry Rocket

					CObjectSentrygun *pSentry = dynamic_cast<CObjectSentrygun*>( pInflictor );
					if ( !pSentry && pInflictor )
					{
						pSentry = dynamic_cast<CObjectSentrygun*>( pInflictor->GetOwnerEntity() );
					}

					if ( pSentry )
					{
						pKillStreakTarget = dynamic_cast<CTFWeaponBase*>( pScorer->GetEntityForLoadoutSlot( LOADOUT_POSITION_MELEE ) );
					}
				}
				else
				{
					pKillStreakTarget = info.GetWeapon();
				}

				if ( pKillStreakTarget )
				{
					CALL_ATTRIB_HOOK_INT_ON_OTHER( pKillStreakTarget, iKillStreak, killstreak_tier );
					// Always track killstreak regardless of the attribute for data collection purposes
					pScorer->m_Shared.IncrementStreak( CTFPlayerShared::kTFStreak_KillsAll, 1 );
					if ( iKillStreak )
					{
						iKills = pScorer->m_Shared.IncrementStreak( CTFPlayerShared::kTFStreak_Kills, 1 );
						event->SetInt( "kill_streak_total", iKills );

						int iWepKills = 0;
						CTFWeaponBase *pWeapon = dynamic_cast<CTFWeaponBase*>( pKillStreakTarget );
						if ( pWeapon )
						{
							iWepKills = pWeapon->GetKillStreak() + 1;
							pWeapon->SetKillStreak( iWepKills );
						}
						else
						{
							CTFWearable *pWearable = dynamic_cast<CTFWearable*>( pKillStreakTarget );
							if ( pWearable )
							{
								iWepKills = pWearable->GetKillStreak() + 1;
								pWearable->SetKillStreak( iWepKills );
							}
						}

						event->SetInt( "kill_streak_wep", iWepKills );

						// Track each player's max streak per-round
						CTF_GameStats.Event_PlayerEarnedKillStreak( pScorer );
					}
				}

				if ( pAssister )
				{
					event->SetInt( "duck_streak_assist", pAssister->m_Shared.GetStreak( CTFPlayerShared::kTFStreak_Ducks ) );

					// Only allow assists for Mediguns
					CTFWeaponBase *pAssisterWpn = pAssister->GetActiveWeapon();
					if ( pAssisterWpn && pAssister->IsPlayerClass( TF_CLASS_MEDIC ) )
					{
						CWeaponMedigun *pMedigun = dynamic_cast<CWeaponMedigun*>( pAssisterWpn );
						if ( pMedigun )
						{
							iKillStreak = 0;
							CALL_ATTRIB_HOOK_INT_ON_OTHER( pAssisterWpn, iKillStreak, killstreak_tier );
							if ( iKillStreak )
							{
								iKills = pAssister->m_Shared.IncrementStreak( CTFPlayerShared::kTFStreak_Kills, 1 );
								event->SetInt( "kill_streak_assist", iKills );

								int iWepKills = pAssisterWpn->GetKillStreak() + 1;
								pAssisterWpn->SetKillStreak( iWepKills );

								// Track each player's max streak per-round
								CTF_GameStats.Event_PlayerEarnedKillStreak( pAssister );
							}
						}
					}
				}
			}
		}

		event->SetInt( "death_flags", iDeathFlags );	
		event->SetInt( "stun_flags", pTFPlayerVictim->m_iOldStunFlags );

		item_definition_index_t weaponDefIndex = INVALID_ITEM_DEF_INDEX;
		if ( pScorerWeapon )
		{
			CEconItemView *pItem = pScorerWeapon->GetAttributeContainer()->GetItem();
			if ( pItem )
			{
				weaponDefIndex = pItem->GetItemDefIndex();
			}
		}
		else if ( pScorer && pScorer->GetActiveWeapon() )
		{
			// get from active weapon instead
			CEconItemView *pItem = pScorer->GetActiveWeapon()->GetAttributeContainer()->GetItem();
			if ( pItem )
			{
				weaponDefIndex = pItem->GetItemDefIndex();
			}
		}
		event->SetInt( "weapon_def_index", weaponDefIndex );

		pTFPlayerVictim->m_iOldStunFlags = 0;

		gameeventmanager->FireEvent( event );
	}	
} */

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
		if (GetIntCvar("mp_friendlyfire", 0) == 0 && (pAttacker != pPlayer))
		{
			// friendly fire is off, and this hit came from someone other than myself,  then don't get hurt
			return false
		}
	}

	return true
}

function ROOT::HasSpawnFlags( entity, flag )
	return Math.BitWise(GetPropInt(entity, "m_spawnflags"), flag)

function GetIntCvar( cvar, def )
{
	if (!IsCvarAllowed(cvar))
		return def
	return GetCvarInt(cvar)
}

function GetBoolCvar( cvar, def )
{
	if (!IsCvarAllowed(cvar))
		return def
	return GetCvarBool(cvar)
}

function GetFloatCvar( cvar, def )
{
	if (!IsCvarAllowed(cvar))
		return def
	return GetCvarFloat(cvar)
}

/** 
 * @type {function}
 * @param {CBaseEntity} pEntity
 */
function CTFPlayer::InSameTeam( pEntity )
{
	if ( !pEntity )
		return false

	return ( pEntity.GetTeam() == GetTeam() )
}

/**
 * Description
 * @param {CTakeDamageInfo} info
 * @returns {integer}
 */
function CTFPlayer::OnTakeDamage_Alive( info )
{
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
	local iPreFeignDamage = realDamage
	realDamage = ApplyOnDamageAliveModifyRules( info, this, outParams )

	if ( realDamage == -1 )
	{
		// Hard out requested from ApplyOnDamageModifyRules 
		return 0
	}

	if ( outParams.bPlayDamageReductionSound )
	{
		PlayDamageResistSound( info.GetDamage(), realDamage )
	}

	// Grab the vector of the incoming attack. 
	// (Pretend that the inflictor is a little lower than it really is, so the body will tend to fly upward a bit).
	local vecDir = Vector()
	if ( info.GetInflictor() )
	{
		vecDir = info.GetInflictor().GetCenter() - Vector ( 0.0, 0.0, 10.0 ) - GetCenter()
		if (info.GetInflictor().GetClassname() == "tf_projectile_arrow")
		{
			vecDir = info.GetDamagePosition() - info.GetDamageForce() - GetCenter()
		}
		vecDir.Normalize()
	}
	// g_vecAttackDir = vecDir // werid global

	// Do the damage.
	SetPropFloat( this, "m_bitsDamageType", GetPropFloat( this, "m_bitsDamageType" ) | info.GetDamageType() )

	// Check to see if the Wheatley sapper item is equipped and should react
	if ( GetPropFloat( this, "m_bitsDamageType" ) & DMG_BULLET && IsPlayerClass( TF_CLASS_SPY ) )
	{
		// VScript could fake this, but, not important 

		// CBaseCombatWeapon *pRet = GetActiveWeapon()
		// CTFWeaponSapper *pSap = dynamic_cast< CTFWeaponSapper* >( pRet )
		// if ( pSap != null )
		// {
		// 	if (pSap->IsWheatleySapper())
		// 	{
		// 		pSap->WheatleyDamage()
		// 	}
		// }
	}

	local flBleedingTime = 0.0
	local iPrevHealth = GetHealth()

	if ( CanTakeDamage(this) != DAMAGE_EVENTS_ONLY )
	{
		if ( info.GetDamageCustom() != TF_DMG_CUSTOM_BLEEDING && !outParams.bSelfBlastDmg )
		{
			flBleedingTime = CALL_ATTRIB_HOOK_FLOAT_ON_OTHER( info.GetWeapon(), "bleeding duration", 0.0 )
		}

		// Take damage - round to the nearest integer.
		local iOldHealth = GetHealth()
		SetHealth( GetHealth() - ( realDamage + 0.5 ).tointeger() )

		if ( IsHeadshot( info.GetDamageCustom() ) && ( GetHealth() <= 0 ) && ( iOldHealth != 1 ) )
		{
			local iNoDeathFromHeadshots = CALL_ATTRIB_HOOK_INT_ON_OTHER( this, "SET BONUS: no death from headshots" )
			if ( iNoDeathFromHeadshots == 1 )
			{
				SetHealth(1)
			}
		}

		// For lifeleech, calculate how much damage we actually inflicted.
		if ( pTFAttacker && pTFAttacker.GetActiveWeapon() )
		{
			local fLifeleechOnDamage = CALL_ATTRIB_HOOK_FLOAT_ON_OTHER( pTFAttacker.GetActiveWeapon(), "lifeleach on damage" ) // unknown attribute
			if ( fLifeleechOnDamage > 0.0 )
			{
				local fActualDamageDealt = iOldHealth - GetHealth()
				local fHealAmount = fActualDamageDealt * fLifeleechOnDamage

				if ( fHealAmount >= 0.5 )
				{
					local iHealthToAdd = MATH.Min( (fHealAmount + 0.5).tointeger(), pTFAttacker.GetMaxHealth() - pTFAttacker.GetHealth() )
					pTFAttacker.HealPlayer( iHealthToAdd )
				}
			}
		}

		// track accumulated sentry gun damage dealt by players
		if ( pTFAttacker )
		{
			local sentry = IsSentry( info.GetInflictor() )
			local sentryRocket = IsSentryRocket( info.GetInflictor() )
			// track amount of damage dealt by defender's sentry guns

			if ( ( sentry && !IsDisposableBuilding( sentry ) ) || sentryRocket )
			{
				// local flooredHealth = MATH.clamp( GetHealth(), 0, GetHealth() )

				// Cant do in VScript
				// pTFAttacker->AccumulateSentryGunDamageDealt( iOldHealth - flooredHealth )
			}
		}
	}

	SetPropFloat(this, "m_flLastDamageTime", Time()) // not networked
	if ( IsMannVsMachineMode() )
	{
		// We only need damage time networked while in MvM
		SetPropFloat(this, "m_flMvMLastDamageTime", Time())
	}

	// Apply a damage force.
	local pAttacker = info.GetAttacker()
	if ( !pAttacker )
		return 0

	if ( ( info.GetDamageType() & DMG_PREVENT_PHYSICS_FORCE ) == 0 )
	{
		if ( info.GetInflictor() && ( GetMoveType() == MOVETYPE_WALK ) && 
		   ( !pAttacker.IsSolidFlagSet( FSOLID_TRIGGER ) ) && 
		   ( !InCond( TF_COND_DISGUISED ) ) )	
		{
			if ( !IsImmuneToPushback() || outParams.bSelfBlastDmg )
			{
				// ApplyPushFromDamage( info, vecDir ) // TODO:
			}
		}
	}

	if ( outParams.bIgniting && pTFAttacker )
	{
		// Cant do in VScript
		// Burn( pTFAttacker, info.GetWeapon() )
	}

	if ( flBleedingTime > 0 && pTFAttacker )
	{
		// Cant do in VScript
		// MakeBleed( pTFAttacker, info.GetWeapon(), flBleedingTime )
	}

	// Don't recieve reflected damage if you are carrying Reflect (prevents a loop in a game with two Reflect players)
	if ( ( info.GetDamageCustom() == TF_DMG_CUSTOM_RUNE_REFLECT ) && GetCurrentRune() == RUNE_REFLECT )
	{
		return 0
	}

	local pTFWeapon = info.GetWeapon()
	if ( pTFWeapon )
	{
		if ( pTFWeapon.IsSniperRifle() )
		{
			if ( pTFWeapon && ( pTFWeapon.GetOwner() && pTFWeapon.GetOwner().InCond( TF_COND_ZOMMED ) || ( pTFWeapon.GetIDX() == 1098 ) ) )
			{
				local flJarateTime = 0.0

				local flMaxJarateTime = CALL_ATTRIB_HOOK_FLOAT_ON_OTHER( pTFWeapon, "jarate duration", 0.0 )
				if ( flMaxJarateTime > 0.0 )
					flJarateTime = MATH.RemapValClamped( GetPropFloat( pTFWeapon, "SniperRifleLocalData.m_flChargedDamage" ), TF_WEAPON_SNIPERRIFLE_DAMAGE_MIN, TF_WEAPON_SNIPERRIFLE_DAMAGE_MATH.Max, 2.0, flMaxJarateTime )

				if ( flJarateTime >= 1.0 )
				{
					if ( !IsInvulnerable() && !InCond(TF_COND_PHASE) && !InCond(TF_COND_PASSTIME_INTERCEPTION))
					{
						local vecOrigin = info.GetDamagePosition()
						CreateParticle("peejar_impact_small", vecOrigin)
						AddCondEx(TF_COND_URINE, flJarateTime, pTFWeapon.GetOwner())

						if ( pTFAttacker )
						{
							/* UTIL_LogPrintf("\"%s<%i><%s><%s>\" triggered \"%s\" against \"%s<%i><%s><%s>\" with \"%s\" (attacker_position \"%d %d %d\") (victim_position \"%d %d %d\")\n",
								pTFAttacker.GetUserName(),
								pTFAttacker.GetUserID(),
								pTFAttacker.GetSteamID(),
								pTFAttacker.GetTeam() == TF_TEAM_RED ? "Red" : "Blu",
								"jarate_attack",
								GetUserName(),
								GetUserID(),
								GetSteamID(),
								GetTeam() == TF_TEAM_RED ? "Red" : "Blu",
								"sniperrifle",
								pTFAttacker.GetAbsOrigin().x.tointeger(),
								pTFAttacker.GetAbsOrigin().y.tointeger(),
								pTFAttacker.GetAbsOrigin().z.tointeger(),
								GetAbsOrigin().x.tointeger(),
								GetAbsOrigin().y.tointeger(),
								GetAbsOrigin().z.tointeger()) */

							if ( IsHeadshot( info.GetDamageCustom() ) || LastHitGroup() == HITGROUP_HEAD )
							{
								local secondary = pTFAttacker.GetWeaponInSlotNew(SLOT_SECONDARY)
								local ammo_type = GetPropInt( secondary, "LocalWeaponData.m_iPrimaryAmmoType" )
								if ( secondary && ammo_type > TF_AMMO_METAL )
								{
									local max = ammo_type == TF_AMMO_GRENADES1 ? pTFAttacker.GetMaximumGrenades1() : pTFAttacker.GetMaximumGrenades3()
									if ( pTFAttacker.GetAmmoByIndex(ammo_type) < max && secondary.GetChargeProgress() < 1.0)
									{
										SetPropFloat( secondary, "m_flEffectBarRegenTime", GetPropFloat( secondary, "m_flEffectBarRegenTime" ) - 1 )
									}
								}
							}
						}
					}
				}

				if ( bUsingUpgrades && pTFAttacker && ( IsHeadshot( info.GetDamageCustom() ) || ( flJarateTime && LastHitGroup() == HITGROUP_HEAD ) ) )
				{
					local iExplosiveShot = CALL_ATTRIB_HOOK_INT_ON_OTHER( pTFAttacker, "explosive sniper shot" )
					if ( iExplosiveShot )
					{
						// pSniper->ExplosiveHeadShot(pTFAttacker, this) // TODO: remake
					}
				}
			}
		}

		if ( pTFWeapon.IsKnife() )
		{
			local pKnife = pTFWeapon
			if ( pKnife && bUsingUpgrades && pTFAttacker && info.GetDamageCustom() == TF_DMG_CUSTOM_BACKSTAB && ! ( info.GetDamageType() & DMG_BLAST) )
			{
				local iExplosiveStab = CALL_ATTRIB_HOOK_INT_ON_OTHER( pTFAttacker, "explosive backstab" )
				if ( iExplosiveStab )
				{
					CreateKnifeAoE({
						owner = pTFAttacker
						weapon = pKnife
						radius = 250
						damage = MATH.Max(512, realDamage)
						center = GetCenter()
						ignore = [this]
						SoundRadius = 1500
						/**
						 * @param {CTFPlayer|CTFBot|CBaseEntity} player
						 */
						function func( player ) {
							if (!player || !player.IsValid() || !player.IsPlayer())
								return
							player.StunPlayer(MATH.Clamp(iExplosiveBackstab - 1, 0, 2), 0.6, TF_STUN_MOVEMENT, attacker )
						}
					})
				}
			}
		}
	}

	// Prevents a sandwich ignore-ammo-while-taking-damage-and-eating alias exploit
	if ( InCond( TF_COND_TAUNTING ) && GetPropInt(this, "m_Shared.m_iTauntIndex") == 0 )
	{
		if ( IsPlayerClass( TF_CLASS_HEAVYWEAPONS ) )
		{
			local pLunchBox = GetActiveWeapon()
			if ( pLunchBox )
			{
				local mode = pLunchBox.GetAttribute("lunchbox adds minicrits", 0)
				if ( ( mode != lunchbox_weapontypes_t.LUNCHBOX_CHOCOLATE_BAR ) && ( mode != lunchbox_weapontypes_t.LUNCHBOX_FISHCAKE ) )
				{
					local type = GetPropInt( pLunchBox, "LocalWeaponData.m_iPrimaryAmmoType" )
					SetAmmoByIndex(type, GetAmmoByIndex(type) - 1) // not the best, but ehh
				}
			}
		}
	}

	local event = {}

	event.userid <- GetUserID()
	event.health <- MATH.MATH.Max( 0, GetHealth() )

	// HLTV event priority, not transmitted
	event.priority <- 5

	event.damageamount <- outParams.bSendPreFeignDamage ? iPreFeignDamage : ( iPrevHealth - GetHealth() )

	// Hurt by another player.
	if ( pAttacker.IsPlayer() )
	{
		event.attacker <- pAttacker.GetUserID()
		event.custom <- info.GetDamageCustom()
		event.showdisguisedcrit <- GetPropBool(this, "m_bShowDisguisedCrit")
		event.crit <- (info.GetDamageType() & DMG_CRITICAL) != 0
		event.minicrit <- GetPropBool(this, "m_bMiniCrit")
		event.allseecrit <- GetPropBool(this, "m_bAllSeeCrit")
		event.bonuseffect <- GetPropBool(this, "m_eBonusAttackEffect")
	}
	// Hurt by world.
	else
	{
		event.attacker <- 0
	}

	SendGlobalGameEvent("player_hurt", event)

	
	if ( pTFAttacker && pTFAttacker != this )
	{
		// kinda pointless for now
		// pTFAttacker->RecordDamageEvent( info, (m_iHealth <= 0), iPrevHealth )
	}

	//No bleeding while invul or disguised.
	/**
	 * @type {integer}
	 */
	local bBleed = ( ( InCond( TF_COND_DISGUISED ) == false || GetDisguiseTeam() != pAttacker.GetTeam() ) && !IsInvulnerable() )

	// No bleed effects for DMG_GENERIC
	if ( info.GetDamageType() == DMG_GENERIC )
	{
		bBleed = 0
	}
										   
	// Except if we are really bleeding!
	bBleed = bBleed | InCond( TF_COND_BLEEDING ).tointeger()
	
	if ( bBleed && pTFAttacker )
	{

		local pWeapon = pTFAttacker.GetActiveWeapon()
		if ( pWeapon && pWeapon.IsFlamethrower())
		{
			bBleed = 0
		}
	}

	if ( bBleed && ( realDamage > 0.0 ) )
	{
		local vDamagePos = info.GetDamagePosition()

		if ( vDamagePos == Vector() )
		{
			vDamagePos = GetCenter()
		}

		if ( IsMannVsMachineMode() && GetTeam() == TF_TEAM_PVE_INVADERS )
		{
			if ( ( IsMiniBoss() && GetHealth().tofloat() / GetMaxHealth() > 0.3 ) || realDamage < 50 )
			{
				DispatchParticleEffect( "bot_impact_light", GetOrigin(), Vector() )
			}
			else
			{
				DispatchParticleEffect( "bot_impact_heavy", GetOrigin(), Vector() )
			}
		}
		else
		{
			// cant do this
			/* CPVSFilter filter( vDamagePos )
			TE_TFBlood( filter, 0.0, vDamagePos, -vecDir, entindex() ) */
		}
	}

	if ( GetPropBool(this, "m_bIsTargetDummy") )
	{
		// In the case of a targetdummy bot, restore any damage so it can never die
		HealPlayer( iPrevHealth - GetHealth(), false, false, false)
	}

	SetPropVector(this, "m_vecFeignDeathVelocity", GetAbsVelocity())

	if ( pTFAttacker )
	{
		// If we're invuln, give whomever provided it rewards/credit
		if ( IsInvulnerable() && realDamage > 0.0 )
		{
			// cant get Cond Providers yet
			// // Medigun?
			// pProvider = m_Shared.GetConditionProvider( TF_COND_INVULNERABLE )
			// if ( !pProvider && bUsingUpgrades )
			// {
			// 	// Bottle?
			// 	pProvider = m_Shared.GetConditionProvider( TF_COND_INVULNERABLE_USER_BUFF )
			// }

			// if ( pProvider )
			// {
			// 	CTFPlayer *pTFProvider = ToTFPlayer( pProvider )
			// 	if ( pTFProvider )
			// 	{
			// 		if ( pTFProvider != pTFAttacker && bUsingUpgrades )
			// 		{
			// 			HandleRageGain( pTFProvider, kRageBuffFlag_OnHeal, ( realDamage / 2.0 ), 1.0 )
			// 		}

			// 		CTF_GameStats.Event_PlayerBlockedDamage( pTFProvider, realDamage )
			// 	}
			// }
		}


		// same as above
		// Give the attacker's medic Energy based on damage done
		// pProvider = pTFAttacker->m_Shared.GetConditionProvider( TF_COND_HEALTH_BUFF )
		// if ( pProvider )
		// {
		// 	CTFPlayer *pTFProvider = ToTFPlayer( pProvider )
		// 	if ( pTFProvider && pTFProvider->IsPlayerClass( TF_CLASS_MEDIC ) )
		// 	{
		// 		// Cap to prevent insane values coming from headshots and backstabs
		// 		float flAmount = Min( realDamage, 250.0 ) / 10.0
		// 		HandleRageGain( ToTFPlayer( pProvider ), kRageBuffFlag_OnHeal, flAmount, 1.0 )
		// 	}
		// }
	}

	// Done.
	return 1
}

/**
 * @param {CTakeDamageInfo} info
 */
function CTFPlayer::TakeCustomDamage( info )
{
	TakeDamageCustom(info.GetInflictor(), info.GetAttacker(), info.GetWeapon(), info.GetDamageForce(), info.GetDamagePosition(), info.GetDamage(), info.GetDamageType(), info.GetDamageCustom())
}

function CTFPlayer::GetInternalVar( var_name, def = 0 )
{
	if (!("Internal_Vars" in GetScope(this)))
		GetScope(this).Internal_Vars <- {}
	if (!(var_name in GetScope(this).Internal_Vars))
		GetScope(this).Internal_Vars[var_name] <- def

	return GetScope(this).Internal_Vars[var_name]
}

function CTFPlayer::SetInternalVar( var_name, value )
{
	GetInternalVar(var_name) // cheeky to fix it up so its not missing
	GetScope(this).Internal_Vars[var_name] <- value
}

function CTFPlayer::SetBlastJumpState( iState, bPlaySound = false )
{
	SetInternalVar("m_iBlastJumpState", GetInternalVar("GetInternalVar") | iState)

	local pszEvent = null
	if ( iState == TF_PLAYER_STICKY_JUMPED )
		pszEvent = "sticky_jump"
	else if ( iState == TF_PLAYER_ROCKET_JUMPED )
		pszEvent = "rocket_jump"

	if ( pszEvent )
	{
		SendGlobalGameEvent( pszEvent, {
			userid = GetUserID()
			playsound = bPlaySound
		} )
	}

	AddCondEx( TF_COND_BLASTJUMPING, -1, this )
}

//-----------------------------------------------------------------------------
// Purpose: The player appears to die, creating a corpse and silently stealthing.
//			Occurs when a player takes damage with the dead ringer active
//-----------------------------------------------------------------------------
/** 
 * @param {CTakeDamageInfo} info
 */
function CTFPlayer::SpyDeadRingerDeath( info )
{
	// Can't feign death if we're actually dead or if we're not a spy.
	if ( !IsAlive() || !IsPlayerClass( TF_CLASS_SPY ) )
		return

	// Can't feign death if we're already stealthed.
	if ( InCond( TF_COND_STEALTHED ) )
		return

	// Can't feign death if we aren't at full cloak energy.
	if ( !CanGoInvisible( true ) || ( GetSpyCloakMeter() < 100.0 ) )
		return

	SetSpyCloakMeter( 50.0 )

	SetInternalVar("m_bGoingFeignDeath", true)

	FeignDeath( info, true )

	// Go feign death.
	AddCondEx( TF_COND_FEIGN_DEATH, GetFloatCvar("tf_feign_death_duration", 3.0), this)
	SetInternalVar("m_bGoingFeignDeath", false)
}

function CTFPlayer::GetDisguiseClass() 
	return InCond( TF_COND_DISGUISED_AS_DISPENSER ) ? TF_CLASS_ENGINEER : GetPropInt(this, "m_Shared.m_nDisguiseClass")

/** 
 * @param {CTakeDamageInfo} info
 * @param {bool} bEmpty
 */
function CTFPlayer::DropHealthPack( info, bEmpty )
{
	local pMedKit = SpawnEntityFromTable("item_healthkit_small", {})
	if ( pMedKit )
	{
		pMedKit.SetOwner(this)
		pMedKit.SetAbsOrigin(GetCenter())

		local vecImpulse = MATH.RandomVec( -1, 1 )
		vecImpulse.z = 1;
		vecImpulse.Normalize()

		local vecVelocity = vecImpulse * 250.0
		SetAbsVelocity(vecVelocity)
	}
}

//-----------------------------------------------------------------------------
// Purpose: The player appears to die, creating a corpse
//-----------------------------------------------------------------------------
/** 
 * @param {CTakeDamageInfo} info
 * @param {bool} bDeathnotice
 */
function CTFPlayer::FeignDeath( info, bDeathnotice )
{
	if ( GetPropEntity(this, "m_Shared.m_hItem") )
		DropFlag(false)

	// Dead Ringer death removes Powerup Rune for authenticity
	DropRune(false, GetTeam() == TF_TEAM_RED ? TF_TEAM_BLUE : TF_TEAM_RED)

	// Only drop disguised ragdoll & weapon if we're disguised as a teammate.
	local bDisguised = InCond( TF_COND_DISGUISED ) && (GetDisguiseTeam() == GetTeam())

	// We want the ragdoll to burn if the player was burning and was not disguised as a pyro.
	local bBurning = InCond( TF_COND_BURNING ) && (!bDisguised || (TF_CLASS_PYRO != GetDisguiseClass()))

	// Stop us from burning and other effects that would give the game away.
	RemoveCond( TF_COND_BURNING )
	RemoveCond( TF_COND_BLEEDING )
	RemoveTeleportEffect()

	// Fake death audio.
	EmitSound( "BaseCombatCharacter.StopWeaponSounds" )
	EntFireNew( this, "SpeakResponseConcept", "TLK_DIED" )
	// DeathSound( info ) // TODO

	// Check if we should create gibs.
	local bGib = ShouldGib( info )

	SetInternalVar( "m_bGibbedOnLastDeath", bGib )

	if ( bDeathnotice )
	{
		// Fake death notice.
		// DeathNotice( this, info ) //TODO
	}

	// Drop an empty ammo pack!
	if ( ShouldDropAmmoPack() )
		DropAmmoPack( info, true /*Empty*/, bDisguised );

	if ( IsInMedievalMode() )
		DropHealthPack( info, true )

	if ( GetActiveWeapon() )
	{
		local iDropHealthOnKill = CALL_ATTRIB_HOOK_INT_ON_OTHER( GetActiveWeapon(), "drop health pack on kill" )
		if ( iDropHealthOnKill > 0 )
			DropHealthPack( info, true )
	}

	local pTFPlayer = ToTFPlayer( info.GetAttacker() )
	if ( pTFPlayer )
	{
		local iKillForcesAttackerToLaugh = CALL_ATTRIB_HOOK_FLOAT_ON_OTHER( pTFPlayer, "kill forces attacker to laugh")
		if ( iKillForcesAttackerToLaugh == 1 )
		{
			// force the attacker to laugh!
			pTFPlayer.Taunt( 1, 92 )
		}

		local pWpn = GetWeaponClassname("tf_weapon_invis")
		if ( pWpn && pWpn.GetAttribute("set cloak is feign death", 0) == 1 )
		{
			// DropDeathCallingCard( pTFPlayer, this ) // TODO
		}

		// Check for Halloween Death Ghosts
		// pTFPlayer->CheckSpellHalloweenDeathGhosts( info, this ) // TODO
	}

	// Create a ragdoll.
	// CreateFeignDeathRagdoll( info, bGib, bBurning, bDisguised ); // TODO

	// No Stats
	// Note that we succeeded for stats tracking.
	/* EconEntity_OnOwnerKillEaterEvent( dynamic_cast<CEconEntity *>( GetEntityForLoadoutSlot( LOADOUT_POSITION_PDA2 ) ),
									  this,
									  pTFPlayer,			// in this case the "victim" is the person doing the damage
									  kKillEaterEvent_DeathsFeigned ); */
}

/** 
 * @type {function}
 * @param {CTakeDamageInfo} inputInfo
 * @returns {integer}
 */
function CTFPlayer::OnTakeDamage( inputInfo )
{
	GetInternalVar("___ignore___")
	local info = inputInfo

	/** @type {bool} */
	local bIsObject = info.GetInflictor() && IsBaseObject(info.GetInflictor())

	// need to check this now, before dying
	local bHadBallBeforeDamage = false
	if ( IsPasstimeMode() )
	{
		bHadBallBeforeDamage = HasPasstimeBall()
	}

	// damage may not come from a weapon (ie: Bosses, etc)
	// The existing code below already checked for null pWeapon, anyways
	local pWeapon = ToBaseWeapon( inputInfo.GetWeapon() )

	if ( GetFlags() & FL_GODMODE )
		return 0

	if ( IsInCommentaryMode() )
		return 0

	local bBuddha = ( GetPropInt(this, "m_debugOverlays") & OVERLAY_BUDDHA_MODE ) ? true : false

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

	/** @type {CBaseEntity|null} */
	local pInflictor = info.GetInflictor()
	/** @type {CBaseEntity|null} */
	local pAttacker = info.GetAttacker()
	/** @type {CTFPlayer|null} */
	local pTFAttacker = ToTFPlayer( pAttacker )

	local bDebug = GetBoolCvar("tf_debug_damage", false)

	// If attacker has Strength Powerup Rune, apply damage multiplier, but not if you're a building or a crit
	local bCrit = ( info.GetDamageType() & DMG_CRITICAL ) > 0
	if ( !bIsObject && pTFAttacker && pTFAttacker.GetCurrentRune() == RUNE_STRENGTH && !bCrit )
	{
		if ( pTFAttacker.InCond( TF_COND_POWERUPMODE_DOMINANT ) ) 
		{
			info.ScaleDamage( 1.4 )
		}
		else
		{
			info.ScaleDamage( 2.0 )
		}
	}

	// Make sure the player can take damage from the attacking entity
	if ( !FPlayerCanTakeDamage( this, pAttacker, info ) )
	{
		if ( bDebug )
		{
			Warning( "    ABORTED: Player can't take damage from that attacker.\n" )
		}

		return 0
	}

	if ( IsBot() )
	{
		// Don't let Sentry Busters die until they've done their spin-up
		if ( IsMannVsMachineMode() )
		{
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
						 InSameTeam( pTFAttackerBot ) &&
						 IsMiniBoss() )
					{
						info.SetDamage( 600.0 )
					}
				}
			}
		}
	}

	// Halloween 2011
	if ( IsInPurgatory() )
	{
		info.SetDamage( GetInternalVar("m_purgatoryPainMultiplier", 1.0) * info.GetDamage() )
	}

	SetInternalVar("m_iHealthBefore", GetHealth())

	/** @type {bool} */
	local bIsSoldierRocketJumping = ( IsPlayerClass( TF_CLASS_SOLDIER ) && (pAttacker == this) && !(GetFlags() & FL_ONGROUND) && !(GetFlags() & FL_INWATER)) && (inputInfo.GetDamageType() & DMG_BLAST)
	/** @type {bool} */
	local bIsDemomanPipeJumping = ( IsPlayerClass( TF_CLASS_DEMOMAN) && (pAttacker == this) && !(GetFlags() & FL_ONGROUND) && !(GetFlags() & FL_INWATER)) && (inputInfo.GetDamageType() & DMG_BLAST)
	
	if ( bDebug )
	{
		Warning( "%s taking damage from %s, via %s. Damage: %.2f\n", tostring(), info.GetInflictor() ? info.GetInflictor().tostring() : "Unknown Inflictor", pAttacker ? pAttacker.tostring() : "Unknown Attacker", info.GetDamage() )
	}

	if ( pTFAttacker )
	{
		pTFAttacker.SetInternalVar("m_flLastDamageDoneTime", Time())
		pTFAttacker.SetInternalVar("m_hLastDamageDoneEntity", this)

		local myWeapon = GetActiveWeapon()
		local attackerWeapon = pTFAttacker.GetActiveWeapon()
		
		if ( myWeapon && attackerWeapon )
		{
			local iStunEnemyWithSameWeapon = CALL_ATTRIB_HOOK_INT_ON_OTHER( attackerWeapon, "stun enemies wielding same weapon" )
			if ( iStunEnemyWithSameWeapon )
			{
				if ( myWeapon && attackerWeapon && myWeapon.GetIDX() == attackerWeapon.GetIDX() )
				{
					StunPlayer( 1.0, 1.0, TF_STUN_BOTH | TF_STUN_NO_EFFECTS, pTFAttacker)
				}
			}
		}
	}

	if ( ( info.GetDamageType() & DMG_FALL ) && info.GetDamageCustom() != TF_DMG_CUSTOM_BOOTS_STOMP )
	{
		local flOriginalVelocity = GetPropFloat(this, "m_Local.m_flFallVelocity")

		local bHitEnemy = false

		// Are we transferring falling damage to someone else?
		if ( GetGroundEntity() && GetGroundEntity().IsPlayer() && CanStomp() )
		{
			// Did we land on a guy from the enemy team?
			/**@type {CTFPlayer|null} */
			local pOther = ToTFPlayer( GetGroundEntity() )
			if ( pOther && pOther.GetTeam() != GetTeam() )
			{
				local flStompDamage = 10.0 + info.GetDamage() * 3.0

				/** @type {CTakeDamageInfo} */
				local infoInner = CTakeDamageInfo(this, this, GetWeaponInSlotNew(SLOT_SECONDARY), Vector(), Vector(), Vector(), flStompDamage, DMG_FALL, TF_DMG_CUSTOM_BOOTS_STOMP)
				pOther.TakeCustomDamage(infoInner)
				SetPropFloat(this, "m_Local.m_flFallVelocity", 0)
				info.SetDamage( 0.0 )
				EmitSound( "Weapon_Mantreads.Impact" )
				EmitSound( "Player.FallDamageDealt" )
				ScreenShake(pOther.GetCenter(), 15.0, 150.0, 1.0, 500.0, 0, false)

				bHitEnemy = true
			}
		}

		// Apply an impact effect (intensity determined by velocity)
		if ( InCond( TF_COND_ROCKETPACK ) )
		{
			local iImpactPushback = CALL_ATTRIB_HOOK_INT_ON_OTHER(this, "falling_impact_radius_pushback")
			if ( iImpactPushback )
			{
				local flPushAmount = MATH.RemapValClamped( flOriginalVelocity, 100.0, 1000.0, GetFloatCvar("tf_rocketpack_impact_push_min", 100.0), GetFloatCvar("tf_rocketpack_impact_push_max", 300.0) )
				local flPushRadius = MATH.RemapValClamped( flOriginalVelocity, 100.0, 1000.0, 150.0, 220.0 )
			
				// Stun, too?
				local iImpactStun = CALL_ATTRIB_HOOK_INT_ON_OTHER(this, "falling_impact_radius_stun")
				if ( iImpactStun && flOriginalVelocity >= 100.0 )
				{
					local flStunTime = MATH.RemapValClamped( flOriginalVelocity, 100.0, 1000.0, 1.5, 3.0 )
					CreateBaseExplosion({
						owner = this
						radius = 192.0
						damage = 0
						MinDamage = 0
						OnlyPlayers = true
						origin = GetOrigin()
						/** 
						 * @param {CTFPlayer} player
						 */
						function ExplodeFunc( player ) {
							local stun_flags = TF_STUN_CONTROLS

							if (player.IsMiniBoss())
								stun_flags = TF_STUN_MOVEMENT | TF_STUN_NO_EFFECTS

							player.StunPlayer( ( bHitEnemy ) ? 5.0 : flStunTime, 0.85, stun_flags, this )
						}
					})
				}

				CreateBaseExplosion({
					owner = this
					radius = flPushRadius + 30.0 // bloat because my shit is shit
					damage = 0
					MinDamage = 0
					OnlyPlayers = true
					origin = GetOrigin()
					/** 
					 * @param {CTFPlayer} player
					 */
					function ExplodeFunc( player ) {
						local toPlayer = player.EyePosition() - GetAbsOrigin()

						toPlayer.z = 0.0
						toPlayer.Norm()
						toPlayer.z = 1.0

						local vPush = flPushAmount * toPlayer

						player.ApplyAbsVelocityImpulse( vPush )
					}
				})

				SetPropFloat(this, "m_Local.m_flFallVelocity", 0)

				/**@type {[CTFPlayer]} */
				local vecPlayers = GetAllPlayers(GetTeam(), flPushRadius, true)

				// Extinguish teammates
				foreach ( pPlayer in vecPlayers )
				{
					if ( !pPlayer.InCond( TF_COND_BURNING ) )
						continue

					if ( !CanPointSeePoint(EyePosition(), pPlayer.EyePosition()) )
						continue
					
					pPlayer.RemoveCondEx( TF_COND_BURNING, true)
					pPlayer.EmitSound( "TFPlayer.FlameOut" )
					//CTF_GameStats.Event_PlayerAwardBonusPoints( this, pPlayer, 10 )
				}
			}
			info.SetDamage( MATH.Max( info.GetDamage() * 0.25, 1.0 ) )
		}
	}

	// Acheivements are NO TOUCHYS
	// Ignore damagers on our team, to prevent capturing rocket jumping, etc.
	/* if ( pAttacker && pAttacker.GetTeam() != GetTeam() )
	{
		m_AchievementData.AddDamagerToHistory( pAttacker )
		if ( pAttacker->IsPlayer() )
		{
			ToTFPlayer( pAttacker )->m_AchievementData.AddTargetToHistory( this )

			// add to list of damagers via sentry so that later we can check for achievement: ACHIEVEMENT_TF_ENGINEER_SHOTGUN_KILL_PREV_SENTRY_TARGET
			CBaseEntity *pInflictor = info.GetInflictor()
			CObjectSentrygun *pSentry = dynamic_cast< CObjectSentrygun * >( pInflictor )
			if ( pSentry )
			{
				m_AchievementData.AddSentryDamager( pAttacker, pInflictor )
			}
		}
	} */

	// keep track of amount of damage last sustained
	SetPropFloat(this, "m_lastDamageAmount", info.GetDamage())
	SetInternalVar("m_LastDamageType", info.GetDamageType())

	if ( GetInternalVar("m_LastDamageType") & DMG_FALL )
	{
		if ( ( GetPropFloat(this, "m_lastDamageAmount") > GetInternalVar("m_iLeftGroundHealth", GetHealth()) ) && ( GetPropFloat(this, "m_lastDamageAmount") < GetHealth() ) )
		{
			// we gained health in the air, and it saved us from death.
			// if any medics are healing us, they get an achievement
			// local healers = GetHealers()
			// not gonna bother because healers is hard, and its an achievement
			// for ( local i = 0 i < iNumHealers i++ )
			// {
			// 	local pMedic = ToTFPlayer( )
			// 	CTFPlayer *pMedic = ToTFPlayer( m_Shared.GetHealerByIndex(i) )

			// 	// if its a medic healing us
			// 	if ( pMedic && pMedic->IsPlayerClass( TF_CLASS_MEDIC ) )
			// 	{
			// 		pMedic->AwardAchievement( ACHIEVEMENT_TF_MEDIC_SAVE_FALLING_TEAMMATE )
			// 	}
			// }
		}
	}


	// No Touchy for Achievements!
	// Check for Demo Achievement:
	// Kill a Heavy from full health with one detonation
	/* if ( IsPlayerClass( TF_CLASS_HEAVYWEAPONS ) )
	{
		if ( pTFAttacker && pTFAttacker->IsPlayerClass( TF_CLASS_DEMOMAN ) )
		{
			if ( pWeapon && pWeapon->GetWeaponID() == TF_WEAPON_PIPEBOMBLAUNCHER )
			{
				// We're at full health
				if ( m_iHealthBefore >= GetMaxHealth() )
				{
					// Record the time
					m_fMaxHealthTime = Time()
				}

				// If we're still being hit in the same time window
				if ( m_fMaxHealthTime == Time() )
				{
					// Check if the damage is fatal
					int iDamage = info.GetDamage()
					if ( m_iHealth - iDamage <= 0 )
					{
						pTFAttacker->AwardAchievement( ACHIEVEMENT_TF_DEMOMAN_KILL_X_HEAVIES_FULLHP_ONEDET )
					}
				}
			}
		}
	} */
	
	if ( pTFAttacker && pTFAttacker.IsPlayerClass( TF_CLASS_MEDIC ) && pWeapon && pWeapon.GetIDX() == TF_WEAPON_VITA_SAW )
	{
		// Spawn their spleen
		/** @type {CBaseEntity} */
		local pRandomInternalOrgan = CreateByClassname("prop_physics_override")
		if ( pRandomInternalOrgan )
		{
			pRandomInternalOrgan.SetCollisionGroup( COLLISION_GROUP_DEBRIS )
			pRandomInternalOrgan.AddFlag( FL_GRENADE )
			pRandomInternalOrgan.KeyValueFromVector("origin", GetOrigin())
			pRandomInternalOrgan.KeyValueFromVector("angles", Vector(GetAbsAngles().Pitch(), GetAbsAngles().Yaw(), GetAbsAngles().Roll()))
			pRandomInternalOrgan.KeyValueFromString("model", "models/player/gibs/random_organ.mdl")
			pRandomInternalOrgan.KeyValueFromInt("fademindist", -1)
			pRandomInternalOrgan.KeyValueFromInt("fademaxdist", 0)
			pRandomInternalOrgan.KeyValueFromInt("fadescale", 1 )
			pRandomInternalOrgan.KeyValueFromFloat("inertiaScale", 1.0 )
			pRandomInternalOrgan.KeyValueFromFloat("physdamagescale", 0.1 )
			pRandomInternalOrgan.DispatchSpawn()
			SetPropInt( pRandomInternalOrgan, "m_takedamage", DAMAGE_YES ) // Take damage, otherwise this can block trains
			pRandomInternalOrgan.SetHealth( 100 )

			local vecImpulse = MATH.RandomVec( -1.0, 1.0 )
			vecImpulse.z = 1.0
			vecImpulse.Norm()
			
			local vecVelocity = vecImpulse * 250.0
			pRandomInternalOrgan.ApplyAbsVelocityImpulse( vecVelocity )

			EntFireNew(pRandomInternalOrgan, "Kill", "", 5.0)
		}
	}

	if ( bIsSoldierRocketJumping || bIsDemomanPipeJumping )
	{
		local nJumpType = 0

		// If this is our own rocket, scale down the damage if we're rocket jumping
		if ( bIsSoldierRocketJumping ) 
		{
			local flDamage = info.GetDamage() * GetFloatCvar("tf_damagescale_self_soldier", 0.60)
			info.SetDamage( flDamage )

			if ( GetInternalVar("m_iHealthBefore", GetHealth()) - flDamage > 0 )
			{
				nJumpType = TF_PLAYER_ROCKET_JUMPED
			}
		}
		else if ( bIsDemomanPipeJumping )
		{
			nJumpType = TF_PLAYER_STICKY_JUMPED
		}

		if ( nJumpType )
		{
			local bPlaySound = false
			if ( pWeapon )
			{
				bPlaySound = CALL_ATTRIB_HOOK_INT_ON_OTHER( pWeapon, "no self blast dmg" ) ? true : false
			}

			SetBlastJumpState( nJumpType, bPlaySound )
		}
	}

	if ( IsMannVsMachineMode() && GetTeam() == TF_TEAM_PVE_INVADERS )
	{
		// can only bounce invaders when they are on the ground
		if ( GetGroundEntity() == null )
			info.SetDamageForce( Vector() )
	}

	// Save damage force for ragdolls.
	local ragdoll_force = info.GetDamageForce()
	ragdoll_force.x = MATH.clamp( ragdoll_force.x, -15000.0, 15000.0 )
	ragdoll_force.y = MATH.clamp( ragdoll_force.y, -15000.0, 15000.0 )
	ragdoll_force.z = MATH.clamp( ragdoll_force.z, -15000.0, 15000.0 )
	SetInternalVar("m_vecTotalBulletForce", ragdoll_force)

	local bTookDamage = 0
 	local bitsDamage = inputInfo.GetDamageType()

	local bAllowDamage = false

	if ( pInflictor && pInflictor.GetClassname() == "point_hurt")
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
		if (pInflictor.GetClassname() == "trigger_hurt")
		{
			bAllowDamage = true
			info.SetDamageCustom( TF_DMG_CUSTOM_TRIGGER_HURT )
		}
		else if (pInflictor.GetClassname() == "func_croc")
		{
			bAllowDamage = true
			info.SetDamageCustom( TF_DMG_CUSTOM_CROC )
		}
	}
	else if ( info.GetDamageCustom() == TF_DMG_CUSTOM_TELEFRAG )
	{
		bAllowDamage = true
	}

	if ( !ApplyOnDamageModifyRules( info, this, bAllowDamage ) )
		return 0

	// If player has Reflect Powerup, reflect damage to attacker. 
	// We do this here, after damage modify rules to ensure distance falloff calculations have already been made before we pass that damage back to the attacker
	if ( pTFAttacker && m_Shared.GetCarryingRuneType() == RUNE_REFLECT && pTFAttacker != this && !pTFAttacker.IsInvulnerable() && pTFAttacker.IsAlive() && InputInfo.GetDamageCustom() != TF_DMG_CUSTOM_RUNE_REFLECT )
	{
		local dmg = info
		local sentryRocket = IsSentryRocket(info.GetInflictor()) ? info.GetInflictor() : null

		if ( Time() > GetInternalVar("m_flNextReflectZap", 0.0) ) // don't spam the effect for fast weapons like flamethrower and minigun
		{
			SetInternalVar("m_flNextReflectZap", Time() + 0.5)

			local vEnd = pTFAttacker.GetCenter()
			local vStart = GetCenter()

			if ( bIsObject || sentryRocket )
				vEnd = info.GetInflictor().GetCenter()
			else
			{
				// Push the attacker away from the Reflect powerup holder
				local toPlayer = vEnd - vStart
				toPlayer.z = 0.0
				toPlayer.Norm()
				toPlayer.z = 1.0
				local flDamage = dmg.GetDamage()
				if ( dmg.GetDamageCustom() != TF_DMG_CUSTOM_BURNING )
				{
					local flPushForce = MATH.RemapValClamped( flDamage, 0.1, 150.0, 300.0, 500.0 )		// Scale the push force according to damage
					local vPush = flPushForce * toPlayer
					pTFAttacker.ApplyAbsVelocityImpulse( vPush )
				}

				// Play a sound and reduce the volume if damage is low
				EmitSoundEx({
					soundname = "Powerup.Reflect.Reflect"
					volume = flDamage < 10.0 ? 0.75 : 1.0
					entity = pTFAttacker
				})
				// pTFAttacker->PainSound( dmg )
			}
			// TE_TFParticleEffectComplex( filter, 0.0, "dxhr_arm_muzzleflash", vStart, QAngle( 0.0, 0.0, 0.0 ), null, &controlPoint, pTFAttacker, PATTACH_CUSTOMORIGIN )
		}

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
					pTFAttacker.TakeCustomDamage(dmg)
				}
			}
		}
	}

	//Don't take damage while I'm phasing.
	if ( ( InCond( TF_COND_PHASE ) || InCond( TF_COND_PASSTIME_INTERCEPTION ) ) && bAllowDamage == false )
	{
		EntFireNew(this, "SpeakResponseConcept", "TLK_DODGE_SHOT")

		if ( pAttacker && pAttacker.IsPlayer() )
			CreateParticle("miss_text", GetCenter() + Vector(0,0,32))

		local vecDir = Vector()
		if ( info.GetInflictor() )
		{
			vecDir = info.GetInflictor().GetCenter() - Vector ( 0, 0, 10 ) - GetCenter()
			vecDir.Norm()
		}

		// ApplyPushFromDamage( info, vecDir ) // TODO:

		if ( InCond( TF_COND_PHASE ) )
		{
			//TODO:
			// m_Shared.m_ConditionData[ TF_COND_PHASE ].m_nPreventedDamageFromCondition += info.GetDamage()
			SetInternalVar("m_iPhaseDamage", GetInternalVar("m_iPhaseDamage", 0)+info.GetDamage())
		}

		bTookDamage = false
	}
	else
	{
		local bFatal = ( GetHealth() - info.GetDamage() ).tointeger() <= 0
		local bIsBot = ( pTFAttacker && pTFAttacker.IsBot() ) || IsBot()
		local bTrackEvent = pTFAttacker && pTFAttacker != this && !bIsBot
		if ( bTrackEvent )
		{
			local flHealthRemoved = bFatal ? GetHealth() : info.GetDamage()
			if ( info.GetDamageBonus() && info.GetDamageBonusProvider() )
			{
				// Don't deal with raw damage numbers, only health removed.
				// Example based on a crit rocket to a player with 120 hp:
				// Actual damage is 120, but potential damage is 300, where
				// 100 is the base, and 200 is the bonus.  Apply this ratio
				// to actual (so, attacker did 40, and provider added 80).
				local flBonusMult = info.GetDamage().tointeger() / abs( info.GetDamageBonus() - info.GetDamage() )
				local flBonus = flHealthRemoved - ( flHealthRemoved / flBonusMult )
				// m_AchievementData.AddDamageEventToHistory( info.GetDamageBonusProvider(), flBonus ) // no Achievements
				flHealthRemoved -= flBonus
			}
			// m_AchievementData.AddDamageEventToHistory( pAttacker, flHealthRemoved ) // no Achievements
		}

		// This should kill us
		if ( bFatal )
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
			if ( RandomFloat(0, 1) < flCheatDeathChance )
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
		{
			if ( bDebug )
			{
				Warning( "    ABORTED: Player failed to take the damage.\n" )
			}
			return 0
		}

		if (!("gs_pRecursivePlayerCheck" in ROOT))
			::gs_pRecursivePlayerCheck <- null
		// Check to see if we need to pass along the damage to other players
		if ( pWeapon && ( gs_pRecursivePlayerCheck == null ) )
		{
			local iDamageAllConnected = CALL_ATTRIB_HOOK_INT_ON_OTHER( pWeapon, "damage all connected" )

			if ( iDamageAllConnected > 0 )
			{
				// Am I healing someone or being healed?
				local pTempPlayerQueue = []
				AddConnectedPlayers( pTempPlayerQueue, this )
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
					
				gs_pRecursivePlayerCheck = this
				foreach (pTFPlayer in pTempPlayerQueue)
				{
					if (pTFPlayer != this)
					pTFPlayer.TakeCustomDamage(inputInfo)
				}
				gs_pRecursivePlayerCheck = null
			}
		}
	}

	if ( bTookDamage == false )
		return 0

	if ( bDebug )
	{
		Warning( "    DEALT: Player took %.2f damage.\n", info.GetDamage() )
		Warning( "    HEALTH LEFT: %d\n", GetHealth() )
	}

	// Some weapons have the ability to impart extra moment just because they feel like it. Let their attributes
	// do so if they're in the mood.
	if ( pWeapon != null )
	{
		local flZScale = CALL_ATTRIB_HOOK_FLOAT_ON_OTHER( pWeapon, "apply z velocity on damage" )
		if ( flZScale != 0.0 )
		{
			ApplyAbsVelocityImpulse( Vector( 0.00, 0.00, flZScale ) )
		}

		local flDirScale = CALL_ATTRIB_HOOK_FLOAT_ON_OTHER( pWeapon, "apply look velocity on damage" )
		if ( flDirScale != 0.0 && pAttacker != null )
		{
			local vecForward = pAttacker.EyeAngles().Forward()

			local vecForwardNoDownward = Vector( vecForward.x, vecForward.y, MATH.Min( 0.0, vecForward.z ) )
			vecForwardNoDownward.Norm()
			ApplyAbsVelocityImpulse( vecForwardNoDownward * flDirScale )
		}
	}

	// let weapons react to their owner being injured
	local pMyWeapon = GetActiveWeapon()
	if ( pMyWeapon )
	{
		// pMyWeapon.ApplyOnInjuredAttributes( this, pTFAttacker, info ) // TODO:
	}

	// Send the damage message to the client for the hud damage indicator
	// Try and figure out where the damage is coming from
	local vecDamageOrigin = info.GetReportedPosition()

	// If we didn't get an origin to use, try using the attacker's origin
	if ( vecDamageOrigin == Vector() && info.GetInflictor() )
	{
		vecDamageOrigin = info.GetInflictor().GetOrigin()
	}

	// Tell the player's client that he's been hurt.
	if ( GetInternalVar("m_iHealthBefore", 0) != GetHealth() )
	{
		// No UserMessages
		/* UserMessageBegin( user, "Damage" )
			WRITE_SHORT( clamp( (int)info.GetDamage(), 0, 32000 ) )
			WRITE_LONG( info.GetDamageType() )
			// Tell the client whether they should show it in the indicator
			if ( bitsDamage != DMG_GENERIC && !(bitsDamage & (DMG_DROWN | DMG_FALL | DMG_BURN) ) )
			{
				WRITE_BOOL( true )
				WRITE_VEC3COORD( vecDamageOrigin )
			}
			else
			{
				WRITE_BOOL( false )
			}
		MessageEnd() */
	}

	// add to the damage total for clients, which will be sent as a single
	// message at the end of the frame
	// todo: remove after combining shotgun blasts?
	if ( info.GetInflictor() )
	{
		SetPropVector(this, "m_DmgOrigin", info.GetInflictor().GetOrigin())
	}

	SetPropInt(this, "m_DmgTake", GetPropInt(this, "m_DmgTake") + info.GetDamage().tointeger() )


	// Reset damage time countdown for each type of time based damage player just sustained
	/* for (int i = 0 i < CDMG_TIMEBASED i++)
	{
		// Make sure the damage type is really time-based.
		// This is kind of hacky but necessary until we setup DamageType as an enum.
		int iDamage = ( DMG_PARALYZE << i )
		if ( ( info.GetDamageType() & iDamage ) && g_pGameRules->Damage_IsTimeBased( iDamage ) )
		{
			m_rgbTimeBasedDamage[i] = 0
		}
	} */

	local pzsMedigunResistEffect = null
	local pzsTeam = GetTeam() == TF_TEAM_RED ? "red" : "blue"

	// If we have one of the medigun resist buffs and get hit with the matching damage type then
	// spawn a particle above our head to let enemies know their damage is being resisted, and tell
	// the medic he's doing the right thing.

	local bMedicBulletResist		= InCond( TF_COND_MEDIGUN_UBER_BULLET_RESIST ) 	|| InCond( TF_COND_MEDIGUN_SMALL_BULLET_RESIST )
	local bMedicExplosiveResist		= InCond( TF_COND_MEDIGUN_UBER_BLAST_RESIST )	|| InCond( TF_COND_MEDIGUN_SMALL_BLAST_RESIST )
	local bMedicFireResist			= InCond( TF_COND_MEDIGUN_UBER_FIRE_RESIST )	|| InCond( TF_COND_MEDIGUN_SMALL_FIRE_RESIST )

	if ( ( bMedicBulletResist && ( bitsDamage & DMG_BULLET ) ) )
		pzsMedigunResistEffect = format("vaccinator_%s_buff1_burst", pzsTeam)
	else if ( bMedicExplosiveResist && ( bitsDamage & DMG_BLAST	) )
		pzsMedigunResistEffect = format("vaccinator_%s_buff2_burst", pzsTeam)
	else if ( bMedicFireResist && ( bitsDamage & DMG_BURN ) )
		pzsMedigunResistEffect = format("vaccinator_%s_buff3_burst", pzsTeam)

	if ( pzsMedigunResistEffect != null )
		CreateParticle(pzsMedigunResistEffect, GetOrigin())

	// Display any effect associate with this damage type
	// DamageEffect( info.GetDamage(),bitsDamage ) // TODO:

	// // Save this so we can report it to the client
	SetPropFloat( this, "m_bitsDamageType", GetPropFloat( this, "m_bitsDamageType" ) | bitsDamage )
	SetPropFloat( this, "m_bitsHUDDamage", -1 ) // make sure the damage bits get reset

	// Flinch
	local bFlinch = true
	if ( bitsDamage != DMG_GENERIC )
	{
		if ( IsPlayerClass( TF_CLASS_SNIPER ) && InCond( TF_COND_AIMING ) )
		{
			if ( pTFAttacker && pWeapon && pWeapon.IsMinigun() )
			{
				local flDistSqr = ( pTFAttacker.GetOrigin() - GetOrigin() ).LengthSqr()
				if ( flDistSqr > 750 * 750 )
					bFlinch = false
			}
		}

		if ( bFlinch )
		{
			if ( ApplyPunchImpulseX( -2 ) ) 
			{
				// PlayFlinch( info ) // cant do
			}
		}

		// PASSTIME intense flinch to make it hard to throw straight while taking damage

		local tf_passtime_flinch_boost = IsCvarAllowed("tf_passtime_flinch_boost") ? GetCvarInt("tf_passtime_flinch_boost") : 0
		if ( IsPasstimeMode() && (tf_passtime_flinch_boost > 0) )
		{
			local iFlinch = tf_passtime_flinch_boost
			local pMyWeapon = GetActiveWeapon()
			if ( pMyWeapon && pMyWeapon.GetIDX() == 1155 )
			{
				// QAngle punch
				// punch.Random( -iFlinch, iFlinch )
				// SetPunchAngle( punch ) //TODO:
			}
		}
	}

	// Do special explosion damage effect
	if ( bitsDamage & DMG_BLAST )
	{
		// OnDamagedByExplosion( info ) // TODO
	}

	if ( GetInternalVar("m_iHealthBefore", 0) != GetHealth() )
	{
		// PainSound( info ) // TODO
	}

	// Detect drops below 25% health and restart expression, so that characters look worried.
	local iHealthBoundary = (GetMaxHealth() * 0.25)
	if ( GetHealth() <= iHealthBoundary && GetInternalVar("m_iHealthBefore", 0) > iHealthBoundary )
	{
		// ClearExpression() // cant do
	}

	// CTF_GameStats.Event_PlayerDamage( this, info, GetInternalVar("m_iHealthBefore", 0) - GetHealth() )


	// if we take damage after we leave the ground, update the health if its less
	if ( bTookDamage && GetInternalVar("m_iLeftGroundHealth", 0) > 0 )
	{
		if ( GetHealth() < GetInternalVar("m_iLeftGroundHealth", 0) )
			SetInternalVar("m_iLeftGroundHealth", GetHealth())
	}
	
	if ( IsPlayerClass( TF_CLASS_SPY ) && ( inputInfo.GetDamageCustom() != TF_DMG_CUSTOM_TELEFRAG ) && ( inputInfo.GetDamageCustom() != TF_DMG_CUSTOM_CROC ) )
	{
		// Trigger feign death if the player has it prepped...
		if ( IsFeignDeathReady() )
		{
			SetFeignDeathReady( false )
			if ( !InCond( TF_COND_TAUNTING ) )
			{
				SpyDeadRingerDeath( info )

				if ( pTFAttacker )
				{
					// pTFAttacker->IncrementKillCountSinceLastDeploy( info ) // TODO
				}
			}
		}
		else if ( !( info.GetDamageType() & DMG_FALL ) )
		{
			// m_Shared.NoteLastDamageTime( m_lastDamageAmount ) // TODO
		}
	}

	if ( pWeapon ) 
	{
		// pWeapon->ApplyPostHitEffects( inputInfo, this ) // TODO
	}

	if ( IsPlayerClass( TF_CLASS_DEMOMAN ) )
	{
		// Reduce charge if damage is taken
		local iDemoChargeDamagePenalty = CALL_ATTRIB_HOOK_INT_ON_OTHER(this, "lose demo charge on damage when charging")
		// Does not apply to self or fall damage
		if ( iDemoChargeDamagePenalty && InCond( TF_COND_SHIELD_CHARGE ) && !( info.GetDamageType() & DMG_FALL ) && (pAttacker != this) )
		{
			iDemoChargeDamagePenalty *= info.GetDamage()
			SetDemomanChargeMeter( MATH.Max( GetDemomanChargeMeter() - iDemoChargeDamagePenalty.tofloat(), 0.0 ) )
		}
	}


	local flRageScale = CALL_ATTRIB_HOOK_FLOAT_ON_OTHER(this, "rage giving scale", 1.0)

	// Give the soldier/pyro some rage points for dealing/taking damage.
	if ( bTookDamage && pTFAttacker != this )
	{
		// Buff flag 1: we get rage when we deal damage. Here, that means the soldier that attacked
		// gets rage when we take damage.
		// HandleRageGain( pTFAttacker, kRageBuffFlag_OnDamageDealt, info.GetDamage() * flRageScale, 6.0f ) // TODO

		// Buff flag 2: we get rage when we take damage.
		if ( !( info.GetDamageType() & DMG_FALL ) )
		{
			// HandleRageGain( this, kRageBuffFlag_OnDamageReceived, info.GetDamage() * flRageScale, 3.5 ) // TODO
		}

		// Buff 5: our pyro attacker get rage when we're damaged by fire
		if ( ( info.GetDamageType() & DMG_BURN ) != 0 || ( info.GetDamageType() & DMG_PLASMA ) != 0 )
		{
			local flInverseRageGainScale = IsMannVsMachineMode() ? 12.0 : 3.0
			// HandleRageGain( pTFAttacker, kRageBuffFlag_OnBurnDamageDealt, info.GetDamage() * flRageScale, flInverseRageGainScale ) // TODO
		}
	}

	if ( pWeapon && pWeapon.IsFish() )
	{
		local bDisguised = InCond( TF_COND_DISGUISED ) && pTFAttacker && ( m_Shared.GetDisguiseTeam() == pTFAttacker.GetTeam() )
		local bFish = pWeapon.GetWeaponClass() == "bat_fish"

		if ( GetHealth() <= 0 )
			info.SetDamageCustom( bFish ? TF_DMG_CUSTOM_FISH_KILL : TF_DMG_CUSTOM_SLAP_KILL )

		if ( GetHealth() <= 0 || !bDisguised )
		{
			// Do you ever find yourself typing "fish damage override" into a million-lines-of-code project and
			// wondering about the world? Because I do.
			local iFishDamageOverride = CALL_ATTRIB_HOOK_INT_ON_OTHER( pWeapon, "fish damage override" )
			// TFGameRules()->DeathNotice( this, info, bFish ? ( iFishDamageOverride ? "fish_notice__arm" : "fish_notice" ) : "slap_notice" ) // TODO
		}
	}

	if ( IsPlayerClass( TF_CLASS_SCOUT) )
	{
		// Lose hype on take damage
		local iHypeResetsOnTakeDamage = CALL_ATTRIB_HOOK_INT( this, "lose hype on take damage" )
		if ( iHypeResetsOnTakeDamage != 0 )
		{
			// Loose x hype on jump
			local flHype = GetScoutHypeMeter()
			SetScoutHypeMeter( flHype - iHypeResetsOnTakeDamage * info.GetDamage() )
			TeamFortress_SetSpeed()
		}
	}

	// Let attacker react to the damage they dealt
	if ( pTFAttacker )
	{
		// pTFAttacker->OnDealtDamage( this, info ) // TODO
	}

	local bIsPyroDetonateJumping = ( IsPlayerClass( TF_CLASS_PYRO ) && pAttacker == this && !(GetFlags() & FL_ONGROUND) && !(GetFlags() & FL_INWATER))
	if ( bIsDemomanPipeJumping || bIsSoldierRocketJumping || bIsPyroDetonateJumping )
	{
		local Healers = GetActiveHealers()
		// Are we being healed by any QuickFix medics?
		foreach (pMedic in Healers)
		{
			// Share blast jump with them
			local pMedigun = pMedic.GetActiveWeapon() && pMedic.GetActiveWeapon().IsMedigun() ? pMedic.GetActiveWeapon() : null
			if ( pMedigun && pMedigun.GetAttribute("lunchbox adds minicrits", 0) == 2 )
			{
				local flForce = GetAbsVelocity().Length()
				flForce = MATH.Min( flForce, 900.0 )
				local vecNewVelocity = GetAbsVelocity()
				vecNewVelocity.Normalize()
				pMedic.RemoveFlag( FL_ONGROUND )
				pMedic.ApplyAbsVelocityImpulse( vecNewVelocity * flForce )
			}
		}
	}

	if ( pTFAttacker && pTFAttacker.IsPlayerClass( TF_CLASS_SOLDIER ) )
	{
		if ( info.GetDamageType() & DMG_BLAST )
		{
			// Send an event whenever a soldier hits another player directly with a stun rocket

			local pRocket = ToBaseRocket(info.GetInflictor())
			// cant use GetEnemy
			/* if ( pRocket && pRocket->GetStunLevel() && pRocket->GetEnemy() && pRocket->GetEnemy() == this )
			{
				IGameEvent *event = gameeventmanager->CreateEvent( "player_directhit_stun" )
				if ( event )
				{
					event->SetInt( "attacker", pTFAttacker->entindex() )
					event->SetInt( "victim", entindex() )
					gameeventmanager->FireEvent( event )
				}
			} */
		}
	}

	// No Kill Eater stuff
	/* local pTFWeapon = GetKilleaterWeaponFromDamageInfo( info )
	if ( !pTFWeapon )
	{
		// Check Wearable instead like demoshields or manntreads
		CTFWearable *pWearable = dynamic_cast< CTFWearable* >( info.GetWeapon() )
		if ( pWearable )
		{
			EconEntity_OnOwnerKillEaterEvent_Batched( pWearable, pTFAttacker, this, kKillEaterEvent_DamageDealt, info.GetDamage() )
			EconEntity_OnOwnerKillEaterEvent_Batched( pWearable, pTFAttacker, this, kKillEaterEvent_PlayersHit, 1 )
		}
	}
	else
	{
		EconEntity_OnOwnerKillEaterEvent_Batched( pTFWeapon, pTFAttacker, this, kKillEaterEvent_DamageDealt, info.GetDamage() )
		EconEntity_OnOwnerKillEaterEvent_Batched( pTFWeapon, pTFAttacker, this, kKillEaterEvent_PlayersHit, 1 )
	} */

	if ( bTookDamage && InCond( TF_COND_GAS ) )
	{
		// Cond providers
		// CTFPlayer *pTFGasTosser = dynamic_cast< CTFPlayer* >( m_Shared.GetConditionProvider( TF_COND_GAS ) )
		local pTFGasTosser = null
		if ( pTFGasTosser )
		{
			local event = {}
			event.igniter <- pAttacker ? pAttacker.entindex() : 0
			event.douser <- pTFGasTosser.entindex()
			event.victim <- entindex()
			SendGlobalGameEvent("gas_doused_player_ignited", event)
		}

		if ( IsPlayerClass( TF_CLASS_PYRO ) )
			AddCondEx( TF_COND_BURNING_PYRO, 10.0, this)

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
				local flRadius = 200.0

				CreateBaseExplosion({
					owner = pTFGasTosser
					radius = flRadius + 50.0
					damage = 350
					MinDamage = 350
					OnlyPlayers = true
					origin = GetOrigin()
					/** 
					 * @param {CTFPlayer} player
					 */
					function ExplodeFunc( player ) {
						DispatchParticleEffect("dragons_fury_effect", player.GetOrigin(), Vector())
						bExploded = true
					}
				})

				if ( bExploded )
					EmitSound( "Weapon_Grenade_Pipebomb.Explode" )
			}
		}
	}

	// bHadBallBeforeDamage will always be false in non-passtime modes
	if ( bTookDamage && bHadBallBeforeDamage )
	{
		// g_pPasstimeLogic->OnBallCarrierDamaged( this, pTFAttacker, info ) // TODO
	}

	return info.GetDamage()
}