// ::TF_WEAPON_OBJECTOR <- 474
::TF_WEAPON_OBJECTOR <- 0

::events <- {
	function OnGameEvent_HumanDeath(params)
	{
		local attacker = params.attacker
		local victim = params.victim

		if(params.weaponIDX != TF_WEAPON_OBJECTOR)
			return
		
		if(attacker.GetPlayerClass() != victim.GetPlayerClass())
			return

		attacker.CopyWeapon(victim.GetActiveWeapon(), false, true, true, 10, true, true, 2)

	}
	// function OnGameEvent_BotDeath(params)
}
__CollectGameEventCallbacks(events)
