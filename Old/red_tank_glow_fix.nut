IncludeScript("fatcat_library")

local RedTankGlowEntity = Entities.FindByName(null, "_FixTankGlow")
if( RedTankGlowEntity == null ) RedTankGlowEntity = SpawnEntityFromTable("info_target", { targetname = "_FixTankGlow" })
AddThinkToEnt(RedTankGlowEntity, "RedTankGlow")

function RedTankGlow()
{
	if(GetAllEntitiesByClassname("tank_boss").len() == 0) return 0.2
	foreach (tank in GetAllEntitiesByClassname("tank_boss"))
	{
		if(tank.GetTeam() == TF_TEAM_PVE_DEFENDERS && NetProps.GetPropBool(tank, "m_bGlowEnabled") == false)
		{
			tank.SetGlow(true)
		}
	}
	return 0.2
}