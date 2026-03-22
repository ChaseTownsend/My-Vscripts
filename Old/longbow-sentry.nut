// My Custom Script Library
IncludeScript("fatcat_library")
PrecacheSound("weapons/teleporter_send.wav")

local dev = true

const TF_WEAPON_EUREKA_EFFECT = 589


///// Events! /////
::pickup <- {
	function OnGameEvent_player_spawn(params)
	{
		if(params.team != TF_TEAM_PVE_DEFENDERS) return

		local player = GetPlayerFromUserID(params.userid)
		if(player.GetWeaponIDXInSlot(SLOT_MELEE) != TF_WEAPON_EUREKA_EFFECT) return

		GetScope(player).sentry <- null

		AddThinkToEnt(player, "LongBowSentry")
	}
	function OnGameEvent_player_carryobject(params)
	{
		if(params.object != OBJ_SENTRY) return

		local player = GetPlayerFromUserID(params.userid)
		if(player.GetTeam() != TF_TEAM_PVE_DEFENDERS) return
		if(player.GetWeaponIDXInSlot(SLOT_MELEE) != TF_WEAPON_EUREKA_EFFECT) return

		GetScope(player).sentry <- EntIndexToHScript(params.index)
	}
	function OnGameEvent_player_builtobject(params)
	{
		if(params.object != OBJ_SENTRY) return

		local player = GetPlayerFromUserID(params.userid)
		if(player.GetTeam() != TF_TEAM_PVE_DEFENDERS) return
		if(player.GetWeaponIDXInSlot(SLOT_MELEE) != TF_WEAPON_EUREKA_EFFECT) return

		// local scope = GetScope(player)
		AddThinkToEnt(EntIndexToHScript(params.index), "Fragile_Buildings")

		EntFireByHandle(player, "RunScriptCode", "self.GetScriptScope().sentry <- null", 0, null, null)
	}
}
__CollectGameEventCallbacks(pickup)



//// Player Think ////
function LongBowSentry()
{
	local m_iMetal = GetPropIntArray(self, "m_iAmmo", 3)
	local scope = GetScope(self)
	local sentry = scope.sentry
	if(scope.sentry == null) return -1
	if(!scope.sentry.IsValid()) return -1

	local min = GetPropVector(scope.sentry, "m_Collision.m_vecMins")
	local max = GetPropVector(scope.sentry, "m_Collision.m_vecMaxs") + Vector(0, 0, 10)


	local btrace =
	{
		start = self.GetOrigin() + (Vector(self.EyeAngles().Forward().x, self.EyeAngles().Forward().y, 0) * 70)
		end = self.GetOrigin() + (Vector(self.EyeAngles().Forward().x, self.EyeAngles().Forward().y, 0) * 70)
		hullmin = Vector(-25, -25, 10)
		hullmax = Vector(25, 25, 40)
	}
	TraceHull(btrace)
	if(IsListenServer())
	{
		DebugDrawClear()
		DebugDrawBox(btrace.start, btrace.hullmin, btrace.hullmax, 0, 0, 255, 5, 60)
	}
	if("startsolid" in btrace)
	{
		if(btrace.startsolid)
		{
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
			if(IsListenServer())
			{
 				DebugDrawBox(ptrace.start, ptrace.hullmin, ptrace.hullmax, 0, 255, 0, 5, 10)
				DebugDrawBox(ptrace.end, ptrace.hullmin, ptrace.hullmax, 0, 255, 0, 5, 10)
			}
	    	return -1
		}
	}

	if(self.IsPressingButton(IN_RELOAD) && self.IsOnGround())
	{
		if(!dev)
		{
			if(m_iMetal <= 499)
			{
				self.PrintToHud("Not enough Metal")
				return -1
			}
		}
		local trace =
		{
			start = 	self.EyePosition()
			end = 		self.EyePosition() + self.EyeAngles().Forward() * 1190
			mask =		MASK_CUSTOM_PLAYERSOLID
			hullmin =	min
			hullmax = 	max
			ignore = 	self
		}
		TraceHull(trace)
		if(IsListenServer()) DebugDrawLine_vCol(trace.startpos, trace.endpos, Vector(255, 0, 0), false, 10)

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
			if(IsListenServer()) DebugDrawBox(htrace.start, min, max, 255, 0, 255, 0, 60)
			return -1
		}


		local gtrace =
		{
			start = self.GetOrigin() + Vector(self.EyeAngles().Forward().x, self.EyeAngles().Forward().y, 0) + Vector(0, 0, 16)
			end = 	self.GetOrigin() + Vector(self.EyeAngles().Forward().x, self.EyeAngles().Forward().y, 0) + Vector(0, 0, -16)
			mask = 		MASK_SHOT_HULL
		}
		TraceLineEx(gtrace)
		if(IsListenServer()) DebugDrawLine_vCol(gtrace.start, gtrace.end, Vector(255, 255, 0), false, 10)
		if(!gtrace.hit)
		{
			return -1
		}

		scope.NewPos <- trace.endpos
		self.GetActiveWeapon().PrimaryAttack()

		EntFireByHandle(scope.sentry, "RunScriptCode", "UpdatePosition()", 0, null, null)

		EmitSoundEx({
			sound_name = "weapons/teleporter_send.wav"
			entity = self
			origin = self.GetOrigin()
            volume = 0.33
			sound_level = 100
		})
		if(!dev) SetPropIntArray(self, "m_iAmmo", m_iMetal - 500, 3)
	}

	return -1
}

/// Building Function ///
function UpdatePosition()
{
	local owner = GetPropEntity(self, "m_hBuilder")
	local owner_scope = GetScope(owner)

	// self.AcceptInput("ClearParent", null, null, null)

	owner_scope.sentry <- null
	self.Teleport(true, owner_scope.NewPos, false, QAngle(0, 0, 0), false, Vector(0, 0, 0))

	DispatchParticleEffect("teleported_red", owner_scope.NewPos, Vector(0, -90, 0))
	if (!IsDedicatedServer()) ShowBBOX(self, Vector4D(255, 125, 0, 0), 10)

	AddThinkToEnt(self, "Fragile_Buildings")
}

function Fragile_Buildings()
{
	foreach (bot in GetEveryBotWithin(self.GetOrigin() + Vector(0, 0, 24), 100))
	{
		if(bot.InCond(TF_COND_INVULNERABLE_HIDE_UNLESS_DAMAGED))
		{
			self.TakeDamage(100000, 0, bot)
			AddThinkToEnt(self, null)
			return
		}
	}
	return 0.1
}