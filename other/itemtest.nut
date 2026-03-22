IncludeScript("fatcat_library")
/* ::event <- {
	function OnGameEvent_player_death(params)
	{
		EntFireByHandle(GetPlayerFromUserID(params.userid), "RunScriptCode", "self.ForceRespawn()", 0.1, null, null)
	}
} */
::event <- { function OnGameEvent_player_death(params) {EntFireByHandle(GetPlayerFromUserID(params.userid), "RunScriptCode", "self.ForceRespawn()", 0.1, null, null)}}
__CollectGameEventCallbacks(event)