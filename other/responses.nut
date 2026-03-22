IncludeScript("fatcat_library")

const text_item_color = "\x07FC38AA"
const text_body_color = "\x07FFB0FF"
const text_denial_color = "\x07FF0000"

// Would've played "heck no" via player.EmitSound when using RTD but it was audible everywhere
// PrecacheSound("vo/engineer_no03.mp3")

::responses <-{

    function OnGameEvent_player_say(params)
	{
		local player = GetPlayerFromUserID(params.userid)

		local msg = "params.text"

		switch (params.text)
		{
      		case "/rtd":
            case "!rtd":
            case "rtd": {player.PrintToChat(text_denial_color + "No."); break}
            case "/rtv":
            case "!rtv":
            case "rtv": {player.PrintToChat(text_body_color + "Use " + text_item_color + "/votemenu" + text_body_color + " to change map."); break}
            case "/buy":
            case "!buy":
            case "/shop":
            case "!shop": {player.PrintToChat(text_body_color + "There is no shop. All item stats are preset.\nSee " + text_item_color + "/motd" + text_body_color + " for more info."); break}
            case "/upgrade":
            case "!upgrade":
            case "/upgrades":
            case "!upgrades": {player.PrintToChat(text_body_color + "There are no upgrades. All item stats are preset.\nSee " + text_item_color + "/motd" + text_body_color + " for more info."); break}
            case "/help":
            case "!help": {player.PrintToChat(text_item_color + "/itemlist" + text_body_color + " : View a spreadsheet detailing item stats.\n" + text_item_color + "/votemenu" + text_body_color + " : Change map or gamemode.\n" + text_item_color + "/shape [classname]" + text_body_color + " : Force instant class change during wave."); break}

            // Placeholder secret inputs for special functions
            case "√": {player.PrintToChat(text_denial_color + "Secret placeholder function here ALT507"); break}
            case "═": {player.PrintToChat(text_denial_color + "Secret placeholder function here ALT205"); break}
            case "XXXXXXXEFEFEF!obliterate": {player.PrintToChat(text_denial_color + "Placeholder function ULTIMATE"); break}
            case "XXXXXXXEFEFEF!obliterate": {player.PrintToChat(text_denial_color + "Placeholder function ULTIMATE"); break}
		}
	}
}
__CollectGameEventCallbacks(responses)