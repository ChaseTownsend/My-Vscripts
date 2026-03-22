IncludeScript("fatcat_library")
local vscript_header ="\x07FFFF00[VS]\x01 "

local config = FileToString("VscriptAdmins.txt")
if( config == null )
	error("Warning No file named \"VscriptAdmins.txt\" in \"tf/scriptdata/\"\n")

local admins = split(config, "\n")

local command_identifier = "@"

local command = 0
local target = 1
local param = 2

::main <- {
	function OnGameEvent_post_inventory_application(params)
	{
		local player = GetPlayerFromUserID(params.userid)
	}
	function OnGameEvent_player_say(params)
	{
		local player = GetPlayerFromUserID(params.userid)
		local text = split(params.text, " ")

		if(text.len() > 3)
			return

		if(text[command] == (command_identifier + "noclip"))
		{
			if( !player.GetSteamID() in admins )
			{
				ClientPrint(player, 3, "You Do not have @noclip permissions")
				return
			}
			if(text[target] == "@me")
			{
				switch (player.GetMoveType())
				{
					case 2:
					{
						player.SetMoveType(8, 0)
						player.PrintToChat(vscript_header + "noclip ON")
						PrintToChatAllFilter(vscript_header + "Enabled Noclip for " + player.GetUserName(), [player])
						return
					}
					case 8:
					{
						player.SetMoveType(2, 0)
						player.PrintToChat(vscript_header + "noclip OFF")
						PrintToChatAllFilter(vscript_header + "Disabled Noclip for " + player.GetUserName(), [player])
						return
					}
				}
			}
			else if(text[target] == "@red")
			{
				if(text[param] == "on")
				{
					PrintToChatAll(vscript_header + "Enabled Noclip for Red")
					foreach (player2 in GetEveryPlayerOnTeam(TF_TEAM_RED))
					{
						player2.SetMoveType(8, 0)
						player2.PrintToChat(vscript_header + player.GetUserName() + "Enabled Noclip on You")
					}
				}
				if(text[param] == "off")
				{
					PrintToChatAll(vscript_header + "Disabled Noclip for Red")
					foreach (player2 in GetEveryPlayerOnTeam(TF_TEAM_RED))
					{
						player2.SetMoveType(8, 0)
						player2.PrintToChat(vscript_header + player.GetUserName() + "Enabled Noclip on You")
					}
				}
			}
			else if(text[target] == "@blu")
			{
				if(text[param] == "on")
				{
					PrintToChatAll(vscript_header + "Enabled Noclip for Blu")
					foreach (player2 in GetEveryPlayerOnTeam(TF_TEAM_BLUE))
					{
						player2.SetMoveType(8, 0)
						player2.PrintToChat(vscript_header + player.GetUserName() + "Enabled Noclip on You")
					}
				}
				if(text[param] == "off")
				{
					PrintToChatAll(vscript_header + "Disabled Noclip for Blu")
					foreach (player2 in GetEveryPlayerOnTeam(TF_TEAM_BLUE))
					{
						player2.SetMoveType(8, 0)
						player2.PrintToChat(vscript_header + player.GetUserName() + "Enabled Noclip on You")
					}
				}
			}
			else if(text[target] == "@all")
			{
				if(text[param] == "on")
				{
					PrintToChatAll(vscript_header + "Enabled Noclip for All")
					foreach (player2 in GetEveryPlayer())
					{
						player2.SetMoveType(8, 0)
						player2.PrintToChat(vscript_header + player.GetUserName() + "Enabled Noclip on You")
					}
				}
				if(text[param] == "off")
				{
					PrintToChatAll(vscript_header + "Disabled Noclip for All")
					foreach (player2 in GetEveryPlayer())
					{
						player2.SetMoveType(8, 0)
						player2.PrintToChat(vscript_header + player.GetUserName() + "Enabled Noclip on You")
					}
				}
			}
			else
			{
				local targ = FindPlayerByMethod()
			}
		}

		/* switch (text[0])
		{
			case "@noclip":
			{
				if(!player.IsAdmin())
				{
					ClientPrint(player, 3, "You Do not have @noclip permissions")
					return
				}
				switch (player.GetMoveType())
				{
					case 2:
					{
						player.SetMoveType(8, 0)
						player.PrintToChat(vscript_header + "noclip ON")
						PrintToChatAllFilter(vscript_header + "Enabled Noclip for " + player.GetUserName(), [player])
						return
					}
					case 8:
					{
						player.SetMoveType(2, 0)
						player.PrintToChat(vscript_header + "noclip OFF")
						PrintToChatAllFilter(vscript_header + "Disabled Noclip for " + player.GetUserName(), [player])
						return
					}
				}
			}
		} */

		switch (text) {
			case "@noclip":
			{
				if(!player.IsAdmin())
				{
					ClientPrint(player, 3, "You Do not have @noclip permissions")
					return
				}
				switch (player.GetMoveType())
				{
					case 2:
					{
						player.SetMoveType(8, 0)
						player.PrintToChat(vscript_header + "noclip ON")
						PrintToChatAllFilter(vscript_header + "Enabled Noclip for " + player.GetUserName(), [player])
						return
					}
					case 8:
					{
						player.SetMoveType(2, 0)
						player.PrintToChat(vscript_header + "noclip OFF")
						PrintToChatAllFilter(vscript_header + "Disabled Noclip for " + player.GetUserName(), [player])
						return
					}
				}
			}
			case "@help":
			{
				player.PrintToChat
				ClientPrint(player, 3, "The List of Available commands is : \n@help \n@noclip")
				return
			}
			case "":
			{

			}
		}
	}
}
__CollectGameEventCallbacks(main)