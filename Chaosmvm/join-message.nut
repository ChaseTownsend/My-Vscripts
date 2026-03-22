if(!("SetLibraryVersion" in getroottable()) || ("FatCatLibForce" in ROOT && FatCatLibForce == true))
	IncludeScript("fatcat_library")

SetScriptVersion("join_message", "1.0.1")

::info <- {
    function OnScriptEvent_HumanTeam(params)
        GetScope(params.player).joined <- false

    function OnScriptEvent_HumanSpawn(params)
    {
        local player = params.player
        local scope = GetScope(player)

        if(!("joined" in scope)) return
        if(scope.joined != true)
        {
            player.PrintToChat(" ")
            player.PrintToChat(" ")
            player.PrintToChat(" ")

            player.PrintToChat(format("\x07FF75FF[SERVER]\x01 Hello \x07FC38AA%s", GetPropString(player, "m_szNetname")))
            player.PrintToChat("\x01This is NOT a normal MvM server, though you may have already figured that out. All weapons have been pre-modified with unique functionality, and all enemies buffed to match.")
            player.PrintToChat("\x07FFB0FF► Use \x07FC38AA/itemlist \x07FFB0FFto view more specific stats for each and every item. \x08FFB0FF44(Requires cl_disablehtmlmotd  0)")
            player.PrintToChat("\x07FFB0FF► Want a different challenge? Use \x07FC38AA/votemenu \x07FFB0FFto elect for a different map or gamemode.")
            player.PrintToChat("\x07FFB0FF► Want to change class during a wave? You can! Use\x07FC38AA /shape \n\x08FFB0FF44(Example: /shape engineer)")
            scope.joined = true
        }
    }
}
__CollectGameEventCallbacks(info)