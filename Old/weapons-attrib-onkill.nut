local TF_WEAPON_TOMISLAV = 424
::attribute_on_kill <- {

    function OnGameEvent_player_death(params)
    {
        if(params.attacker == null) return
        local player = GetPlayerFromUserID(params.attacker)
        if (!player || player == null || IsPlayerABot(player)) return
        if (GetPlayerFromUserID(params.userid) == player) return // stop if the player who died is the same as the killer
        local kill_weapon_idx = params.weapon_def_index
        local player_weps =
        {
            [1] = NetProps.GetPropEntityArray(player, "m_hMyWeapons", 0),
            [2] = NetProps.GetPropEntityArray(player, "m_hMyWeapons", 1),
            [3] = NetProps.GetPropEntityArray(player, "m_hMyWeapons", 2),
        }
        for (local i = 1; i <= 3 ; i++)
        {
            local weapon_idx = NetProps.GetPropInt(player_weps[i], "m_AttributeManager.m_Item.m_iItemDefinitionIndex")
            if (weapon_idx == null) continue
            switch (weapon_idx) {
                case TF_WEAPON_TOMISLAV:
                    if (kill_weapon_idx != TF_WEAPON_TOMISLAV) continue

                    local kill_streak = params.kill_streak_wep // Get killstreak here so weapons without a killstreak wont cause errors

                    // ONLY CHANGE THESE, or something might break
                    local attribute_name = "damage bonus" ///////////////////////////////////////////////////////////////////////////////
                    local attribute_add = 0.1

                    // PLEASE FOR MY SAKE DO THE CORRECT STARTING VALUE
                    local starting_value = 1

                    // If not using one, then set it really high
                    local Max_value = 1000
                    local Min_value = 1

                    // Only remove thise if statements if needed
                    //if ((starting_value + (kill_streak * attribute_add)) < 0 ) continue // Prevents negative attributes

                    // Never edit these
                    local end_val = (starting_value + (kill_streak * attribute_add))

                    if (end_val <= Max_value || end_val >= Min_value )
                    {
                        player_weps[i].AddAttribute(attribute_name, end_val, 0)
                    }
                    if(end_val > Max_value)
                    {
                        local val = end_val
                        player_weps[i].RemoveAttribute(attribute_name)
                        player_weps[i].AddAttribute(attribute_name, Max_value, 0)
                    }
                    if(end_val < Min_value)
                    {
                        local val = end_val
                        player_weps[i].RemoveAttribute(attribute_name)
                        player_weps[i].AddAttribute(attribute_name, Min_value, 0)
                    }
                case TF_WEAPON_TOMISLAV:
                    if (kill_weapon_idx != TF_WEAPON_TOMISLAV) continue

                    local kill_streak = params.kill_streak_wep

                    // ONLY CHANGE THESE, or something might break
                    local attribute_name = "fire rate bonus" ///////////////////////////////////////////////////////////////////////////////
                    local attribute_add = -0.005

                    // PLEASE FOR MY SAKE DO THE CORRECT STARTING VALUE
                    local starting_value = 1

                    // If not using one, then set it really high
                    local Max_value = 1
                    local Min_value = 0

                    // Only remove thise if statements if needed
                    //if ((starting_value + (kill_streak * attribute_add)) < 0 ) continue // Prevents negative attributes

                    // Never edit these
                    local end_val = (starting_value + (kill_streak * attribute_add))

                    if (end_val <= Max_value || end_val >= Min_value )
                    {
                        player_weps[i].AddAttribute(attribute_name, end_val, 0)
                    }
                    if(end_val > Max_value)
                    {
                        local val = end_val
                        player_weps[i].RemoveAttribute(attribute_name)
                        player_weps[i].AddAttribute(attribute_name, Max_value, 0)
                    }
                    if(end_val < Min_value)
                    {
                        local val = end_val
                        player_weps[i].RemoveAttribute(attribute_name)
                        player_weps[i].AddAttribute(attribute_name, Min_value, 0)
                    }
                case TF_WEAPON_TOMISLAV:
                    if (kill_weapon_idx != TF_WEAPON_TOMISLAV) continue

                    local kill_streak = params.kill_streak_wep

                    // ONLY CHANGE THESE, or something might break
                    local attribute_name = "max health additive bonus" ///////////////////////////////////////////////////////////////////////////////
                    local attribute_add = 15

                    // PLEASE FOR MY SAKE DO THE CORRECT STARTING VALUE
                    local starting_value = 0

                    // If not using one, then set it really high
                    local Max_value = 100000
                    local Min_value = 0

                    // Only remove thise if statements if needed
                    //if ((starting_value + (kill_streak * attribute_add)) < 0 ) continue // Prevents negative attributes

                    // Never edit these
                    local end_val = (starting_value + (kill_streak * attribute_add))

                    if (end_val <= Max_value || end_val >= Min_value )
                    {
                        player_weps[i].AddAttribute(attribute_name, end_val, 0)
                    }
                    if(end_val > Max_value)
                    {
                        local val = end_val
                        player_weps[i].RemoveAttribute(attribute_name)
                        player_weps[i].AddAttribute(attribute_name, Max_value, 0)
                    }
                    if(end_val < Min_value)
                    {
                        local val = end_val
                        player_weps[i].RemoveAttribute(attribute_name)
                        player_weps[i].AddAttribute(attribute_name, Min_value, 0)
                    }
                case TF_WEAPON_TOMISLAV:
                    if (kill_weapon_idx != TF_WEAPON_TOMISLAV) continue

                    local kill_streak = params.kill_streak_wep

                    // ONLY CHANGE THESE, or something might break
                    local attribute_name = "maxammo primary increased" ///////////////////////////////////////////////////////////////////////////////
                    local attribute_add = 0.01

                    // PLEASE FOR MY SAKE DO THE CORRECT STARTING VALUE
                    local starting_value = 1

                    // If not using one, then set it really high
                    local Max_value = 1000
                    local Min_value = 1

                    // Only remove thise if statements if needed
                    //if ((starting_value + (kill_streak * attribute_add)) < 0 ) continue // Prevents negative attributes

                    // Never edit these
                    local end_val = (starting_value + (kill_streak * attribute_add))

                    if (end_val <= Max_value || end_val >= Min_value )
                    {
                        player_weps[i].AddAttribute(attribute_name, end_val, 0)
                    }
                    if(end_val > Max_value)
                    {
                        local val = end_val
                        player_weps[i].RemoveAttribute(attribute_name)
                        player_weps[i].AddAttribute(attribute_name, Max_value, 0)
                    }
                    if(end_val < Min_value)
                    {
                        local val = end_val
                        player_weps[i].RemoveAttribute(attribute_name)
                        player_weps[i].AddAttribute(attribute_name, Min_value, 0)
                    }
                case TF_WEAPON_TOMISLAV:
                    if (kill_weapon_idx != TF_WEAPON_TOMISLAV) continue

                    local kill_streak = params.kill_streak_wep
                    // ONLY CHANGE THESE, or something might break
                    local attribute_name = "restore health on kill" ///////////////////////////////////////////////////////////////////////////////
                    local attribute_add = 0.5

                    // PLEASE FOR MY SAKE DO THE CORRECT STARTING VALUE
                    local starting_value = 0

                    // If not using one, then set it really high
                    local Max_value = 100
                    local Min_value = 0

                    // Only remove thise if statements if needed
                    //if ((starting_value + (kill_streak * attribute_add)) < 0 ) continue // Prevents negative attributes

                    // Never edit these
                    local end_val = (starting_value + (kill_streak * attribute_add))

                    if (end_val <= Max_value || end_val >= Min_value )
                    {
                        player_weps[i].AddAttribute(attribute_name, end_val, 0)
                    }
                    if(end_val > Max_value)
                    {
                        local val = end_val
                        player_weps[i].RemoveAttribute(attribute_name)
                        player_weps[i].AddAttribute(attribute_name, Max_value, 0)
                    }
                    if(end_val < Min_value)
                    {
                        local val = end_val
                        player_weps[i].RemoveAttribute(attribute_name)
                        player_weps[i].AddAttribute(attribute_name, Min_value, 0)
                    }
                case TF_WEAPON_TOMISLAV:
                    if (kill_weapon_idx != TF_WEAPON_TOMISLAV) continue

                    local kill_streak = params.kill_streak_wep

                    // ONLY CHANGE THESE, or something might break
                    local attribute_name = "minigun spinup time decreased" ///////////////////////////////////////////////////////////////////////////////
                    local attribute_add = -0.01

                    // PLEASE FOR MY SAKE DO THE CORRECT STARTING VALUE
                    local starting_value = 1

                    // If not using one, then set it really high
                    local Max_value = 1
                    local Min_value = 0

                    // Only remove thise if statements if needed
                    //if ((starting_value + (kill_streak * attribute_add)) < 0 ) continue // Prevents negative attributes

                    // Never edit these
                    local end_val = (starting_value + (kill_streak * attribute_add))

                    if (end_val <= Max_value || end_val >= Min_value )
                    {
                        player_weps[i].AddAttribute(attribute_name, end_val, 0)
                    }
                    if(end_val > Max_value)
                    {
                        local val = end_val
                        player_weps[i].RemoveAttribute(attribute_name)
                        player_weps[i].AddAttribute(attribute_name, Max_value, 0)
                    }
                    if(end_val < Min_value)
                    {
                        local val = end_val
                        player_weps[i].RemoveAttribute(attribute_name)
                        player_weps[i].AddAttribute(attribute_name, Min_value, 0)
                    }
                case TF_WEAPON_TOMISLAV:
                    if (kill_weapon_idx != TF_WEAPON_TOMISLAV) continue

                    local kill_streak = params.kill_streak_wep

                    // ONLY CHANGE THESE, or something might break
                    local attribute_name = "weapon spread bonus" ///////////////////////////////////////////////////////////////////////////////
                    local attribute_add = -0.005

                    // PLEASE FOR MY SAKE DO THE CORRECT STARTING VALUE
                    local starting_value = 1

                    // If not using one, then set it really high
                    local Max_value = 1
                    local Min_value = 0

                    // Only remove thise if statements if needed
                    //if ((starting_value + (kill_streak * attribute_add)) < 0 ) continue // Prevents negative attributes

                    // Never edit these
                    local end_val = (starting_value + (kill_streak * attribute_add))

                    if (end_val <= Max_value || end_val >= Min_value )
                    {
                        player_weps[i].AddAttribute(attribute_name, end_val, 0)
                    }
                    if(end_val > Max_value)
                    {
                        local val = end_val
                        player_weps[i].RemoveAttribute(attribute_name)
                        player_weps[i].AddAttribute(attribute_name, Max_value, 0)
                    }
                    if(end_val < Min_value)
                    {
                        local val = end_val
                        player_weps[i].RemoveAttribute(attribute_name)
                        player_weps[i].AddAttribute(attribute_name, Min_value, 0)
                    }
                case TF_WEAPON_TOMISLAV:
                    if (kill_weapon_idx != TF_WEAPON_TOMISLAV) continue

                    local kill_streak = params.kill_streak_wep

                    // ONLY CHANGE THESE, or something might break
                    local attribute_name = "damage bonus HIDDEN" ///////////////////////////////////////////////////////////////////////////////
                    local attribute_add = -0.01

                    // PLEASE FOR MY SAKE DO THE CORRECT STARTING VALUE
                    local starting_value = 10

                    // If not using one, then set it really high
                    local Max_value = 10
                    local Min_value = 1

                    // Only remove thise if statements if needed
                    //if ((starting_value + (kill_streak * attribute_add)) < 0 ) continue // Prevents negative attributes

                    // Never edit these
                    local end_val = (starting_value + (kill_streak * attribute_add))

                    if (end_val <= Max_value || end_val >= Min_value )
                    {
                        player_weps[i].AddAttribute(attribute_name, end_val, 0)
                    }
                    if(end_val > Max_value)
                    {
                        local val = end_val
                        player_weps[i].RemoveAttribute(attribute_name)
                        player_weps[i].AddAttribute(attribute_name, Max_value, 0)
                    }
                    if(end_val < Min_value)
                    {
                        local val = end_val
                        player_weps[i].RemoveAttribute(attribute_name)
                        player_weps[i].AddAttribute(attribute_name, Min_value, 0)
                    }
                case TF_WEAPON_TOMISLAV:
                    if (kill_weapon_idx != TF_WEAPON_TOMISLAV) continue

                    local kill_streak = params.kill_streak_wep

                    // ONLY CHANGE THESE, or something might break
                    local attribute_name = "dmg taken increased" ///////////////////////////////////////////////////////////////////////////////
                    local attribute_add = 0.05

                    // PLEASE FOR MY SAKE DO THE CORRECT STARTING VALUE
                    local starting_value = 1

                    // If not using one, then set it really high
                    local Max_value = 1000
                    local Min_value = 1

                    // Only remove thise if statements if needed
                    //if ((starting_value + (kill_streak * attribute_add)) < 0 ) continue // Prevents negative attributes

                    // Never edit these
                    local end_val = (starting_value + (kill_streak * attribute_add))

                    if (end_val <= Max_value || end_val >= Min_value )
                    {
                        player_weps[i].AddAttribute(attribute_name, end_val, 0)
                    }
                    if(end_val > Max_value)
                    {
                        local val = end_val
                        player_weps[i].RemoveAttribute(attribute_name)
                        player_weps[i].AddAttribute(attribute_name, Max_value, 0)
                    }
                    if(end_val < Min_value)
                    {
                        local val = end_val
                        player_weps[i].RemoveAttribute(attribute_name)
                        player_weps[i].AddAttribute(attribute_name, Min_value, 0)
                    }
                    case TF_WEAPON_TOMISLAV:
                    if (kill_weapon_idx != TF_WEAPON_TOMISLAV) continue

                    if(kill_streak == 50) player_weps[i].AddAttribute("attach particle effect", 3149, 0)
                    if(kill_streak == 100)
                    {
                        player_weps[i].RemoveAttribute("attach particle effect")
                        player_weps[i].AddAttribute("attach particle effect static", 3044, 0)
                    }
                
                    
                default:
                    // nothing :P
            }
        }
    }
    function OnGameEvent_player_spawn(params)
    { 
        local player = GetPlayerFromUserID(params.userid)
        if (!player || player == null || IsPlayerABot(player)) return
        /* local player_weps =
        {
            [1] = NetProps.GetPropEntityArray(player, "m_hMyWeapons", 0),
            [2] = NetProps.GetPropEntityArray(player, "m_hMyWeapons", 1),
            [3] = NetProps.GetPropEntityArray(player, "m_hMyWeapons", 2),
        } */
        local weapon = NetProps.GetPropEntityArray(player, "m_hMyWeapons", 0)
        switch(NetProps.GetPropInt(weapon, "m_AttributeManager.m_Item.m_iItemDefinitionIndex")) {
            case TF_WEAPON_TOMISLAV:
            {
                weapon.RemoveAttribute("damage bonus")
                weapon.RemoveAttribute("fire rate bonus")
                weapon.RemoveAttribute("max health additive bonus")
                weapon.RemoveAttribute("maxammo primary increased")
                weapon.RemoveAttribute("restore health on kill")
                weapon.RemoveAttribute("minigun spinup time decreased")
                weapon.RemoveAttribute("weapon spread bonus")
                weapon.RemoveAttribute("dmg taken increased")
                weapon.RemoveAttribute("damage bonus HIDDEN")
                weapon.RemoveAttribute("attach particle effect")
                weapon.RemoveAttribute("attach particle effect static")
                //
                weapon.AddAttribute("damage bonus", 1, 0)
                weapon.AddAttribute("fire rate bonus", 1, 0)
                weapon.AddAttribute("max health additive bonus", 0, 0)
                weapon.AddAttribute("maxammo primary increased", 1, 0)
                weapon.AddAttribute("restore health on kill", 0, 0)
                weapon.AddAttribute("minigun spinup time decreased", 1, 0)
                weapon.AddAttribute("weapon spread bonus", 1, 0)
                weapon.AddAttribute("damage bonus HIDDEN", 10, 0)
                weapon.AddAttribute("dmg taken increased", 1, 0)
                player.SetHealth(player.GetMaxHealth())
                NetProps.SetPropInt(weapon, "m_iAmmo.00" + weapon.GetPrimaryAmmoType(), 200)
            }
        }
    }
}
__CollectGameEventCallbacks(attribute_on_kill)