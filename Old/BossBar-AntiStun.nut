IncludeScript("fatcat_library")
local StunThinker = FindByName(null, "_StunThinker")
if( !StunThinker ) StunThinker = SpawnEntityFromTable("info_target", {targetname = "_StunThinker"})
AddThinkToEnt(StunThinker, "AntiStunThink")


function AntiStunThink()
{
	foreach (player in GetEveryPlayer())
	{
		if(!player.IsAlive()) 	continue
		if(!player.IsBot()) 	continue

		if(player.HasBotAttribute(USE_BOSS_HEALTH_BAR)/* || player.HasBotTag("NoStun") */)
			player.RemoveStun()
	}
}