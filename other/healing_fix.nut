IncludeScript("fatcat_library")

local Thinker = FindByName(null, "Thinker_Fix_Healing")
if(Thinker == null) Thinker = SpawnEntityFromTable("info_target", { targetname = "Thinker_Fix_Healing" })
AddThinkToEnt(Thinker, "FIX_HEALING")

function FIX_HEALING()
{
	foreach (player in GetEveryPlayer())
	{
		if(!player.IsAlive()) continue

		local attribute_value = player.GetActiveWeapon().GetAttribute("reload time decreased while healed", 1)

		if (player.GetHealers() >= 2)
		{
			player.AddCustomAttribute("reload time increased hidden", attribute_value, 0.1)
		}
	}
	return 0.05
}