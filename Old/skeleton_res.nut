IncludeScript("fatcat_library")

::spooky <- {
    function OnScriptHook_OnTakeDamage(params)
    {
        if(params.damage <= 5.00) return

        if (params.const_entity.GetClassname() == "tf_zombie" && params.const_entity.GetTeam() == 2 && FindByClassname(null, "tf_objective_resource").GetScriptScope().bBossWave == false)
            params.damage = 5
    }
    function OnGameEvent_mvm_begin_wave(params)
    {
        local resource = FindByClassname(null, "tf_objective_resource")
        resource.ValidateScriptScope()
        local scope = resource.GetScriptScope()
        scope.bBossWave <- false

        if(NetProps.GetPropString(resource, "m_iszMvMPopfileName") == "Final Fortress" && params.wave_index == 10)
            scope.bBossWave <- true
    }
}
__CollectGameEventCallbacks(spooky)
