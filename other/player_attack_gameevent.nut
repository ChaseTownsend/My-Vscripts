IncludeScript("fatcat_library")

local Thinker = FindByName(null, "player_attack_event")
if( !Thinker ) SpawnEntityFromTable("info_target", { targetname = "player_attack_event" })
AddThinkToEnt(Thinker, "CheckWeaponFire")

function CheckWeaponFire()
{
	foreach (player in Players)
	{
		foreach (weapon in player.GetAllWeapons())
		{
			if(startswith(weapon.GetClassname(), "tf_wearable"))
				continue
			if(weapon.IsMeleeWeapon())
			{
				if(GetPropInt(player, "m_Shared.m_iNextMeleeCrit") == 0 && player.GetActiveWeapon() == weapon)
				{
					FireAttackEvent([player, weapon, weapon.GetIDX()])
				}
				SetPropInt(player, "m_Shared.m_iNextMeleeCrit", -2)
				continue
			}
			if(weapon.GetClassname() == "tf_weapon_flamethrower")
			{
				if(GetPropBool(GetPropEntity(weapon, "LocalFlameThrowerData.m_hFlameManager"), "m_bIsFiring"))
					FireAttackEvent([player, weapon, weapon.GetIDX()])
				
				continue
			}
			
			local fire_time = GetPropFloat(weapon, "m_flLastFireTime")
			local scope = GetScope(weapon)
			if (fire_time > scope.last_fire_time)
			{
				scope.last_fire_time = fire_time
				FireAttackEvent([player, weapon, weapon.GetIDX()])
			}
		}
	}
	return -1
}

::Attack_events <- {
	function OnGameEvent_post_inventory_application(params)
	{
		local player = GetPlayerFromUserID(params.userid)
		if (!player)
			return

		foreach (weapon in player.GetAllValidWeapons())
		{
			if(weapon.IsMeleeWeapon())
			{
				SetPropInt(player, "m_Shared.m_iNextMeleeCrit", -2)
				continue
			}
			GetScope(weapon).last_fire_time <- Time()
		}
	}
	function OnGameEvent_player_attack(params)
	{
		CreateProjectile({
			owner = params.player
			model = "models/workshop_partner/weapons/c_models/c_sd_cleaver/c_sd_cleaver.mdl"
			thinkfunc = "TestProjThink"
			force = 2000
			distance = 50
			delay = -1
			min = Vector(-20, -20, -20)
    		max = Vector(20, 20, 20)
			lifetime = 0.5
		})
		// params.player.SetAbsVelocity(params.player.GetAbsVelocity() - params.player.EyeAngles().Forward() * 3000.0)
	}
}
__CollectGameEventCallbacks(Attack_events)

function FireAttackEvent(info)
{
	FireGameEvent("player_attack", { 
		player = info[0], 
		weapon = info[1], 
		weapon_idx = info[2], 
	})
}