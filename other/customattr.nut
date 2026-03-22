IncludeScript("fatcat_library")

function ROOT::CTFPlayer::SetupCAttributes()
	GetScope(this).CustomAttributes <- {}
function ROOT::CTFPlayer::HasCAttribute(attribute)
	return "CustomAttributes" in GetScope(this) ? attribute in GetScope(this).CustomAttributes : false
function ROOT::CTFPlayer::GetCAttribute(attribute)
{
	if(!HasCAttribute(attribute))
		return null
	else
		return attribute in GetScope(this).CustomAttributes ? GetScope(this).CustomAttributes[attribute] : null
}
function ROOT::CTFPlayer::AddCAttribute(attribute, values, duration = 0.0)
{
	if(duration != 0.0 && !("__duration" in values))
		values.__duration <- duration
	GetScope(this).CustomAttributes[attribute] <- values
}
function ROOT::CTFPlayer::RemoveCAttribute(attribute)
{
	if(!HasCAttribute(attribute))
		return
	delete GetScope(this).CustomAttributes[attribute]
}
function ROOT::CTFPlayer::PrintCAttributes()
	PrintTable(GetScope(this).CustomAttributes)


::CustomAttrsEvents <- {
	/**
	 * Fired when a entity is about to take damage (Script Hook).
	 * 
	 * @param {entity}		victim				The player taking damage.
	 * @param {entity|null}	attacker			The entity dealing damage.
	 * @param {entity|null}	inflictor			The entity inflicting damage (weapon/projectile).
	 * @param {entity|null}	weapon				The weapon used.
	 * @param {vector}		damage_position		World position of where the damage came from. E.g. end position of a bullet or a rocket.
	 * @param {float}		damage				The actual damage amount ( Does not count number of bullets or falloff or rampup )
	 * @param {float}		base_damage			The base damage before modifiers.
	 * @param {long}		damage_type			Damage type bits (e.g. DMG_GENERIC).
	 * @param {short}		damage_custom		Custom damage type stats.
	 * @param {short}		crit_type			Crit type (0=None, 1=Mini, 2=Full).
	 * @param {short}		penetration_count	How many players the damage has penetrated so far.
	 * @param {short}		others_damaged		How many players other than the attacker has the damage been applied to.
	 */
	function OnGameEvent_PostTakeDamage(params)
	{
		if(params.damage_custom == TF_DMG_CUSTOM_TRIGGER_HURT)
			return

		if(params.victim.GetClassname() == "tf_generic_bomb")
			return

		if(!params.attacker.IsPlayer())
			return

		local victim = params.victim
		local player = params.attacker

		if(!player.HasCAttribute("Explosive Bullets"))
			return
		local attrib = player.GetCAttribute("Explosive Bullets")

		local damage    = "damage"      in attrib ? attrib.damage       : 100
		local radius    = "radius"      in attrib ? attrib.radius       : 50
		local particle  = "particle"    in attrib ? attrib.particle     : "ExplosionCore_sapperdestroyed"
		local sound     = "sound"       in attrib ? attrib.sound        : "weapons/pipe_bomb1.wav"

		CreateBaseExplosion({
			owner 		= player
			origin 		= params.damage_position+Vector(0, 0, 1)
			weapon 		= params.weapon
			ignores 	= [victim]
			DmgType 	= DMG_BLAST
			damage 		= "damage"		in attrib ? attrib.damage		: 100
			radius 		= "radius"		in attrib ? attrib.radius		: 50
			particle	= "particle"	in attrib ? attrib.particle		: "ExplosionCore_sapperdestroyed"
			sound 		= "sound"		in attrib ? attrib.sound		: "weapons/pipe_bomb1.wav"
			SoundDelay 	= 0.1
		})
	}
}
__CollectGameEventCallbacks(CustomAttrsEvents)

function ExplosiveBulletsExt( player, item, value ) 
{
	local generic_bomb = "tf_generic_bomb"

	local damage = "damage" in value ? value.damage : 150
	local radius = "radius" in value ? value.radius : 150
	local team = "team" in value ? value.team : player.GetTeam()
	local model = "model" in value ? value.model : ""
	local particle = "particle" in value ? value.particle : "mvm_loot_explosion"
	local sound = "sound" in value ? value.sound : "weapons/pipe_bomb1.wav"
	local killicon = "killicon" in value ? value.killicon : "megaton"

	PrecacheSound( sound )

	local scope = player.GetScriptScope()

	local event_hook_string = format( "ExplosiveBulletsExt_%d_%d", PopExtUtil.PlayerTable[ player ], item.entindex() )

	POP_EVENT_HOOK( "OnTakeDamage", event_hook_string, function( params )
	{
		if ( "explosivebullets" in scope || params.weapon != item || !PopExtAttributes.HasAttr( player, "explosive bullets ext" ) )
			return

		scope.explosivebullets <- true

		local particleent = SpawnEntityFromTable( "info_particle_system", { effect_name = particle } )

		if ( params.const_entity.GetClassname() == generic_bomb || params.attacker.GetClassname() == generic_bomb )
			return

		else if ( params.attacker == player && params.const_entity.GetClassname() == generic_bomb )
			return

		local bomb = CreateByClassname( generic_bomb )

		SetPropFloat( bomb, "m_flDamage", damage )
		SetPropFloat( bomb, "m_flRadius", radius )
		SetPropString( bomb, "m_explodeParticleName", particle ) // doesn't work
		SetPropString( bomb, "m_strExplodeSoundName", sound )

		DispatchSpawn( bomb )
		PopExtUtil._SetOwner( bomb, params.attacker )

		bomb.SetTeam( team )
		bomb.SetAbsOrigin( params.damage_position )
		bomb.SetHealth( 1 )
		if ( model != "" )
			bomb.SetModel( model )

		particleent.SetAbsOrigin( bomb.GetOrigin() )
		SetPropString( bomb, STRING_NETPROP_CLASSNAME, killicon )
		bomb.TakeDamage( 1, DMG_CLUB, player )
		EntFireByHandle( particleent, "Start", "", -1, null, null )
		EntFireByHandle( particleent, "Stop", "", 0.015, null, null )
		EntFireByHandle( particleent, "Kill", "", 0.015 * 2, null, null )

		if ( "explosivebullets" in scope )
			delete scope.explosivebullets
	}, EVENT_WRAPPER_CUSTOMATTR )
}