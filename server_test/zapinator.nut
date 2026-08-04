if (!("SetLibraryVersion" in getroottable()) || ("FatCatLibForce" in ROOT && FatCatLibForce == true))
	IncludeScript("fatcat_library")

SetScriptVersion("zapinator", "1.0.3")

IncludeScript("chaosmvm/gameplay-applications")


RegisterDamageCallback("player", "ZapinatorPlayer", function( params ) {
	if (HasCustomFlag(params.damage_custom, TF_DMG_CUSTOM_IGNORE_EVENTS) || params.damage_custom == TF_DMG_CUSTOM_TRIGGER_HURT)
		return

	local victim 	= params.victim
	local attacker 	= params.attacker
	local weapon 	= null
	local inflictor	= params.inflictor

	weapon = params.weapon

	if (!attacker || !weapon || !inflictor)
		return
	
	if (inflictor.GetClassname() != "tf_projectile_energy_ring")
		return

	if ( !IsWeaponClass(weapon, "tf_weap", true) || !IsValidPlayer(attacker) )
		return

	if (victim.IsInvincible() || IsPlayerABot(attacker))
		return

	if (!attacker.HasWeapon(30666) || weapon.GetIDX() != 30666)
		return

	// local function GetDebugName( plr )
		// return "( ["+plr.entindex()+"] : " + plr.GetUserName() + " )" 

	// local function PrintLog( m )
		// printf("[%d] : %s\n", GetFrameCount(), m)

	// printf("%s was hit by Laser!\n", GetDebugName(victim))

	local projectile = inflictor
	/** @type {table} */
	local proj_scope = GetScope(projectile)
	if (!("HitRobots" in proj_scope))
		proj_scope.HitRobots <- []

	if (proj_scope.HitRobots.find(victim.entindex()) != null)
	{
		// PrintLog(format("Blocking repeated Hit against %s!", GetDebugName(victim)))
		params.early_out <- true
		return
	}

	if ("Penetrates" in proj_scope)
	{
		// PrintLog(format("Multiplying dmg by %f because of %d penetrations", 1 + (0.25 * proj_scope.Penetrates), proj_scope.Penetrates))
		params.damage *= 1 + (0.25 * proj_scope.Penetrates)
	}

	if (weapon.GetAttribute("bleeding duration", 0) != 0)
		weapon.AddAttribute("bleeding duration", 0, 0)
	if (weapon.GetAttribute("Set DamageType Ignite", 0) != 0)
		weapon.AddAttribute("Set DamageType Ignite", 0, 0)

	if (weapon.GetAttribute("apply look velocity on damage", 0) != 0)
		weapon.AddAttribute("apply look velocity on damage", 0, 0)
	if (weapon.GetAttribute("apply z velocity on damage", 0) != 0)
		weapon.AddAttribute("apply z velocity on damage", 0, 0)


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
	if (rolled <= chance)
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
function ZapinatorHit( victim, attacker, projectile, weapon )
{
	local proj_scope = GetScope(projectile)
	if (!("Penetrates" in proj_scope))
		proj_scope.Penetrates <- 0

	proj_scope.HitRobots.append(victim.entindex())

	if (projectile.GetMoveType() == MOVETYPE_NOCLIP)
	{
		while (proj_scope.HitRobots.len() > 4)
			proj_scope.HitRobots.remove(0)

		HomingProjectile(projectile, victim)
		GetScope(projectile).Penetrates++

		projectile.SetMoveType(MOVETYPE_NOCLIP, MOVECOLLIDE_DEFAULT)
		return // no more rolls
	}

	local DebuffRoll = 
	Roll( 0.25, [victim, attacker, projectile, weapon], 
	function( victim, attacker, projectile, weapon ) {
		// "gas > bleed > slow > jar = mark = milk > 0.5s stun"
		local Debuffs = [
			function( victim, attacker, weapon, ... )
			{
				weapon.AddAttribute("Set DamageType Ignite", 1, 0)
				victim.AddCondEx(TF_COND_GAS, 1.0, attacker)
			},
			function( _1, _2, weapon, ... )
			{
				weapon.AddAttribute("bleeding duration", 12, 0)
			},
			function( victim, attacker, ... )
			{
				victim.AddCondEx(TF_COND_URINE, 15, attacker)
			},
			function( victim, attacker, ... )
			{
				victim.AddCondEx(TF_COND_MAD_MILK, 15, attacker)
				victim.StunPlayer(15.0, 0.35, TF_STUN_MOVEMENT, attacker)
			},
			function( victim, attacker, weapon, ... )
			{
				victim.MakeCorrosion(attacker, weapon)
			},
			function( victim, attacker, ... )
			{
				victim.StunPlayer(victim.IsMiniBoss() ? 2.5 : 5.0, 1, TF_STUN_BOTH, attacker)
			},
		]
		local Debuff_chances = [
			0.40, 
			0.675,
			0.825,
			0.925,
			0.975
		]
		local current_chance = RandomFloat(0, 1)
		local chosen_debuff = 0
		foreach (chance in Debuff_chances)
		{
			// printf("Do we beat chance?  %.02f%% >= %.02f%%\n", current_chance*100.0, chance*100.0)
			if ( current_chance > chance )
			{
				// printf("Increasing Debuff number from %d to %d\n", chosen_debuff, chosen_debuff+1)
				chosen_debuff++
				continue
			}
			break
		}
		// printf("Applied debuff %d\n", chosen_debuff)
		Debuffs[chosen_debuff].acall([this].extend([victim, attacker, weapon, projectile]))
	},
	function( ... ) {
		// printl("Projectile failed to Apply Debuff")
	})

	local KnockbackRoll = 
	Roll( 0.04, [weapon], 
	function( weapon ) {
		weapon.AddAttribute("apply look velocity on damage", 750, 0)
		weapon.AddAttribute("apply z velocity on damage", 400, 0)
	}, 
	function( ... ) {
		// printl("Projectile failed to Apply KB")
	})

	// local PenetrateRoll = 
	// Roll( 0.5, [projectile], 
	// function( projectile ) {
	// 	GetScope(projectile).Penetrates++
	// }, 
	// function( ... ) {
	// 	printl("Projectile failed to penetrate")
	// })

	local ExplodeRoll = 
	Roll( 0.1, [attacker, projectile], 
	function( attacker, projectile ) {
		// printl("Projectile Detonated!")
		CreateBaseExplosion({
			owner = attacker
			weapon = null
			// ignores = [victim]
			radius = 150
			origin = projectile.GetOrigin()
			damage = 10000
			DmgType = DMG_ENERGYBEAM|DMG_BLAST
			// killicon = "krampus_ranged"

			sound = "weapons/barret_arm_fizzle.wav"
			particle = "drg_cow_explosioncore_charged"
			SoundRadius = 50
		})
	}, 
	function( ... ) {
	})

	local ReboundRoll = 
	Roll( 0.15, [victim, projectile], 
	function( victim, projectile ) {
		// printl("Projectile Got Deflected!")

		HomingProjectile(projectile, victim)
		GetScope(projectile).Penetrates++

		projectile.SetMoveType(MOVETYPE_NOCLIP, MOVECOLLIDE_DEFAULT)
	}, 
	function( ... ) {
		// printl("Projectile failed to penetrate")
	})

	if (ExplodeRoll || !ReboundRoll)
	{
		EntFireNew(projectile, "DispatchEffect", "ParticleEffectStop", 0)
		EntFireNew(projectile, "Kill", "", 0.02)
	}
}

::REFLECT_TO_ENEMY <- 1

/** 
 * @type {function}
 * @param {CBaseEntity} projectile
 * @param {CTFPlayer} victim
 */
function HomingProjectile( projectile, victim )
{
	if (REFLECT_TO_ENEMY)
	{
		projectile.SetAbsOrigin(victim.GetCenter())
		local target = GetClosestPlayer(projectile, victim.GetTeam(), 1)

		projectile.SetForwardVector((target.GetCenter() - victim.GetCenter()).Normalize())
		projectile.SetAbsVelocity(projectile.GetForwardVector() * 1000)
		if (projectile.GetMoveType() != MOVETYPE_NOCLIP)
			GetScope(projectile).NoclipHits <- 0
		else if (GetScope(projectile).NoclipHits < 5)
			GetScope(projectile).NoclipHits++

		for (local i = 0; i < GetScope(projectile).NoclipHits; i++)
			projectile.SetAbsVelocity(projectile.GetAbsVelocity() * 0.75)

		if (projectile.GetAbsVelocity().Length() < 500)
			projectile.SetAbsVelocity(projectile.GetForwardVector() * 500)
	}
	else	// rebound back to you
	{
		if (IsValidPlayer(victim))
		{
			projectile.SetForwardVector((projectile.GetForwardVector() * -1) + MATH.RandomVec(-0.1, 0.1))
			projectile.SetOwner(victim)
			projectile.SetTeam(victim.GetTeam())
			projectile.DispatchSpawn()
			GetScope(projectile).ReflectedDmgMult <- 0.333
		}
	}
}