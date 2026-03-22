::damage <- {
	function OnScriptHook_OnTakeDamage(params)
	{
		if(!params.const_entity.IsPlayer())
			return
		if(params.attacker)
			if(!params.attacker.IsPlayer())
				return

		local victim = params.const_entity
		local attacker = params.attacker

		if(attacker == null) return

		if(Convars.GetBool("mp_friendlyfire") == false)
		{
			if(victim.GetTeam() == attacker.GetTeam()) return
		}
		if(NetProps.GetPropInt(victim, "m_LastHitGroup") != Constants.EHitGroup.HITGROUP_HEAD) return
		NetProps.SetPropInt(victim, "m_LastHitGroup", 0)

		params.weapon.AddAttribute("crit_dmg_falloff", 1, 0)
		params.damage_type = params.damage_type + Constants.FDmgType.DMG_ACID
		// params.damage_stats = Constants.ETFDmgCustom.TF_DMG_CUSTOM_HEADSHOT
	}
	function OnGameEvent_player_hurt(params)
	{
		local player = GetPlayerFromUserID(params.attacker)
		local weapon = player.GetActiveWeapon()
		if (NetProps.GetPropInt(weapon, "m_AttributeManager.m_Item.m_iItemDefinitionIndex") != 61 ||
			NetProps.GetPropInt(weapon, "m_AttributeManager.m_Item.m_iItemDefinitionIndex") != 1006 )
		{
			weapon.RemoveAttribute("crit_dmg_falloff")
		}
	}
}

__CollectGameEventCallbacks(damage)