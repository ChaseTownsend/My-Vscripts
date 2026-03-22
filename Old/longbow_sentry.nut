// My Custom Script Library
IncludeScript("fatcat_library")
PrecacheSound("weapons/teleporter_send.wav")

const TF_WEAPON_EUREKA_EFFECT = 589


///// Events! /////
::pickup <- {
	function OnGameEvent_player_spawn(params)
	{
		if(params.team != TF_TEAM_PVE_DEFENDERS) return

		local player = GetPlayerFromUserID(params.userid)
		if(player.GetPlayerClass() != TF_CLASS_ENGINEER) return
		if(player.GetWeaponIDXInSlot(MELEE_SLOT) != TF_WEAPON_EUREKA_EFFECT) return

		player.ValidateScriptScope()
		local scope = player.GetScriptScope()
		scope.sentry <- null

		AddThinkToEnt(player, "LongBowSentry")
	}
	function OnGameEvent_player_carryobject(params)
	{
		if(params.object != 2) return

		local player = GetPlayerFromUserID(params.userid)
		if(player.GetTeam() != TF_TEAM_PVE_DEFENDERS) return
		if(player.GetWeaponIDXInSlot(MELEE_SLOT) != TF_WEAPON_EUREKA_EFFECT) return

		player.ValidateScriptScope()
		local scope = player.GetScriptScope()

		scope.sentry <- EntIndexToHScript(params.index)
	}
	function OnGameEvent_player_builtobject(params)
	{
		if(params.object != 2) return

		local player = GetPlayerFromUserID(params.userid)
		if(player.GetTeam() != TF_TEAM_PVE_DEFENDERS) return
		if(player.GetWeaponIDXInSlot(MELEE_SLOT) != TF_WEAPON_EUREKA_EFFECT) return

		player.ValidateScriptScope()
		local scope = player.GetScriptScope()

		EntFireByHandle(player, "RunScriptCode", "self.GetScriptScope().sentry <- null", 0, null, null)
	}
}
__CollectGameEventCallbacks(pickup)



//// Player Think ////
function LongBowSentry()
{
	local m_iMetal = NetProps.GetPropIntArray(self, "m_iAmmo", 3)
	local scope = self.GetScriptScope()
	if(scope.sentry == null) return -1
	if(!scope.sentry.IsValid()) return -1

	local min = NetProps.GetPropVector(scope.sentry, "m_Collision.m_vecMins")
	local max = NetProps.GetPropVector(scope.sentry, "m_Collision.m_vecMaxs") + Vector(0, 0, 10)

	local btrace =
	{
		start = self.GetOrigin() + (self.GetForwardVector() * 70)
		end = self.GetOrigin() + (self.GetForwardVector() * 70)
		hullmin = Vector(-25, -25, 10)
		hullmax = Vector(25, 25, 40)
	}
	TraceHull(btrace)
	if(!IsDedicatedServer())
	{
		DebugDrawClear()
		DebugDrawBox(btrace.start, btrace.hullmin, btrace.hullmax, 0, 0, 255, 5, 60)
	}
	if("startsolid" in btrace)
	{
		if(btrace.startsolid)
		{
			// self.PrintToHud("Btrace Failed!")
			return -1
		}
	}

	if(self.InRespawnRoom()) return -1

	local ptrace =
	{
		start =			self.GetOrigin()
		end =			self.GetOrigin() + Vector(0, 0, -48)
		hullmin = 		self.GetPlayerMins()
		hullmax = 		self.GetPlayerMaxs()
		mask =			MASK_CUSTOM_PLAYERSOLID
		ignore = 		self
	}
	TraceHull(ptrace)
	if (ptrace.hit)
	{
		local allow = false
		foreach (classname in ["worldspawn", "func_detail", "func_brush"])
		{
			if(ptrace.enthit.GetClassname() == classname)
			{
				allow = true
				break
			}
		}
		if (allow == false)
		{
			if(!IsDedicatedServer())
			{
 				DebugDrawBox(ptrace.start, ptrace.hullmin, ptrace.hullmax, 0, 255, 0, 5, 10)
				DebugDrawBox(ptrace.end, ptrace.hullmin, ptrace.hullmax, 0, 255, 0, 5, 10)
			}
			self.PrintToHud("Ptrace Failed! \nclassname was " + ptrace.enthit.GetClassname())
	    	return -1
		}
	}

	if(self.IsPressingButton(IN_ATTACK3) && (self.GetFlags() & Constants.FPlayer.FL_ONGROUND))
	{
		if(m_iMetal <= 299) return -1
		local trace =
		{
			start = 	self.EyePosition()
			end = 		self.EyePosition() + self.EyeAngles().Forward() * 16384
			mask =		MASK_CUSTOM_PLAYERSOLID
			hullmin =	min
			hullmax = 	max
			ignore = 	self
		}
		TraceHull(trace)
		if(!IsDedicatedServer()) DebugDrawLine_vCol(trace.startpos, trace.endpos, Vector(255, 0, 0), false, 10)

		if (IsPointInRespawnRoom(trace.endpos))  return -1
		if(!trace.hit) return -1
		local allow = false
		foreach (classname in ["worldspawn", "func_detail", "func_brush"])
		{
			if(trace.enthit.GetClassname() == classname)
			{
				allow = true
				break
			}
		}
		if (allow == false)
		{
			// self.PrintToHud("trace Failed! \nclassname was " + trace.enthit.GetClassname())
	    	return -1
		}

		scope.NewPos <- trace.endpos

		local htrace =
		{
			start = 	trace.endpos
			end = 		trace.endpos
			mask =		MASK_SHOT_HULL
			hullmin = 	min
			hullmax =	max
		}
		TraceHull(htrace)
		if(htrace.hit)
		{
			if(!IsDedicatedServer()) DebugDrawBox(htrace.start, min, max, 255, 0, 255, 0, 60)
			self.PrintToHud("Htrace Failed!")
			return -1
		}

		local gtrace =
		{
			start = 	self.GetOrigin() + (self.GetForwardVector() * 70) + Vector(0, 0, 16)
			end = 		self.GetOrigin() + (self.GetForwardVector() * 70) + Vector(0, 0, -16)
			mask = 		MASK_SHOT_HULL
		}
		TraceLineEx(gtrace)
		if(!IsDedicatedServer()) DebugDrawLine_vCol(gtrace.start, gtrace.end, Vector(255, 255, 0), false, 10)
		if(!gtrace.hit)
		{
			self.PrintToHud("Gtrace Failed!")
			return -1
		}



		scope.NewPos <- trace.endpos
		self.GetActiveWeapon().PrimaryAttack()

		EntFireByHandle(scope.sentry, "RunScriptCode", "UpdatePosition()", 0, null, null)
		self.EmitSound("weapons/teleporter_send.wav")
		NetProps.SetPropIntArray(self, "m_iAmmo", m_iMetal - 300, 3)
	}

	return -1
}

/// Building Function ///
function UpdatePosition()
{
	local owner = NetProps.GetPropEntity(self, "m_hBuilder")
	local owner_scope = owner.GetScriptScope()

	self.AcceptInput("ClearParent", null, null, null)

	owner_scope.sentry <- null
	self.Teleport(true, owner_scope.NewPos, false, QAngle(0, 0, 0), false, Vector(0, 0, 0))

	DispatchParticleEffect("teleported_red", owner_scope.NewPos, Vector(0, -90, 0))
	if (!IsDedicatedServer()) ShowBBOX(self, Vector4D(255, 125, 0, 0), 10)
}