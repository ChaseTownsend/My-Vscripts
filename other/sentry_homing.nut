local homing_entity = Entities.FindByName(null, "_HomingSentryThinkEntity")
if( homing_entity == null ) homing_entity = SpawnEntityFromTable("info_teleport_destination", { targetname = "_HomingSentryThinkEntity" })
AddThinkToEnt(homing_entity, "HomingAdd")

function HomingAdd()
{
	for (local ent; ent = Entities.FindByClassname(ent, "tf_projectile*");)
	{
		if(ent.GetClassname() != "tf_projectile_rocket") continue

		ent.ValidateScriptScope()
		local projectile_scope = ent.GetScriptScope()

		if(NetProps.GetPropEntity(ent, "m_hLauncher") == null) continue
		if(NetProps.GetPropEntity(ent, "m_hLauncher").GetClassname() == "tf_point_weapon_mimic")
		{
			for (local i = 0; i <= MaxClients().tointeger();i++)
			{
				local player = PlayerInstanceFromIndex(i)
				if(player != null)
				{
					local name = NetProps.GetPropString(player, "m_szNetname")
					if(name != null)
					{
						if(ent.GetName() == name)
						{
							ent.SetOwner(player)
							if(!("homing" in projectile_scope))
							{
								projectile_scope["homing"] <- {}
								projectile_scope.turn_power <- 0.5 // percent to turn, 1.00 - 0.00
								AddThinkToEnt(ent, "HomingThink")
							}
							printl(ent.GetOwner())
						}
					}
				}
			}
		}

		/* if(!("SENTRY_ABILITY" in projectile_scope)) return
		if(!("homing" in projectile_scope))
		{
			projectile_scope["homing"] <- {}
			projectile_scope.turn_power <- 0.5 // percent to turn, 1.00 - 0.00
			AddThinkToEnt(ent, "HomingThink")
		} */
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
	local player_point = target.GetCenter()


	// courtesy entirely to lite on Potato.tf

	local vecVelocity = self.GetAbsVelocity()
	local vecOrigin                    = self.GetOrigin()
	local flSpeed                      = vecVelocity.Length()

	local vecTarget = player_point - vecOrigin
	vecTarget.Norm()
	local vecForward   = self.GetForwardVector()
	local vecDirection = vecForward + (vecTarget - vecForward) * scope.turn_power
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


			if(entity.GetClassname() == "player")
			{
				if (!(entity.GetFlags() & Constants.FPlayer.FL_NOTARGET) && !IsEntityStealthed(entity) || !IsEntityDisguised(entity))
				{
					entities.append(entity)
					distances.append(CalculateDistanceBetweenTwoPoints(self.GetOrigin(), entity.GetOrigin()))
				}
			}
			else
			{
				if (!(entity.GetFlags() & Constants.FPlayer.FL_NOTARGET))
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
		local distance = distances[i]

		if(abs(distance) <= abs(lowest_distance))
		{
			lowest_distance = distance
			lowest_index = i
		}
	}

	return entities[lowest_index]
}
function IsEntityStealthed(entity)
{
	return entity.InCond(Constants.ETFCond.TF_COND_STEALTHED)
}
function IsEntityDisguised()
{
	return entity.InCond(Constants.ETFCond.TF_COND_DISGUISED)
}