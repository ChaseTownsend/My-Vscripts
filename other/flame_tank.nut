function DebugDrawTrigger(trigger, r, g, b, alpha, duration)
{
	local origin = trigger.GetOrigin()
	local mins = NetProps.GetPropVector(trigger, "m_Collision.m_vecMins")
	local maxs = NetProps.GetPropVector(trigger, "m_Collision.m_vecMaxs")
	if (trigger.GetSolid() == 2)
		DebugDrawBox(origin, mins, maxs, r, g, b, alpha, duration)
	else if (trigger.GetSolid() == 3)
		DebugDrawBoxAngles(origin, mins, maxs, trigger.GetAbsAngles(), Vector(r, g, b), alpha, duration)
}


local tank = SpawnEntityFromTable("tank_boss", {
	targetname = "testingtank"
	origin = Vector(200, -300, -120)
	health = 300
})
AddThinkToEnt(tank, "FlameTankThink")

function FlameTankThink()
{
	if(Entities.FindByName(null, "Flame_Filter_Team")) Entities.FindByName(null, "Flame_Filter_Team").Kill()
	local Filter_Team = SpawnEntityFromTable("filter_activator_tfteam", { targetname = "Flame_Filter_Team", teamnum = self.GetTeam(), negated = 1 })

	if(Entities.FindByName(null, "Flame_hurt")) Entities.FindByName(null, "Flame_hurt").Kill()
	local Igniter = SpawnEntityFromTable("trigger_ignite", { targetname = "Flame_hurt", spawnflags = 1, startdisabled = 1, damage_percent_per_second = 72, burn_duration = 8 })
	Igniter.SetSize(Vector(-160, -160, -32), Vector(160, 160, 48))
	Igniter.SetSolid(3)
	Igniter.SetAbsOrigin(self.GetOrigin())
	NetProps.SetPropEntity(Igniter, "m_hFilter", Filter_Team)

	DebugDrawTrigger(Igniter, 255, 127, 0, 0, 0.5)

	local Particle = @(vec) DispatchParticleEffect("heavy_ring_of_fire", self.GetOrigin() + RotatePosition(Vector(), self.GetAbsAngles(), vec), Vector(1, 0, 0))
	Particle(Vector(64, 48, 0))
	Particle(Vector(-64, 48, 0))
	Particle(Vector(64, -48, 0))
	Particle(Vector(-64, -48, 0))

	Igniter.AcceptInput("Enable", null, null, null)
	EntFireByHandle(Igniter, "Disable", null, 0.2, null, null)

	return 0.5
}