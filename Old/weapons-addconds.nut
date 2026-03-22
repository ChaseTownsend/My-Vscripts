::cond_on_kill <- {
    function OnGameEvent_player_death(params){

        if (params.attacker == null) return
        local player = GetPlayerFromUserID(params.attacker)
        if(!player || IsPlayerABot(player)) return

        switch (params.weapon_def_index) {
            case 574:
            {
                player.AddCondEx(64, 5, player)
                break
            }
        }
    }
}

::cond_on_hit <- {
    function OnScriptHook_OnTakeDamage(params)
    {
        if(params.attacker == null) return
        local player = params.attacker
        if(!player || IsPlayerABot(player)) return

        local Hweapon = params.weapon
        local weapon_idx = NetProps.GetPropInt(Hweapon, "m_AttributeManager.m_Item.m_iItemDefinitionIndex")
        switch (weapon_idx) {
            case 1123:
            {
                player.AddCondEx(82, 20, player)
                player.AddCondEx(73, 20, player)
                player.AddCondEx(51, 20, player)
                player.AddCondEx(36, 60, player)
                player.AddCondEx(75, 0, player)
                break
            }
        }
    }
}
__CollectGameEventCallbacks(cond_on_kill)
__CollectGameEventCallbacks(cond_on_hit)