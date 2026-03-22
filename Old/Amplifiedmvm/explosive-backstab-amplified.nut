IncludeScript("fatcat_library")

local base_range = 150
local additive_range = 75
local base_damage = 150

::Knife_Explosion <- {
	function OnScriptHook_OnTakeDamage(params)
	{
		local hVictim = params.const_entity
		local hAttacker = params.attacker
		local hWeapon = params.weapon

		if ( !hVictim || !hAttacker || !hWeapon )
			return

		if( !hVictim.IsPlayer() || !hAttacker.IsPlayer() )
			return

		if( params.damage_stats != TF_DMG_CUSTOM_BACKSTAB )
			return

		local iExplosiveShot = hWeapon.GetAttribute("explosive sniper shot", 0)
		if( iExplosiveShot == 0)
			return

		local flDmgRange = base_range + (iExplosiveShot * additive_range)
		local flDmg = (base_damage * iExplosiveShot) * (iExplosiveShot / 2 + 0.5)
		// 1 / 2 = 	0.5 + 0.5 = 1.0 mult
		// 2 / 2 = 	1 	+ 0.5 = 1.5 mult
		// 3 / 2 = 	1.5 + 0.5 = 2.0 mult

		local info = {
			owner = hAttacker
			weapon = hWeapon
			center = hVictim.GetOrigin() + Vector(0, 0, 16)
			radius = flDmgRange
			damage = flDmg
			ignore = [hVictim]
			dmg_Type = DMG_BLAST
			sound = "weapons/barret_arm_fizzle.wav"
			particle = "drg_cow_explosioncore_charged"
		}
		CreateKnifeAoETable(info)
	}
}
__CollectGameEventCallbacks(Knife_Explosion)