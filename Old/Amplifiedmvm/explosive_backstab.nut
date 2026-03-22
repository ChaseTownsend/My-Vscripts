IncludeScript("fatcat_library")

local base_range = 100
local additive_range = 50
local base_damage = 40


::Knife_Explosion <- {
	function OnScriptHook_OnTakeDamage(params)
	{
		local hVictim = params.const_entity
		local hAttacker = params.attacker
		local hWeapon = params.weapon

		if( !hVictim.IsPlayer() )
			return
		
		if( !hAttacker.IsPlayer() )
			return

		if( hWeapon == null )
			return

		if( params.damage_stats != TF_DMG_CUSTOM_BACKSTAB )
			return

		if( params.damage_type & DMG_BLAST )
			return

		local iExplosiveShot = hWeapon.GetAttribute("explosive sniper shot", 0)
		if( iExplosiveShot == 0)
			return

		local flDmgRange = base_range + (iExplosiveShot * additive_range)
		local flDmg = (base_damage * hWeapon.GetAttribute("CARD: damage bonus", 1))

		flDmg *= (iExplosiveShot / 2 + 0.5)
		// 1 / 2 = 	0.5 + 0.5 = 1.0
		// 2 / 2 = 	1 	+ 0.5 = 1.5
		// 3 / 2 = 	1.5 + 0.5 = 2.0

		CreateKnifeAoE(
			hAttacker, 
			hWeapon, 
			hVictim.GetOrigin() + Vector(0, 0, 16), 
			flDmgRange, 
			flDmg, 
			[hVictim]/*,
			DMG_BLAST,
			("weapons/explode" + RandomInt(1, 3) + ".wav"),
			"ExplosionCore_Wall" */)
		// Can modify dmg type, sound, and particle. Below is defaults
		// dmg_Type = DMG_BLAST, sound = ("weapons/explode" + RandomInt(1, 3) + ".wav"), particle = "ExplosionCore_Wall"

		//	it also chooses a random explode#.wav
		//	"sounds/weapons/explode1.wave"
		//	"sounds/weapons/explode2.wave"
		//	"sounds/weapons/explode3.wave"
	}
}
__CollectGameEventCallbacks(Knife_Explosion)