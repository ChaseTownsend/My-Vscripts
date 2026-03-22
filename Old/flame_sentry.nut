// Ficool2's Tracefilter library
IncludeScript("trace_filter")
IncludeScript("fatcat_library")

local isDebug = false

SetScriptVersion("flame_sentry", "1.0.9")

local DMG_SENTRY_BURN = DMG_PLASMA|DMG_PREVENT_PHYSICS_FORCE

// Damage
const FLAME_SENTRY_DAMAGE = 3000
const FLAME_SENTRY_WRANGLE_MULT = 1.5
const FLAME_SENTRY_ATTACK_DELAY = 0.1

// Particle
const FLAME_SENTRY_PARTICLE_LIFETIME = 0.06

// Sound
const FLAME_SENTRY_SOUND = "misc/flame_engulf.wav"
const FLAME_SENTRY_SOUND_EMIT_RATE = 0.025
// more sound options on line 202

/* local hFlame_Cleaner = FindByName(null, "_CleanUpFlames")
if( hFlame_Cleaner == null ) hFlame_Cleaner = SpawnEntityFromTable("info_teleport_destination", { targetname = "_CleanUpFlames" })
AddThinkToEnt(hFlame_Cleaner, "CleanUpParticles")

function CleanUpParticles()
{
	local particle_list = GetAllEntitiesByTargetname("Sentry_Flame")
	foreach (particle in particle_list)
	{
		particle.Kill()
	}
	return 5
}
PurgeString("CleanUpParticles") */

::flames <-{
	function OnGameEvent_player_builtobject(params)
	{
		if(params.object != OBJ_SENTRY) return
		local player = GetPlayerFromUserID(params.userid)
		if(player.GetTeam() != TF_TEAM_PVE_DEFENDERS) return

		if(player.GetWeaponIDXInSlotNew(SLOT_MELEE) != TF_WEAPON_SOUTHERN_HOSPITALITY)
			return

		local sentry = EntIndexToHScript(params.index)
		if(GetPropBool(sentry, "m_bDisposableBuilding") == true)
			return

		AddThinkToEnt(sentry, "FlameSentry")
		PurgeString("FlameSentry")

		EntFireNew(sentry, "Color", "255 120 50")
		EntFireNew(sentry, "SetModelScale", "1")
		EntFireNew(sentry, "skin", "1")

		if(IsListenServer())
		{
			GetListenServerHost().AddCustomAttribute("engy sentry damage bonus", 0.0, -1)
			GetListenServerHost().AddCustomAttribute("engy sentry fire rate increased", 1000, -1)
			GetListenServerHost().AddCustomAttribute("engy sentry radius increased", 0.545454, -1)
			GetListenServerHost().GetWeaponInSlot(SLOT_MELEE).AddAttribute("mod wrench builds minisentry", 1, 0)
			GetListenServerHost().GetWeaponInSlot(SLOT_MELEE).AddAttribute("weapon burn dmg increased", 10, 0)
		}

		local scope = GetScope(sentry)
		scope.m_flNextAttackThink <- 0
		scope.m_flNextSoundEmit <- 0
		scope.m_hParticle <- null
	}
	/* function OnGameEvent_object_detonated(_)
	{
		if(params.objecttype != OBJ_SENTRY) return
		ClearThinks(EntIndexToHScript(_.index))
	}
	function OnGameEvent_object_destroyed(_)
	{
		if(params.objecttype != OBJ_SENTRY) return
		ClearThinks(EntIndexToHScript(_.index))
	} */
	function OnGameEvent_object_destroyed(params) {ClearThinks(EntIndexToHScript(params.index))}
	function OnGameEvent_object_detonated(params) {ClearThinks(EntIndexToHScript(params.index))}
}
__CollectGameEventCallbacks(flames)

