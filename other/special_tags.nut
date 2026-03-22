::tagfunctions <- {
	function OnScriptHook_OnTakeDamage(params)
	{
		local victim = params.const_entity
		local attacker = params.inflictor

		if(!victim.IsPlayer())
			return

		if(!attacker.IsPlayer())
			return

		if (IsPlayerABot(victim))
			return

		if (!IsPlayerABot(attacker))
			return

		if(params.damage_custom == 86)
			return

		local tags = {}
		attacker.GetAllBotTags(tags)
		foreach (index, tag in tags)
		{
			printl(index + " : " + tag)
			local split = split(tag, "|")
			switch (split[0])
			{
				case "KillVictimOnHit":
				{
					victim.TakeDamageCustom(attacker, attacker, attacker.GetActiveWeapon(), Vector(), Vector(), 2147483647, 0, 86)
					break
				}
				case "AddCondOnHit":
				{
					victim.AddCondEx(split[1].tointeger(), split[2].tointeger(), attacker)
					break
				}
			}
		}
	}
}

__CollectGameEventCallbacks(tagfunctions)