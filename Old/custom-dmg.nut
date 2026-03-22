IncludeScript("fatcat_library")

::customdmg <- {
    function OnScriptHook_OnTakeDamage(params)
    {
        local attacker = params.attacker
        local victim = params.const_entity

        if(victim.IsBot()) return
        switch (params.damage_stats)
        {
            case TF_DMG_CUSTOM_BOOTS_STOMP: //STOMP
            {
                if(attacker.GetAbsVelocity().z > 0) break
                params.damage = attacker.GetAbsVelocity().z * -100
                break
            }
            ////// Spells
            case TF_DMG_CUSTOM_KART: //BUMPER CAR
            {
                params.damage = 20000
                if(victim.IsMiniBoss()) return
                victim.AddCondEx(71, 10, attacker)
                victim.AddCondEx(30, 10, attacker)
                break
            }
            case TF_DMG_CUSTOM_SPELL_SKELETON: //SKELETONS
            {
                params.damage = 8500
                if(victim.IsMiniBoss()) return
                victim.AddCondEx(30, 10, params.attacker)
                break
            }
            case TF_DMG_CUSTOM_SPELL_MIRV: //MIRV
            {
                params.damage = 15000
                if(victim.IsMiniBoss()) return
                victim.AddCondEx(30, 10, params.attacker)
                break
            }
            case TF_DMG_CUSTOM_SPELL_METEOR: //METEOR
            {
                params.damage = 3000
                if(victim.IsMiniBoss()) return
                victim.AddCondEx(30, 10, params.attacker)
                break
            }
            case TF_DMG_CUSTOM_SPELL_LIGHTNING: //LIGHTNING
            {
                params.damage = 5000
                break
            }
            case TF_DMG_CUSTOM_SPELL_FIREBALL: //FIREBALL
            {
                params.damage = 15000
                break
            }
            case TF_DMG_CUSTOM_SPELL_MONOCULUS: //MONOCULUS
            {
                params.damage = 12500
                break
            }
            case TF_DMG_CUSTOM_SPELL_BLASTJUMP: //BLAST JUMP
            {
                params.damage = 22500
                victim.AddCondEx(30, 10, params.attacker)
                break
            }
            case TF_DMG_CUSTOM_SPELL_BATS: //BATS
            {
                params.damage = 10000
                break
            }
        }
    }
}
__CollectGameEventCallbacks(customdmg)