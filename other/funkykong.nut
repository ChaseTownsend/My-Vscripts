::ROOT <- getroottable()

::say_event <- {
    function OnGameEvent_player_say(params)
    {
        local player = GetPlayerFromUserID(params.userid)
        local text = split(text, " ")
        if(text[0] == "/changemodel" || text[0] == "/model" )
        {
            player.SetCustomModelWithClassAnimations(text[1])
        }
    }
}
__CollectGameEventCallbacks(say_event)