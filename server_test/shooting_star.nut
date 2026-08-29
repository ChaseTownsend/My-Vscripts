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
			weapon.AddAttribute("Projectile speed increased", 2 + percentage, 0)

			if(!self.InCond(TF_COND_ZOOMED))
				return 0.1

			local scope = GetScope(weapon)
			scope.WeaponDamageMult <- pow(percentage+1, 3)

			weapon.AddAttribute("projectile gravity",  800 + (percentage * 800.0), 0)

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
				return 0.5
			}

			return -1

			// self.PrintToHudF("Charging %%: %f %%", weapon.GetChargePercent() * 100.0)
		}, 
		"ShootingStarThink")
	}

	function OnScriptEvent_PostTakeDamageBot(params)
	{
		PrintTable(params)
		printl(params.weapon.GetChargePercent())
	}
}
__CollectGameEventCallbacks(Shooting_star)
