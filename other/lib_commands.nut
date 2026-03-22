IncludeScript("fatcat_library")

const TEXT_START = "!"

::talk <- {
	function OnGameEvent_player_say(params)
	{
		local player = GetPlayerFromUserID(params.userid)

		local text = split(params.text, "|")
		switch (text[0])
		{
			case TEXT_START + "SetCvar":
			{
				SetCvar(text[1], text[2].tointeger(), text.len() > 3 ? text[3] : false, text.len() > 4 ? text[4] : false)
				break
			}
			case TEXT_START + "CreateTestTank":
			{
				CreateTestTank(text[1], text[2])
				break
			}
			case TEXT_START + "SetCond":
			{
				// if

				player.AddCondEx(text[1].tointeger(), text.len() > 2 ? text[2].tointeger() : 5, player)
				break
			}
			case TEXT_START + "SetSettings":
			{
				// {KillWatchViewmodels = false, KillSoulPacks = false}
				printl(format("%s <- %s", text[1], text[2]))
				// PrintTable({}.text[1] <- text[2])
				// SetLibrarySettings({}[text[1]] = text[2])
				break
			}
		}
	}
}
__CollectGameEventCallbacks(talk)