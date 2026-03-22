IncludeScript("fatcat_library")

local spawnthinker = FindByName(null, "_spawncond")
if ( !spawnthinker ) spawnthinker = SpawnEntityFromTable("info_target", { targetname = "_spawncond" })
AddThinkToEnt(spawnthinker, "SpawnCond")

function SpawnCond()
{
	foreach(player in GetEveryHuman())
	{
		if(player.InCond(107)) player.RemoveCondEx(107, true)

		for (local i = 0; i <= MAX_WEAPONS; i++)
		{
			if( !player.GetWeaponInSlot(i) ) continue

			local index = player.GetWeaponIDXInSlot(i)

			switch (index)
			{
				case 171:
				case 317:
				{
					player.AddCondEx(107, -1, player)
				}
			}
		}
	}
}
