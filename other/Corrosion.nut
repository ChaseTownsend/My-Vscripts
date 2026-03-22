IncludeScript("fatcat_library")

::CORROSION_ICON <- CreateKillIcon("infection_acid_puddle")

local RadiationThinker = FindByName(null, "__Radiation_Thinker")
if(RadiationThinker == null)
{
	RadiationThinker = CreateByClassname("info_target")
	RadiationThinker.KeyValueFromString("targetname", "__Radiation_Thinker")
	RadiationThinker.DispatchSpawn()
}
AddThinkToEnt(RadiationThinker, "RadiationThink")

function RadiationThink()
{
	foreach (player in Players)
	{
		if(!player || !player.IsValid())
		{
			ReCalculatePlayers()
			return
		}

		if(player.IsInvincible())
		{
			player.ClearCorrosion()
			continue
		}
		local CorrosionsList = player.GetCorrosionList()
		foreach (Corrosion in CorrosionsList)
		{
			if(!player.IsAlive())
					break
			// -0.030 per frame? i think
			Corrosion.flCorrosionRemoveTime -= 2 * FrameTime()

			if(Time() >= Corrosion.flCorrosionRemoveTime && !Corrosion.bPermanentCorrosion)
			{
				player.RemoveCorrosion(CorrosionsList.find(Corrosion))
				if(!player.HasCorrosion())
					EntFireNew(player, "Color", "255 255 255")
				continue
			}
			else if(Time() >= Corrosion.flCorrosionTime)
			{
				Corrosion.flCorrosionTime = Time() + 0.5
				player.TakeDamageEx(CORROSION_ICON, Corrosion.hCorrosionAttacker, Corrosion.hCorrosionWeapon, 
					Vector(), Vector(), Corrosion.flCorrosionDmg, DMG_GENERIC | DMG_PREVENT_PHYSICS_FORCE)
				if(!player.IsAlive())
					break
			}
		}
	}
}

::CorrosionEvents <- {
	function OnGameEvent_player_death(params)
	{
		if(params.weapon_logclassname != "infection_acid_puddle")
			return

		// Create the fucking uhhh, acid puddle?
		for(local i = 0; i < 20; i++)
		{
			local particle = SpawnEntityFromTable("info_particle_system", {
				targetname = "gas_can"
				effect_name = "gas_can_red"
				start_active = 1
			})
			particle.SetAbsOrigin(GetPlayerFromUserID(params.userid).GetOrigin() + Vector(RandomInt(-75, 75), RandomInt(-75, 75), RandomInt(5, 20)))
			EntFireNew(particle, "Kill", "", 4)
		}
		local temp_think = SpawnEntityFromTable("info_target", {targetname = "StupidGasBombOnKillShit"})
		temp_think.SetAbsOrigin(GetPlayerFromUserID(params.userid).GetOrigin())
		local scope = GetScope(temp_think)
		scope.weapon <- GetPlayerFromUserID(params.attacker).GetWeapon(TF_WEAPON_BLUTSAUGER)
		scope.attacker <- GetPlayerFromUserID(params.attacker)
		scope.m_flTimeCreated <- Time()
		scope.think <- function() {
			if(!attacker || !attacker.IsValid() || m_flTimeCreated + 5.0 <= Time())
			{
				ClearThinks(self)
				self.Destroy()
				return 500
			}
			foreach(bot in GetEveryBotWithin(GetPlayerFromUserID(params.userid).GetOrigin(), 150))
			{
				if(!attacker || !attacker.IsValid() || m_flTimeCreated + 5.0 <= Time())
				{
					ClearThinks(self)
					self.Destroy()
					return 500
				}
				bot.MakeCorrosion(attacker, weapon ? weapon : attacker.GetWeaponInSlotNew(SLOT_PRIMARY), 1, 1000, true)
			}
		}
		AddThinkToEnt(temp_think, "think")
		EntFireNew(temp_think, "RunScriptCode", "self.Destroy()", 5.0)
	}
}
__CollectGameEventCallbacks(CorrosionEvents)