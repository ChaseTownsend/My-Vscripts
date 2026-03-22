::CPROJ_STATE_KILL 		<- -1
::CPROJ_STATE_REJECT 	<- 0
::CPROJ_STATE_MOVE 		<- 1
::CPROJ_STATE_SET 		<- 2

function ROOT::CreateProjectile(proj_info)
{
	if(!("thinkfunc" in proj_info) || !proj_info.thinkfunc)
		return
	if(!("owner" in proj_info) || !proj_info.owner)
		return
	if(!("model" in proj_info) || !proj_info.model || proj_info.model == "")
		return
	
	PrecacheModel(proj_info.model)

	local flForce = "force" in proj_info ? proj_info.force : 500
	local flDistance = "distance" in proj_info ? proj_info.distance : 0
	local hOwner = proj_info.owner
	local vForward = hOwner.EyeVector()
	local vMove = (vForward * flForce)

	local vOrigin = hOwner.EyePosition() + (vForward * flDistance)
	local hProj = CreateByClassname("prop_physics_override")

	hProj.SetModel(proj_info.model)
	hProj.SetAbsOrigin(vOrigin)

	hProj.SetCollisionGroup(TFCOLLISION_GROUP_ROCKET_BUT_NOT_WITH_OTHER_ROCKETS)

	local hParticle = null
	if("particle" in proj_info)
	{
		hParticle = SpawnEntityFromTable("info_particle_system", {
			effect_name = proj_info.particle
			start_active = 1
			origin = vOrigin
		})
		EntFireNew(hParticle, "SetParent", "!activator", -1, hProj, hProj)
	}
	hProj.DispatchSpawn()
	hProj.SetPhysVelocity(vMove)
	
	local tScope = GetScope(hProj)

	tScope.m_hOwner 		<- hOwner
	tScope.m_iState 		<- CPROJ_STATE_MOVE
	tScope.m_hParticle 		<- hParticle
	tScope.m_hParticle 		<- hParticle
	tScope.m_flRadius		<- "radius" in proj_info ? proj_info.radius : 50

	tScope.m_flStartTime 	<- Time()
	tScope.m_flKillMeTime 	<- Time() + (("lifetime" in proj_info) ? proj_info.lifetime : 5)

	tScope.m_flThinkDelay 	<- (("delay" in proj_info) ? proj_info.delay : 0.1)

	if(type(proj_info.thinkfunc) == "function")
	{
		tScope.m_fThinkFunc		<- proj_info.thinkfunc
		AddThinkToEnt(hProj, "m_fThinkFunc")
	}
	else if(type(proj_info.thinkfunc) == "string")
	{
		AddThinkToEnt(hProj, proj_info.thinkfunc)
	}
	else
	{
		printl("errm. . . Something fucked up")
	}

	return hProj;
}

function ROOT::TestProjThink()
{
	if(Time() >= m_flKillMeTime || m_iState == CPROJ_STATE_KILL)
	{
		// printf("Killing %s\n", self.tostring())
		self.Destroy()
		if(m_hParticle)
		{
			EntFireNew(m_hParticle, "Stop")
			m_hParticle.Destroy()
		}
		return FLT_MAX;
	}

	if(m_iState == CPROJ_STATE_MOVE)
	{
		// local victim = FindByClassnameWithin(null, "player", self.GetOrigin(), m_flRadius)
		local victim = null
		foreach (player in Players)
		{
			if(player.GetTeam() == m_hOwner.GetTeam())
				continue
			if(player.IsDead())
				continue
			local delta = player.GetCenter() - self.GetOrigin()
			local dist = delta.Norm()
			if(dist <= m_flRadius)
			{
				victim = player
				break
			}
		}

		// DebugDrawText(self.GetOrigin(), victim ? victim.tostring() : "([-1]:NULL)", false, 5)

		if(victim)
		{
			CreateAoETable({
				owner = m_hOwner,
				center = self.GetOrigin(),
				radius = 100,
				maxDmg = 100,
				minDmg = 45,
				ignore = [m_hOwner],
				dmg_Type = DMG_BLAST,
				sound = "weapons/explode1.wav",
				particle = "ExplosionCore_Wall" }
			)
			m_iState = CPROJ_STATE_KILL
		}
	}
	// return m_flThinkDelay
}