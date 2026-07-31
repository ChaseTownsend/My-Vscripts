if (!("SetLibraryVersion" in getroottable()) || ("FatCatLibForce" in ROOT && FatCatLibForce == true))
	IncludeScript("fatcat_library")

SetScriptVersion("zapinator", "1.0.0")


RegisterDamageCallback("player", "ZapinatorPlayer" function( params ) {
	if (HasCustomFlag(params.damage_custom, TF_DMG_CUSTOM_IGNORE_EVENTS) || params.damage_custom == TF_DMG_CUSTOM_TRIGGER_HURT)
		return

	local victim 	= params.victim
	local attacker 	= params.attacker
	local weapon 	= null
	local inflictor	= params.inflictor
	

	if (!attacker)
		return

	weapon = params.weapon

	if (!attacker || !weapon || !inflictor)
		return

	if ( !IsWeaponClass(weapon, "tf_weap", true) )
		return

	if (victim.IsInvincible() || IsPlayerABot(attacker))
		return

	if (!attacker.HasWeapon(30666) || weapon.GetIDX() != 30666)
		return

	local function GetDebugName(plr)
		return "( ["+plr.entindex()+"] : " + plr.GetUserName() + " )" 

	local function PrintLog(m)
		printf("[%d] : %s\n", GetFrameCount(), m)

	// printf("%s was hit by Laser!\n", GetDebugName(victim))

	local projectile = inflictor
	/** @type {table} */
	local proj_scope = GetScope(projectile)
	if (!("HitRobots" in proj_scope))
		proj_scope.HitRobots <- []

	if(proj_scope.HitRobots.find(victim.entindex()) != null)
	{
		PrintLog(format("Blocking repeated Hit against %s!", GetDebugName(victim)))
		params.early_out <- true
		return
	}

	if("Penetrates" in proj_scope)
	{
		PrintLog(format("Multiplying dmg by %f because of %d penetrations", 1 + (0.25 * proj_scope.Penetrates), proj_scope.Penetrates))
		params.damage *= 1 + (0.25 * proj_scope.Penetrates)
	}

	ZapinatorHit(victim, attacker, projectile, weapon)
})

// Vscript: 
//		Projectile cant hit an entity more than once
//
//		Chance to:
//			Apply a random debuff to enemy (jarate/milk/gas/bleed/marked/slow/fire) (20%)
//			Explode (takes priority over pierce if both are rolled) (10%) (done)
//			Penetrate (Allow a peirce and increase dmg mult by 25%) (50%) (done)
//			[MAYBE] Be Reflected (as in change dir and team) (3.33%)
//			[MAYBE INTEAD] Deflect of the bot and to a different bot (3.33%)
//			Knockback 750 look, 400 z

// effects: gas > bleed > slow > jar = mark = milk > 0.5s stun

/** 
 * @type {function}
 * @param {float} chance
 * @param {[any]} data
 * @param {function} reward_func
 * @param {function} fail_func
 * @returns {bool}
 */
function Roll( chance, data, reward_func, fail_func )
{
	local rolled = MATH.RandomChance()
	if(rolled <= chance)
		reward_func.acall([this].extend(data))
	else
		fail_func.acall([this].extend(data))

	return rolled <= chance
}

/** 
 * @type {function}
 * @param {CTFPlayer} victim
 * @param {CTFPlayer} attacker
 * @param {CBaseEntity} projectile
 * @param {CTFWeaponBase} weapon
 */
