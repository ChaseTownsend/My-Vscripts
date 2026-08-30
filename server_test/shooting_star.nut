if (!("SetLibraryVersion" in getroottable()) || ("FatCatLibForce" in ROOT && FatCatLibForce == true))
	IncludeScript("fatcat_library")

SetScriptVersion("shooting_star", "1.0.0")

::TF_WEAPON_SHOOTING_STAR <- 30665

RegisterSpawnCallback("tf_projectile_rocket", "Shooting_star", function( entity ) {
	if(entity.GetTeam() == TF_TEAM_PVE_INVADERS)
		return

	local owner = entity.GetOwner()
	if(!IsValidPlayer(owner))
		return

	if(owner.GetActiveWeaponIDX() != TF_WEAPON_SHOOTING_STAR)
		return

	GetScope(entity).DamageMultiplier <- GetScope(owner.GetActiveWeapon()).WeaponDamageMult
	// local angle = entity.GetAbsAngles()
	// local new_ang = QAngle(angle.x, angle.y, RandomInt(-180, 180))
	// entity.SetAbsAngles(new_ang)
	// DebugDrawLine_vCol(entity.GetOrigin(), entity.GetOrigin() + (rand_ang.Forward() * 30), Vector(255), false, 15)

	// printf("Set entity \"%s\"'s dmg Mult to %f", entity.tostring(), GetScope(entity).DamageMultiplier)
})


::Shooting_star <- {
	function OnScriptEvent_player_postspawn(params)
	{
		/** @type {CTFPlayer} */
		local player = params.player

		if(!player.HasWeapon(TF_WEAPON_SHOOTING_STAR))
			return
		
		player.AddThink(function() {
			/** @type {CTFPlayer} */
			local self = self
			if(self.GetActiveWeaponIDX() != TF_WEAPON_SHOOTING_STAR)
				return

			local weapon = self.GetActiveWeapon()
			local percentage = weapon.GetChargePercent()

			// will update even when not zommed
			weapon.AddAttribute("Projectile speed increased", 1 + (percentage * 1.5), 0)

			if(!self.InCond(TF_COND_ZOOMED))
				return 0.1

			local scope = GetScope(weapon)
			scope.WeaponDamageMult <- MATH.Max(pow(1 + (percentage * 2), 3) / 2, 1.0)

			local pitch = self.EyeAngles().x
			local adjustment = 11.0/6.0
			local grav_scale = MATH.Max(( 0.35 * log(abs(pitch) + adjustment) ) + (1 - (0.35 * log(adjustment)) ), 1.0)

			weapon.AddAttribute("projectile gravity",  (600 + (percentage * 600.0)) * grav_scale, 0)

			self.PrintToHudF("Gravity Scale: %0.4f\nDamage Mult: %0.2f", grav_scale, scope.WeaponDamageMult)

			if(!("NextShootTime" in scope))
				scope.NextShootTime <- GetFrameCount()

			if(scope.NextShootTime >= GetFrameCount() || percentage <= 0.1)
				weapon.SetNextAttack(Time() + 0.1)
			else 
			{
				scope.NextShootTime = GetFrameCount() + 1
				if(weapon.GetNextAttack() < Time())
					return 0.1
				
				if(!self.IsPressingButton(IN_ATTACK))
					weapon.SetNextAttack(0.0)
					
				return 0.1
			}

			return -1

			/* 
			if(percentage <= 0.1)
				weapon.SetNextAttack(Time() + 0.1)
			else 
			{
				if(weapon.GetNextAttack() < Time())
					weapon.SetNextAttack(Time() + 0.1)

				if(!self.IsPressingButton(IN_ATTACK)) {
					weapon.SetNextAttack(Time())
					return 0.03
				}
				else {
					return 0.03
				}
			}

			return -1 */

			// self.PrintToHudF("Charging %%: %f %%", weapon.GetChargePercent() * 100.0)
		}, 
		"ShootingStarThink")
	}
}
__CollectGameEventCallbacks(Shooting_star)
