IncludeScript("fatcat_library")

::Armor_CallBacks <- {
	function OnGameEvent_post_inventory_application(params)
	{
		local player = GetPlayerFromUserID(params.userid)
		local scope = GetScope(player)
		scope.MaxArmor <- (player.GetMaxHealth()/3).tointeger()
		scope.Armor <- scope.MaxArmor
	}
	function OnGameEvent_ammo_pickup(params)
	{
		if((params.total / params.amount).tointeger() == 1.0)
			return
		PrintTable(params)
		printl("")
	}
	function OnScriptHook_OnTakeDamage(params)
	{
		if(!params.const_entity.IsPlayer())
			return

		// PrintTable(params)
		// printl("")

		local victim = params.const_entity

		local damage = params.damage
		local damage_type = params.damage_type
		local dmg_custom = params.damage_stats

		local scope = GetScope(victim)
		local armor_reduc = scope.Armor
	}
}
__CollectGameEventCallbacks(Armor_CallBacks)