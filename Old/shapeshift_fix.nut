::shape_fix <- {
	function OnGameEvent_post_inventory_application(params)
	{
		local player = GetPlayerFromUserID(params.userid)
		if(player.GetTeam() != Constants.ETFTeam.TF_TEAM_PVE_DEFENDERS) return

		if(player.GetPlayerClass() == Constants.ETFClass.TF_CLASS_ENGINEER) return

		player.RemoveAllObjects(true)
	}
}
__CollectGameEventCallbacks(shape_fix)