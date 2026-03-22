function TagCheck()
{
	if(self.GetTeam() != TF_TEAM_BLUE) return
	local tags = {}
	self.GetAllBotTags(tags)
	foreach (index, tag in tags)
	{
		local parsed_tag = split(tag, "|")
		if(parsed_tag[0] == "Teleport")
		{
			self.RemoveCondEx(TF_COND_INVULNERABLE_HIDE_UNLESS_DAMAGED, true)
			self.SetAbsOrigin(Vector(parsed_tag[1].tofloat(), parsed_tag[2].tofloat(), parsed_tag[3].tofloat()))
			self.RemoveCondEx(TF_COND_INVULNERABLE_HIDE_UNLESS_DAMAGED, true)
		}
	}
}

::OnSpawn <- {
	function OnGameEvent_player_spawn(params)
	{
		EntFireByHandle(GetPlayerFromUserID(params.userid), "RunScriptCode", "TagCheck()", 0.1, null, null)
		EntFireByHandle(GetPlayerFromUserID(params.userid), "RunScriptCode", "TagCheck()", 0.2, null, null)
		EntFireByHandle(GetPlayerFromUserID(params.userid), "RunScriptCode", "TagCheck()", 0.3, null, null)
		EntFireByHandle(GetPlayerFromUserID(params.userid), "RunScriptCode", "TagCheck()", 0.4, null, null)
	}
	function OnGameEvent_player_death(params)
	{
		EntFireByHandle(GetPlayerFromUserID(params.userid), "RunScriptCode", "self.ForceRegenerateAndRespawn()", 0.25, null, null)
		EntFireByHandle(GetPlayerFromUserID(params.userid), "RunScriptCode", "TagCheck()", 0.3, null, null)
	}
}
__CollectGameEventCallbacks(OnSpawn)