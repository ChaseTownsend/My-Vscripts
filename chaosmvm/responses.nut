const text_item_color = "\x07CF5EFF"
const text_body_color = "\x07C6AFED"
const text_denial_color = "\x07FF0000"

AddChatTrigger("rtd", function(player, ...) {
	player.PrintToChat(text_denial_color + "No.")
	player.EmitSoundTo("vo/engineer_no03.mp3")
})

AddChatTrigger("rtv", function(player, ...) {
	player.PrintToChat(text_body_color + "Use " + text_item_color + "/votemenu" + text_body_color + " to change map.")
})
AddChatTrigger(["buy", "shop"], function(player, ...) {
	player.PrintToChat(text_body_color + "There is no shop. All item stats are preset.\nSee " + text_item_color + "/itemlist" + text_body_color + " for more info.")
})
AddChatTrigger(["upgrade", "upgrades"], function(player, ...) {
	player.PrintToChat(text_body_color + "There are no upgrades. All item stats are preset.\nSee " + text_item_color + "/itemlist" + text_body_color + " for more info.")
})
AddChatTrigger(["help", "commands", "cmds"], function(player, ...) {
	player.PrintToChat(text_item_color + "/itemlist \x01 : " + text_body_color + "View a spreadsheet detailing item stats.")
	player.PrintToChat(text_item_color + "/votemenu \x01 : " + text_body_color + "Change map or gamemode.")
	player.PrintToChat(text_item_color + "/class [classname] \x01 : " + text_body_color + "Force instant class change during wave.")
	player.PrintToChat(text_item_color + "/ehp \x01 : " + text_body_color + "Calculate your effective health.")
	player.PrintToChat(text_item_color + "/equip \x01 : " + text_body_color + "Equip a specific item even if you don't own it.")
	player.PrintToChat(text_item_color + "/scoreboard \x01 : " + text_body_color + "Print accurate scores to console.")
	player.PrintToChat("\x07ff5E5E/calladmin \x01 : \x07EDAFAFReport a player or request immediate support with a mission related issue. Abuse of this feature can lead to a ban.")
})
AddChatTrigger("equip", function(player, ...) {
	player.PrintToChat(text_denial_color + "This feature is currently unavailable.")
	player.EmitSoundTo("vo/heavy_no03.mp3")
})
AddChatTrigger(["itemlist", "items", "list", "weapons"], function(player, ...) {
	player.PrintToChat("\x074AA84A== Item Spreadsheet ==\n- - - - - - - - -\n\x0772FF72https://docs.google.com/spreadsheets/d/1wYiDtAFSsNUEfQDWF0BzQf8yHZqD9JsljOSH5vLCivk/htmlview \n\x074AA84A- - - - - - - - -")
})
AddChatTrigger(["updates", "changelog"], function(player, ...) {
	player.PrintToChat("\x07ccbef7The changelog spreadsheet is obsolete.\nSee \x079475fa/discord \x07ccbef7instead.")
})