function ZapinatorHit(victim, attacker, projectile, weapon)
{
	local proj_scope = GetScope(projectile)
	if(!("Penetrates" in proj_scope))
		proj_scope.Penetrates <- 0

	proj_scope.HitRobots.append(victim.entindex())

	local PenetrateRoll = 
	Roll( 0.5, [projectile], 
	function(projectile) {
		GetScope(projectile).Penetrates++
	}, 
	function(...) {
		printl("Projectile failed to penetrate")
	})

	local ExplodeRoll = 
	Roll( 0.1, [attacker, projectile], 
	function(attacker, projectile) {
		printl("Projectile Detonated!")
		CreateBaseExplosion({
			owner = attacker
			weapon = null
			// ignores = [victim]
			radius = 150
			origin = projectile.GetOrigin()
			damage = 5000
			DmgType = DMG_ENERGYBEAM|DMG_BLAST
			// killicon = "krampus_ranged"

			sound = "weapons/barret_arm_fizzle.wav"
			particle = "drg_cow_explosioncore_charged"
			SoundRadius = 50
		})
	}, 
	function(...) {
	})

	local ReflectedRoll = 
	// Roll( (1.0/30.0), [victim, projectile], 
	Roll( (1.0), [victim, projectile], 
	function(victim, projectile) {
		printl("Projectile Got Deflected!")
		projectile.SetForwardVector((projectile.GetForwardVector() * -1) + MATH.RandomVec(-0.1, 0.1))
		RunWithDelay(THREE_TICKS, @() SetProjectileSpeed(projectile))
		RunWithDelay(THREE_TICKS, @() SetProjectileOwner(projectile, victim))
	}, 
	function(...) {
		// printl("Projectile failed to penetrate")
	})

	if (!ReflectedRoll && (ExplodeRoll || PenetrateRoll))
	{
		EntFireNew(projectile, "DispatchEffect", "ParticleEffectStop", 0)
		EntFireNew(projectile, "Kill", "", 0.05)
	}
}

::REFLECT_TO_ENEMY <- 1

function SetProjectileOwner(projectile, owner)
{
	if(REFLECT_TO_ENEMY)
	{
		if(projectile.IsValid())
		{
			projectile.SetAbsOrigin(owner.GetCenter())
			local target = GetClosestPlayer(projectile, owner.GetTeam(), 1)

			projectile.SetForwardVector((target.GetCenter() - owner.GetCenter()).Normalize())
			projectile.SetAbsVelocity(projectile.GetForwardVector() * 600)
		}
	}
	else
	{
		if(projectile.IsValid() && IsValidPlayer(owner))
		{
			projectile.SetForwardVector((projectile.GetForwardVector() * -1) + MATH.RandomVec(-0.1, 0.1))
			projectile.SetOwner(owner)
			projectile.SetTeam(owner.GetTeam())
			projectile.DispatchSpawn()
			GetScope(projectile).ReflectedDmgMult <- 0.333
		}
	}
	
}
function SetProjectileSpeed(projectile)
{
	if(projectile.IsValid())
		projectile.SetAbsVelocity(projectile.GetAbsVelocity() * 0.5)
}


/* 
function CreateBaseExplosion(table: table)
Creates a base explosion to use

@param table —

Input table
owner: CTFPlayer		// The player to report the damage to.
weapon: CTFWeaponBase|null 	// The weapon to give credit to. (Default: null)
ignores: [CBaseEntity]		// The Entitys to ignore for the explosion (usually the victim). (Default: [])
sound: string			// The sound to play on explosion. (Default: "")
radius: float			// The radius of the explosion. (Default: 147.0)
origin: Vector			// The origin of the explosion. (Default: Vector(0, 0, 0))
damage: float			// The damage dealt at the center. (Default: 90.0)
MinDamage: float		// The damage dealt at the edge. (Default: damage/2.0)
DamageDeadzone: float		// The radius from the center where zero falloff occurs. (Default: 0.0)
particle: string		// The explosion particle. (Default: "")
particle_ang: Vector		// The angle of the explosion particle. (Default: QAngle(-90, 0, 0))
particle_offset: Vector		// How much to offset the explosion particle spawn. (Default: Vector(0, 0, 0))
DmgType: integer		// The damage types to use (add DMG_RADIUS_MAX to ignore damage falloff). (Default: DMG_GENERIC|DMG_BLAST)
DmgCustom: integer		// The custom damage type to use.
SoundRadius: float		// The radius the sound travels. (Default: radius)
SoundDelay: float		// Cooldown between explosion sounds. (Default: 0.5)
ExplodeFunc: function		// Callback function for players hit. ( Default: null )
FuncBeforeDmg: bool		// If true, call ExplodeFunc before dealing damage. (Default: false)
FuncOnIgnore: bool		// If true, call ExplodeFunc on ignored targets. (Default: false)
OnlyPlayers: bool		// If true, only collect players to attack. (Default: false)
FuncIgnoreObjects: bool		// If true, ignore non-players when calling ExplodeFunc. (Default: false)
kill_icon: string		// Override the kill icon in killfeed, forces DmgCustom to 0 (Default: "")
 */
