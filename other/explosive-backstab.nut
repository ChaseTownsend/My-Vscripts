IncludeScript("fatcat_library")

local base_range = 160
local additive_range = 20
local base_damage = 3125

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
        local flDmg = (iExplosiveShot * base_damage / 1.25)
        // 1 * 3125 = 3125 / 1.25 = 2500
		// 2 * 3125 = 6250 / 1.25 = 5000
		// 3 * 3125 = 9375 / 1.25 = 7500

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