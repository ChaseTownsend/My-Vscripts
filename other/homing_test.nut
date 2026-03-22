local homing_entity = Entities.FindByName(null, "_HomingThinkEntity")
if( homing_entity == null ) homing_entity = SpawnEntityFromTable("info_teleport_destination", { targetname = "_HomingThinkEntity" })
AddThinkToEnt(homing_entity, "HomingAdd")

local HOMING_PROJECTILES =
[
	"tf_projectile_rocket",
	"tf_projectile_energy_ball",
	"tf_projectile_energy_ring",
	"tf_projectile_balloffire",
	"tf_projectile_flare",
	"tf_projectile_arrow",
	"tf_projectile_mechanicalarmorb",
	"tf_projectile_sentryrocket",
	"tf_projectile_syringe",
	"tf_projectile_healing_bolt",
]

/* local NO_GRAVITY_PROJECTILE =
[
	"tf_projectile_rocket",
	"tf_projectile_energy_ball",
	"tf_projectile_energy_ring",
	"tf_projectile_balloffire",
	"tf_projectile_mechanicalarmorb",
	"tf_projectile_sentryrocket",
] */

local HEADSHOT_PROJECTILE = "tf_projectile_arrow"

function HomingAdd()
{
	for (local ent; ent = Entities.FindByClassname(ent, "tf_projectile*");)
	{
		local allow = false
		foreach (projectile in HOMING_PROJECTILES)
		{
			if(ent.GetClassname() == projectile) allow = true
		}
		if(allow == false) continue

		ent.ValidateScriptScope()
		local projectile_scope = ent.GetScriptScope()
		if(!("homing" in projectile_scope))
		{
			projectile_scope.homing <- true
			AddThinkToEnt(ent, "HomingThink")
			//ClientPrint(null, 4, "Added Think to " + ent.GetClassname())
		}
		if(!("projectile_behavior" in projectile_scope))
		{
			if(ent.GetClassname() == HEADSHOT_PROJECTILE)
			{
				projectile_scope.projectile_behavior <- "HEADSHOT"
			}
			else
			{
				projectile_scope.projectile_behavior <- "NORMAL"
			}
		}
	}
	return -1
}

function HomingThink()
{
	local target = FindClosestTarget()
	if(target == null) return -1

	local Deflected = 0
	local CurrentDeflected = NetProps.GetPropInt(self, "m_iDeflected")
	if(Deflected != CurrentDeflected)
	{
		Deflected = CurrentDeflected
		target     = null
		local target = FindClosestTarget()
		if(target == null) return -1
	}


	local scope = self.GetScriptScope()
	local player_point = null

	if("projectile_behavior" in scope)
	{
		if(scope["projectile_behavior"] == "HEADSHOT")
		{
			// make "tf_projectile_arrow"s aim for the head
			player_point = target.GetCenter() + Vector(0, 0, 32)
		}
		else player_point = target.GetCenter()
	//}

	//DebugDrawClear()
	// DebugDrawLine(self.GetOrigin(), player_point, 255, 0, 0, false, 1)


	// courtesy entirely to lite on Potato.tf

	local vecVelocity = self.GetAbsVelocity() * 1
	local vecOrigin                    = self.GetOrigin()
	local flSpeed                      = vecVelocity.Length()
	local TurnPower = 0.5

	local vecTarget = player_point - vecOrigin
	vecTarget.Norm()
	local vecForward   = self.GetForwardVector()
	local vecDirection = vecForward + (vecTarget - vecForward) * TurnPower
	vecDirection.Norm()
	local vecVelocity = vecDirection * flSpeed
	self.SetAbsVelocity(vecVelocity)
	self.SetForwardVector(vecDirection)
}

function CalculateDistanceBetweenTwoPoints(point1, point2)
{
	local xdiff = point2.x - point1.x
	local ydiff = point2.y - point1.y
	local zdiff = point2.z - point1.z
	local xdiffsqr = xdiff * xdiff
	local ydiffsqr = ydiff * ydiff
	local zdiffsqr = zdiff * zdiff

	local sqrsum = xdiffsqr + ydiffsqr + zdiffsqr
	return sqrt(sqrsum)
	// Compact, idk if this is better
	//return sqrt((((point2.x - point1.x) * (point2.x - point1.x)) + ((point2.y - point1.y) * (point2.y - point1.y)) + ((point2.z - point1.z) * (point2.z - point1.z))))
}

function FindClosestTarget()
{
	local entities = []
	local distances = []

	local flDistance = 8192
	// Add Entities and distances
	foreach (Classname in [ "player", "obj_sentrygun", "obj_dispenser", "obj_teleporter", "tank_boss", "merasmus", "headless_hatman", "eyeball_boss", "tf_zombie" ])
	{
		for (local entity; entity = Entities.FindByClassnameWithin(entity, Classname, self.GetOrigin(), flDistance);)
		{
			if(entity == null) continue
			if(!entity.IsAlive()) continue
			if(entity.GetTeam() == self.GetTeam()) continue
			local owner = self.GetOwner()
			if(owner == null)
			{
				//printl(NetProps.GetPropEntity(self, "m_hLauncher"))
				// Special stupid case, because some dont have an "m_hOwner" netprop
				if (NetProps.GetPropEntity(self, "m_hThrower") == entity) continue
			}
			else
			{
				if(owner.GetClassname() == "obj_sentrygun")
				{
					owner = NetProps.GetPropEntity(owner, "m_hBuilder")
				}
				if(entity == owner) continue
			}

			/* local CenterTrace =
			{
				start = entity.GetCenter()
				end = self.GetOrigin()
				ignore = self
			}
			TraceLineEx(CenterTrace)
			if(CenterTrace.hit)
			{
				DebugDrawLine(CenterTrace.startpos, CenterTrace.endpos, 255, 0, 0, false, 15)
			} */

			if(entity.GetClassname() == "player")
			{
				if(
					!(entity.GetFlags() & Constants.FPlayer.FL_NOTARGET)
					&& !(entity.InCond(Constants.ETFCond.TF_COND_STEALTHED))
					|| !(entity.InCond(Constants.ETFCond.TF_COND_DISGUISED))
				)
				{
					entities.append(entity)
					distances.append(CalculateDistanceBetweenTwoPoints(self.GetOrigin(), entity.GetOrigin()))
				}
			}
			else
			{
				if (/* CenterTrace &&  */!(entity.GetFlags() & Constants.FPlayer.FL_NOTARGET))
				{
					entities.append(entity)
					distances.append(CalculateDistanceBetweenTwoPoints(self.GetOrigin(), entity.GetOrigin()))
				}
			}
		}
	}

	local lowest_distance = flDistance
	local lowest_index = 0

	if(entities.len() == 0 || distances.len() == 0) return null

	for (local i = 0; i < distances.len(); i = i+1)
	{
		//local player = entities[i]
		local distance = distances[i]

		if(abs(distance) <= abs(lowest_distance))
		{
			lowest_distance = distance
			lowest_index = i
		}
	}

	return entities[lowest_index]
}