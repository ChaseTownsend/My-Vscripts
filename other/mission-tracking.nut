local player_ids = []
local full_completed_file = FileToString("finished.txt")
local full_completed_ids = split(full_completed_file, ">", true)

::tracking <- {
	function OnGameEvent_player_team(params)
	{
		if(params.team != Constants.ETFTeam.TF_TEAM_PVE_DEFENDERS) return
		local player = GetPlayerFromUserID(params.userid)
		local player_id = GetPlayerSteamID(player)

		if(!(player_id in player_ids))
		{
			player_ids.push(player_id)
		}
	}
	function OnGameEvent_player_disconnect(params)
	{
		if(params.bot) return
		local player = GetPlayerFromUserID(params.userid)
		local player_id = GetPlayerSteamID(player)
		if(player_id in player_ids)
		{
			local index = player_ids.find(player_id)
			player_ids.remove(index)
		}

	}
	function OnGameEvent_mvm_mission_complete(params)
	{
		ClientPrint(null, 3, "Mission Complete Event FIRED")
		local startoffile = "Total People in mission : " + player_ids.len()
		local list = startoffile
		local completed_people = 0
		foreach(id in player_ids)
		{
			local incomlist = false
			foreach (completed_id in full_completed_ids)
			{
				if (strip(completed_id) == id)
				{
					incomlist = true
					completed_people++
					printl("Duplicate ID in SERVER, Not adding to list! " + id)
					break
				}
			}
			if (!incomlist)
			{
				// not in the completed list so add to list
				list = list + "\n" + id
			}
		}
		local endoffile = "Total People who already Completed Mission : " + completed_people + "\nTotal People who have not completed the mission : " + (player_ids.len()-completed_people)
		list = list + "\n" + endoffile

		local MISSION_NAME = params.mission
		time <- {}
		LocalTime(time)
		local FILENAME = time.month + "_" + time.day + "_" + time.year + "_" + time.hour + "-" + time.minute
		StringToFile( MISSION_NAME + "/" + FILENAME + ".txt", list)
	}
}

function GetPlayerSteamID(player)
{
    return NetProps.GetPropString(player, "m_szNetworkIDString")
}

