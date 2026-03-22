local spell_ents =
{
    [1] = "tf_projectile_spellfireball",
    [2] = "tf_projectile_spellbats",
    [3] = "tf_projectile_spellmirv",
    [4] = "tf_projectile_spelltransposeteleport",
    [5] = "tf_projectile_lightningorb",
    [6] = "tf_projectile_spellmeteorshower",
    [7] = "tf_projectile_spellspawnboss",
    [8] = "tf_projectile_spellspawnhorde",
}
function ShootProjectile(player, projectile_type) {
    local angles = player.EyeAngles()

    local projectile = SpawnEntityFromTable(spell_ents[projectile_type], {
        origin = player.EyePosition()
        angles = angles
        //basevelocity = angles.Forward() * 1019.8
        TeamNum = player.GetTeam()
    })
    projectile.SetAbsVelocity(angles.Forward() * 1000)
    projectile.SetOwner(player)
    NetProps.SetPropEntity(projectile, "m_hOriginalLauncher", player)
}

function CheckWeaponFire()
{
	local fire_time = NetProps.GetPropFloat(self, "m_flLastFireTime")
	if (fire_time > last_fire_time)
	{
		local owner = self.GetOwner()
		if (owner)
		{
            /* local player_weps = {
                [1] = NetProps.GetPropEntityArray(owner, "m_hMyWeapons", 0),
                [2] = NetProps.GetPropEntityArray(owner, "m_hMyWeapons", 1),
                [3] = NetProps.GetPropEntityArray(owner, "m_hMyWeapons", 2),
            } */

            local attribute_ammount = NetProps.GetPropEntityArray(owner, "m_hMyWeapons", 0).GetAttribute("override projectile type", 1)
            if (attribute_ammount > 30 && attribute_ammount < 39)
            {
                ShootProjectile(owner, (attribute_ammount - 30))
            }
			//owner.SetAbsVelocity(owner.GetAbsVelocity() - owner.EyeAngles().Forward() * 300.0)
		}

		last_fire_time = fire_time
	}
	return -1
}
::weapon_fire <- {
    function OnGameEvent_player_spawn(params)
    {
        local player = GetPlayerFromUserID(params.userid)
        if (!player)
            return

        for (local i = 0; i < 8; i++)
        {
            local weapon = NetProps.GetPropEntityArray(player, "m_hMyWeapons", i)
            if (weapon == null || weapon.IsMeleeWeapon())
                continue

            weapon.ValidateScriptScope()
            weapon.GetScriptScope().last_fire_time <- 0.0
            weapon.GetScriptScope().CheckWeaponFire <- CheckWeaponFire
            AddThinkToEnt(weapon, "CheckWeaponFire")
        }
    }
}
__CollectGameEventCallbacks(weapon_fire)