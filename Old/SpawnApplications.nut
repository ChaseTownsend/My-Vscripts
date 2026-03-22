IncludeScript("fatcat_library")

local Thinker = FindByName(null, "Thinker_SpawnApplications")
if(Thinker == null) Thinker = SpawnEntityFromTable("info_target", { targetname = "Thinker_SpawnApplications" })
AddThinkToEnt(Thinker, "SpawnApplications")

function SpawnApplications()
{
	foreach (player in GetAllPlayers(TF_TEAM_PVE_DEFENDERS, false, true))
	{
		player.SetGravity(DEFAULT_GRAVITY)
		/* player.SetScale(DEFAULT_SIZE)

		// Since we Reset scale above we gotta fake it
		if(player.InCond(TF_COND_HALLOWEEN_TINY))
		{
			player.SetScale(player.GetModelScale() * 0.5)
		} */

		foreach (weapon in player.GetAllValidWeapons())
		{
			switch (weapon.GetIDX())
			{
				// -- Gravity --

				case TF_WEAPON_NEON_ANNIHILATOR:
				{
					player.SetGravity(player.GetGravity() * 0.25)
					break
				}
				case TF_WEAPON_NEON_ANNIHILATOR_GENUINE:
				{
					player.SetGravity(player.GetGravity() * 0.25)
					break
				}
			}
		}

	}
	return -1
}