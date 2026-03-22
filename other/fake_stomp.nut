IncludeScript("fatcat_library")

::stomp <- {
	function OnScriptHook_OnTakeDamage(params)
	{
		if(!MATH.BitWise(params.damage_type, DMG_FALL))
			return;
		local victim = params.const_entity

		if(params.attacker != Entities.First())
			return;
		
		return
		if(victim.GetGroundEntity() && victim.GetGroundEntity().IsPlayer())
		{
			local hOther = victim.GetGroundEntity()
			// local weapon = attacker.GetWeaponInSlotNew(SLOT_SECONDARY)
			local weapon = victim.GetActiveWeapon()
			// local flFallingDamageMult = weapon.GetAttribute("boots falling stomp", 0)
			local flFallingDamageMult = 3
			if (flFallingDamageMult <= 0)
			{
				return;
			}
			local flStompDamage = 10 + (flFallingDamageMult * fabs(victim.GetFallingVelocity() / (10.0/3.0)))
			victim.PrintToHud(flStompDamage)
			
			hOther.TakeDamageCustom(null, victim, weapon, Vector(0, 0, 1), victim.GetOrigin(), flStompDamage, DMG_GENERIC, TF_DMG_CUSTOM_BOOTS_STOMP)
			params.damage = 0 
			ScreenShake( hOther.GetOrigin(), 15.0, 150.0, 1.0, 500, 0, false);
			
			victim.StopSound("Weapon_Mantreads.Impact")
			victim.StopSound("Player.FallDamageDealt")
			EmitSoundEx({
				sound_name = "Weapon_Mantreads.Impact"
				sound_level = MATH.ConvertRadiusToSndLvl(2500)
				entity = victim
				origin = victim.GetOrigin()
			})
			EmitSoundEx({
				sound_name = "Player.FallDamageDealt"
				sound_level = MATH.ConvertRadiusToSndLvl(2500)
				entity = victim
				origin = victim.GetOrigin()
			})
		}
	}
}
__CollectGameEventCallbacks(stomp)