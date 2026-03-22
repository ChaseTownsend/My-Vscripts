function CollectEventsInScope(events)
{
	local events_id = UniqueString()
	getroottable()[events_id] <- events

	foreach (name, callback in events)
		events[name] = callback.bindenv(this)

	local cleanup_user_func, cleanup_event = "OnGameEvent_scorestats_accumulated_update"
	if (cleanup_event in events)
		cleanup_user_func = events[cleanup_event]

	events[cleanup_event] <- function(params)
	{
		if (cleanup_user_func)
			cleanup_user_func(params)

		delete getroottable()[events_id]
	}
	__CollectGameEventCallbacks(events)
}

function CheckWeaponFire()
{
	local fire_time = NetProps.GetPropFloat(self, "m_flLastFireTime")
	local flame_firing = false
	if(self.GetClassname() == "tf_weapon_flamethrower")
	{
		flame_firing = NetProps.GetPropBool(NetProps.GetPropEntity(self, "LocalFlameThrowerData.m_hFlameManager"), "m_bIsFiring")
	}
	if(self == self.GetOwner().GetActiveWeapon())
	{
		ClientPrint(self.GetOwner(), 4, self.GetClassname() + " :\nfire_time : " + 
		fire_time.tostring() + "\nlast_fire_time : " + last_fire_time.tostring() +
		"\nflame_firing : " + flame_firing)
	}
	if ((fire_time > last_fire_time) || flame_firing )
	{
		local owner = self.GetOwner()
		if (owner)
		{
			owner.SetAbsVelocity(owner.GetAbsVelocity() - owner.EyeAngles().Forward() * -250)
		}
		last_fire_time = fire_time
	}
	return -1
}

// event listener (see Listening for Events example)
CollectEventsInScope({
	OnGameEvent_player_spawn = function(params)
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
})