//////////
function FlameSentry()
{
	if(self == null) return 500
	if(this.m_flNextAttackThink >= Time()) return -1 

	// Netprop related veriables
	local hOwner = GetBuilder(self)
	local m_iShells = GetPropInt(self, "m_iAmmoShells")
	local m_iState = GetState(self)

	// Still Building!
	if(GetPropBool(self, "m_bBuilding")) return -1


	// Object related variables
	local sentry = self
	local iTeamnum = self.GetTeam()
	local CanFire = m_iShells != 0

	local flPitch = (GetPropFloatArray(self, "m_flPoseParameter", 0) * -100 + 50) * DEG2RAD
	local flYaw = (GetPropFloatArray(self, "m_flPoseParameter", 1) * -360 + 180 + self.GetAbsAngles().y) * DEG2RAD
	local qaFlameAngle = QAngle(flPitch * RAD2DEG, flYaw * RAD2DEG, 0)
	local vecEyeEndPoint = Vector(cos(flPitch) * cos(flYaw), cos(flPitch) * sin(flYaw), -sin(flPitch)) * 600
	local vecEyePos = self.EyePosition()+Vector(0,0, 14)
	///////////
	// Trace //
	///////////
	local trace = {
		start = vecEyePos,
		end = vecEyePos + vecEyeEndPoint,
		hullmin = Vector(-12, 12, -12)
		hullmax = Vector(12, -12, 12)
		ignore = self,
		mask = MASK_SHOT_HULL,
		filter = function(entity)
		{
			if(IsValidEnemy(entity)) return TRACE_OK_CONTINUE
			else return TRACE_CONTINUE
			return TRACE_STOP
		}
	}
	TraceHullGather(trace)
	local aEntitysHit = []
	DebugDrawClear()
	if (trace.hits.len() > 0)
	{
		foreach (index, hit in trace.hits)
		{
			aEntitysHit.append(hit.enthit)
		}
		if(IsListenServer()) { DebugDrawLine(trace.start, trace.endpos, 255, 0, 0, false, 1) }
	}
	else if(IsListenServer()) { DebugDrawLine(trace.start, trace.endpos, 0, 255, 0, false, 1) }

	if(IsListenServer()) DrawTraceHull(trace)

	////////////
	// Damage //
	////////////
	local IsFiring = false
	local IsWrangled = false
	if(m_iState == 2 && GetPropBool(self, "m_bPlayerControlled") == true)
	{
		if(hOwner.IsPressingButton(IN_ATTACK) && (hOwner.GetWeaponInSlot(SLOT_SECONDARY) == hOwner.GetActiveWeapon()))
		{
			IsFiring = true
			IsWrangled = true
		}
		// local hSecondary = hOwner.GetWeaponInSlot(SLOT_SECONDARY)
		// if(hSecondary.GetClassname() == "tf_weapon_laser_pointer" && hOwner.GetActiveWeapon() == hSecondary && hOwner.IsPressingButton(IN_ATTACK))
		// {
			// IsWrangled = true
			// IsFiring = true
		// }
	}
	else if(m_iState == 2) IsFiring = true

	if(CanFire && IsFiring)
	// We Can fire and people are in our sight
	{
		local hParticle = SpawnEntityFromTable("info_particle_system", {
			targetname = "Sentry_flame"
			effect_name = "flamethrower_giant_mvm"
			start_active = 1
		})
		EnableStringPurge(hParticle)
		hParticle.SetAbsOrigin(vecEyePos)
		hParticle.SetAbsAngles(qaFlameAngle)

		m_iShells -= isDebug == true ? 0 : 1
		SetPropInt(self, "m_iAmmoShells", m_iShells)

		foreach (entity in aEntitysHit)
		{
			if(entity.IsPlayer())
			{
				entity.AddCondEx(TF_COND_GAS, 1, hOwner)
			}
			entity.TakeDamageCustom(sentry, hOwner, hOwner.GetWeaponInSlot(SLOT_MELEE), Vector(), Vector(), IsWrangled ? FLAME_SENTRY_DAMAGE * FLAME_SENTRY_WRANGLE_MULT : FLAME_SENTRY_DAMAGE, DMG_SENTRY_BURN, TF_DMG_CUSTOM_BURNING)
		}
		this.m_flNextAttackThink <- Time() + FLAME_SENTRY_ATTACK_DELAY
		
		if(this.m_flNextSoundEmit <= Time())
		{
			PrecacheSound(FLAME_SENTRY_SOUND)

			if(!self.IsValid())
			{
				EntFireNew(hParticle, "Kill", null, FLAME_SENTRY_PARTICLE_LIFETIME)
				return 500
			}

			EmitSoundEx({
				sound_name = FLAME_SENTRY_SOUND
				channel = 1
				volume = 1
				sound_level = 80
				entity = self
				origin = self.EyePosition()
				flags = 16
				delay = -0.3
			})
			this.m_flNextSoundEmit <- Time() + FLAME_SENTRY_SOUND_EMIT_RATE
		}

		if(m_iState == 2)
		{
			if(IsWrangled && IsFiring)
			{
				EntFireNew(hParticle, "Kill", null, FLAME_SENTRY_PARTICLE_LIFETIME)
			}
			else if(IsFiring && !IsWrangled)
			{
				EntFireNew(hParticle, "Kill", null, FLAME_SENTRY_PARTICLE_LIFETIME)
			}
		}
		else EntFireNew(hParticle, "Kill", null, FLAME_SENTRY_PARTICLE_LIFETIME)
	}
	return -1
}