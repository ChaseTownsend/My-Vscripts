IncludeScript("fatcat_library")

::bomb <- {
	function OnScriptHook_OnTakeDamage(params)
	{
		if(params.weapon == null) return
		if(params.attacker == null) return

		if(params.const_entity.GetClassname() != "player") return

		// if(params.damage_stats = 43) return

		CreateAoE(params.attacker, params.const_entity.GetOrigin(), 48, params.max_damage, params.damage, 0)
	}
}
__CollectGameEventCallbacks(bomb)