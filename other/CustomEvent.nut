IncludeScript("fatcat_library")

::NormalEvents <- {
	function OnGameEvent_post_inventory_application(params)
	{
		local player = GetPlayerFromUserID(params.userid)
		if(GetPropBool(player, "m_Shared.m_bInUpgradeZone"))
			SendGlobalGameEvent("player_upgraded", {player = player})
	}
}