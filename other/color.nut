IncludeScript("fatcat_library")


local thinker = FindByName(null, "colortink")
if( thinker == null ) thinker = SpawnEntityFromTable("info_target", { targetname = "colortink" })
AddThinkToEnt(thinker, "color")

function color()
{
    foreach (projectile in GetAllEntitiesByClassname("tf_projectile_energy_ball"))
	{
        local color = Vector(sin(Time())*255, sin(Time())*255, sin(Time())*255)
        SetPropVector(projectile, "m_vColor1", color)
        SetPropVector(projectile, "m_vColor2", color)
	}
	return -1
}
