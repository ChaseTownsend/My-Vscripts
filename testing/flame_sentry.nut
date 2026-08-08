// Ficool2's Tracefilter library
try {
	IncludeScript("trace_filter")
}
catch (e)
{
	try {
		IncludeScript("chaosmvm/trace_filter")
	}
	catch(_) {
		throw "FAILED TO INCLUDE DEPENDENCY \"trace_filter\"!"
	}
}
IncludeScript("fatcat_library")

local isDebug = true

SetScriptVersion("flame_sentry", "2.1.1")

local DMG_SENTRY_BURN = DMG_PLASMA|DMG_PREVENT_PHYSICS_FORCE

// Damage
::FLAME_SENTRY_DAMAGE 		<- 3000
::FLAME_SENTRY_WRANGLE_MULT <- 1.5
::FLAME_SENTRY_DAMAGE_DELAY <- 0.1

::FLAME_SENTRY_RANGE 		<- 600.0

::FlameSentrySettings <- {
	ThinkWhileBuilding = false

	Damage = 3000.0
	WranglerMult = 1.5
	DamageDelay = 0.1 
	DamageType = DMG_PLASMA|DMG_PREVENT_PHYSICS_FORCE

	Range = 600.0

	ShootSound = "misc/flame_engulf.wav"
	SoundEmitRate = 0.025

	function OnShoot()
	{
		local trace = {
			start = EyePos,
			end = EyePos + ConvertAngleToEndpoint(Angle, 600)-Vector(0, 0, 6),
			hullmin = Vector(-12, 12, -12)
			hullmax = Vector(12, -12, 12)
			// ignore = self,
			mask = MASK_SHOT_HULL,
			filter = function(entity)
			{
				if(IsValidEnemy(entity)) return TRACE_OK_CONTINUE
				else return TRACE_CONTINUE
			}
		}

		local CanDealDamage = flNextAttackTime <= Time()

		DebugDrawClear()
		local EntitysHit = []
		if(CanDealDamage)
		{
			TraceHullGather(trace)
			foreach (_, hit in trace.hits)
			{
				EntitysHit.append(hit.enthit)
			}

			DrawTraceHull(trace)
		}

		DealDamage(EntitysHit)
	}

	function DealDamage(entitys)
	{
		////////////
		// Damage //
		////////////
		local IsWrangled = GetPropBool(self, "m_bPlayerControlled")
		local IsFiring = false

		if(IsWrangled && hOwner.IsPressingButton(IN_ATTACK) && (hOwner.GetWeaponInSlotNew(SLOT_SECONDARY) == hOwner.GetActiveWeapon()))
			IsFiring = true
		else if(!IsWrangled && iState == 2)
			IsFiring = true

		if(iShells == 0)

		if(iShells != 0 && IsFiring && flNextAttackTime <= Time())
		{
			if(hParticle == null)
			{
				hParticle = SpawnEntityFromTable("info_particle_system", {
					targetname = "Sentry_flame"
					effect_name = "flamethrower_giant_mvm"
					start_active = 1
				})
				hParticle.SetAbsOrigin(EyePos)
			}

			if(isDebug == false && m_iShells > 0)
				m_iShells--
			SetPropInt(self, "m_iAmmoShells", m_iShells)

			local delay = CheckSetting("DamageDelay")

			SetNextAttack(delay == null ? 0.1 : delay)

			foreach (entity in entitys)
			{
				if(!hOwner || !hOwner.IsValid())
					break

				if(entity.IsPlayer())
					entity.AddCondEx(TF_COND_GAS, 1, hOwner)
				entity.TakeDamageCustom(self, hOwner, hOwner.GetWeaponInSlotNew(SLOT_MELEE), Vector(), Vector(), IsWrangled ? FLAME_SENTRY_DAMAGE * FLAME_SENTRY_WRANGLE_MULT : FLAME_SENTRY_DAMAGE, DMG_SENTRY_BURN, TF_DMG_CUSTOM_BURNING)
			}
		}
	}

	function OnPostShoot(result)
	{
		if(!result)
		{
		}
		else
		{
		}
	}
}

// Sound
const FLAME_SENTRY_SOUND = "misc/flame_engulf.wav"
const FLAME_SENTRY_SOUND_EMIT_RATE = 0.025

::FlameSentryEvents <-{
	function OnScriptEvent_SentryBuilt(params)
	{
		local player = params.player
		if(player.GetWeaponIDXInSlotNew(SLOT_MELEE) != TF_WEAPON_SOUTHERN_HOSPITALITY)
			return

		local sentry = params.object
		if(GetPropBool(sentry, "m_bDisposableBuilding") == true)
			return

		AddThinkToEnt(sentry, "FlameSentry")

		EntFireNew(sentry, "Color", "255 120 50")
		EntFireNew(sentry, "SetModelScale", "1")
		EntFireNew(sentry, "skin", "1")

		if(IsListenServer())
		{
			Host.AddCustomAttribute("engy sentry damage bonus", 0.0, -1)
			Host.AddCustomAttribute("engy sentry fire rate increased", 100000, -1)
			Host.AddCustomAttribute("engy sentry radius increased", 0.54545454, -1)
			Host.GetWeaponInSlot(SLOT_MELEE).AddAttribute("mod wrench builds minisentry", 1, 0)
			Host.GetWeaponInSlot(SLOT_MELEE).AddAttribute("weapon burn dmg increased", 10, 0)
			Host.GetWeaponInSlot(SLOT_MELEE).AddAttribute("bleeding duration", 0, 0)
		}

		local scope = GetScope(sentry)
		scope.FiredLastFrame <- false
		scope.flNextAttackTime <- 0
		scope.m_flNextSoundEmit <- 0
		scope.hParticle <- null
		scope.CustomSettings <- clone FlameSentrySettings

		local function AddLoopingSound(data)
		{
			data.entity = self
			Sounds.append(data)
			EmitSoundEx(data)
		}
		scope.AddLoopingSound <- AddLoopingSound
		scope.Sounds <- []

		local function StopLoopingSounds()
		{
			foreach (data in Sounds)
			{
				data.flags = 4 // SND_STOP
				EmitSoundEx(data)
			}
		}
		scope.StopLoopingSounds <- StopLoopingSounds

		local function CleanUp()
		{
			StopLoopingSounds()
			ClearThinks(self)
			if("hParticle" in this && hParticle != null && hParticle.IsValid())
			{
				hParticle.AcceptInput("Stop", "", null, null)
				hParticle.Destroy()
				hParticle <- null
			}
		}
		scope.CleanUp <- CleanUp

		local function CheckSetting(setting)
		{
			if(setting in CustomSettings)
				return CustomSettings.CustomSettings
			return null
		}
		scope.CheckSetting <- CheckSetting

		local function GetAngle()
			return QAngle((GetPropFloat(self, "m_flPoseParameter", 0) * -100 + 50) * DEG2RAD, (GetPropFloat(self, "m_flPoseParameter", 1) * -360 + 180 + self.GetAbsAngles().y) * DEG2RAD, 0)
		scope.GetAngle <- GetAngle

		local function SetNextAttack(delay)
			flNextAttackTime = Time() + delay
		scope.SetNextAttack <- SetNextAttack

		SetDestroyCallback(sentry, function() {
			CleanUp()
		})

		scope.SoundStartVol <- 1.0
		scope.SoundLoopVol <- 1.0
	}
/* 	function OnGameEvent_object_destroyed(params) {
		local building = EntIndexToHScript(params.index)
		ClearThinks(building)
		if(params.objecttype == OBJ_SENTRY && "hParticle" in GetScope(building) && GetScope(building).hParticle != null)
		{
			GetScope(building).hParticle.AcceptInput("Stop", "", null, null)
			GetScope(building).hParticle.Destroy()
		}
	}
	function OnGameEvent_object_detonated(params) {
		local building = EntIndexToHScript(params.index)
		ClearThinks(building)
		if(params.objecttype == OBJ_SENTRY && "hParticle" in GetScope(building) && GetScope(building).hParticle != null)
		{
			GetScope(building).hParticle.AcceptInput("Stop", "", null, null)
			GetScope(building).hParticle.Destroy()
		}
	} */
}
__CollectGameEventCallbacks(FlameSentryEvents)

function CustomSentryThink()
{
	if(!self || !self.IsValid())
		return 500

	if(CheckSetting("ThinkWhileBuilding") && GetPropBool(self, "m_bBuilding"))
		return -1

	this.hOwner 	<- GetBuilder(self)
	this.iShells 	<- GetPropInt(self, "m_iAmmoShells")
	this.iState 	<- GetState(self)

	this.Angle 		<- GetAngle()
	this.flPitch 	<- Angle.Pitch()
	this.flYaw 		<- Angle.Yaw()

	this.EyePos 	<- self.EyePosition()+Vector(0, 0, 6)

	if(CanFire())
	{
		local result = OnShoot()
		OnPostShoot(result)
	}
}

//////////
function FlameSentry()
{
	if(!self || !self.IsValid())
		return 500
	if(GetPropBool(self, "m_bBuilding")) 
		return -1

	// Netprop related veriables
	local hOwner = GetBuilder(self)
	local m_iShells = GetPropInt(self, "m_iAmmoShells")
	local m_iState = GetState(self)

	// Object related variables
	local Angle 	= GetSentryAngles(self)
	local flPitch 	= Angle.Pitch()
	local flYaw 	= Angle.Yaw()
	local vecEyePos = self.EyePosition()+Vector(0, 0, 6)
	
	local CanDealDamage = NextDamageTime <= Time()

	///////////
	// Trace //
	///////////
	local trace = {
		start = vecEyePos,
		end = vecEyePos + ConvertAngleToEndpoint(Angle, 600)-Vector(0, 0, 6),
		hullmin = Vector(-12, 12, -12)
		hullmax = Vector(12, -12, 12)
		// ignore = self,
		mask = MASK_SHOT_HULL,
		filter = function(entity)
		{
			if(IsValidEnemy(entity)) return TRACE_OK_CONTINUE
			else return TRACE_CONTINUE
		}
	}

	DebugDrawClear()
	local EntitysHit = []
	if(CanDealDamage)
	{
		TraceHullGather(trace)
		foreach (_, hit in trace.hits)
		{
			EntitysHit.append(hit.enthit)
		}
	}

	if(CanDealDamage && IsListenServer()) DrawTraceHull(trace)

	////////////
	// Damage //
	////////////
	local IsWrangled = false
	local IsFiring = false

	IsWrangled = GetPropBool(self, "m_bPlayerControlled")
	if(IsWrangled && hOwner.IsPressingButton(IN_ATTACK) && (hOwner.GetWeaponInSlotNew(SLOT_SECONDARY) == hOwner.GetActiveWeapon()))
		IsFiring = true
	else if(!IsWrangled && m_iState == 2)
		IsFiring = true

	if(m_iShells != 0 && IsFiring && CanDealDamage)
	{
		if(hParticle == null)
		{
			hParticle = SpawnEntityFromTable("info_particle_system", {
				targetname = "Sentry_flame"
				effect_name = "flamethrower_giant_mvm"
				start_active = 1
			})
			hParticle.SetAbsOrigin(vecEyePos)
		}

		if(isDebug == false && m_iShells > 0)
			m_iShells--
		SetPropInt(self, "m_iAmmoShells", m_iShells)


		NextDamageTime <- Time() + FLAME_SENTRY_DAMAGE_DELAY
		foreach (entity in EntitysHit)
		{
			if(!hOwner || !hOwner.IsValid())
				break

			if(entity.IsPlayer())
				entity.AddCondEx(TF_COND_GAS, 1, hOwner)
			entity.TakeDamageCustom(self, hOwner, hOwner.GetWeaponInSlotNew(SLOT_MELEE), Vector(), Vector(), IsWrangled ? FLAME_SENTRY_DAMAGE * FLAME_SENTRY_WRANGLE_MULT : FLAME_SENTRY_DAMAGE, DMG_SENTRY_BURN, TF_DMG_CUSTOM_BURNING)
		}

		if(m_flNextSoundEmit <= Time())
		{
			if(!IsSoundPrecached(FLAME_SENTRY_SOUND))
				PrecacheSound(FLAME_SENTRY_SOUND)
			if(!IsSoundPrecached("weapons/flame_thrower_loop.wav"))
				PrecacheSound("weapons/flame_thrower_loop.wav")
			if(!IsSoundPrecached("weapons/flame_thrower_start.wav"))
				PrecacheSound("weapons/flame_thrower_start.wav")

			if(!self.IsValid())
				return 500

			if(FiredLastFrame == false)
			{
				SoundStartVol = 0.55
				EmitSoundEx({
					sound_name = "weapons/flame_thrower_start.wav"
					sound_level = 75
					entity = self
					volume = SoundStartVol
					flag = 1
				})
			}
			else
			{
				EmitSoundEx({
					sound_name = "weapons/flame_thrower_start.wav"
					sound_level = 75
					entity = self
					flag = 1
					volume = SoundStartVol
				})
			}

			SoundStartVol -= 0.01

			// EmitSoundEx({
			// 	sound_name = "weapons/flame_thrower_loop.wav"
			// 	channel = 1
			// 	sound_level = 75
			// 	entity = self
			// 	volume = SoundLoopVol
			// 	flag = 4
			// })

			if(SoundLoopVol == 1.01)
				SoundLoopVol = 0.01

			SoundLoopVol += 0.01
			EmitSoundEx({
				sound_name = "weapons/flame_thrower_loop.wav"
				channel = 1
				sound_level = 75
				entity = self
				volume = SoundLoopVol
				flag = 1
			})
			m_flNextSoundEmit <- Time() + FLAME_SENTRY_SOUND_EMIT_RATE
		}
	}
	if(hParticle == null)
	{
		hParticle = SpawnEntityFromTable("info_particle_system", {
			targetname = "Sentry_flame"
			effect_name = "flamethrower_giant_mvm"
			start_active = 1
		})
		hParticle.SetAbsOrigin(vecEyePos + Vector(0, 0, 0))
	}

	DebugDrawText(self.GetOrigin() + Vector(0, 0, 32), FiredLastFrame.tostring(), false, 0.1)

	hParticle.SetAbsAngles(QAngle(flPitch * RAD2DEG, flYaw * RAD2DEG, 0))
	if(m_iShells == 0)
	{
		hParticle.AcceptInput("Stop", "", null, null)
		EmitSoundEx({
			sound_name = "weapons/flame_thrower_loop.wav"
			channel = 1
			sound_level = 70
			entity = self
			origin = self.EyePosition()
			flags = 4
		})
		EmitSoundEx({
			sound_name = "weapons/flame_thrower_start.wav"
			sound_level = 70
			entity = self
			origin = self.EyePosition()
			flags = 4
		})
		SoundLoopVol = 1.0
	}
	else if((IsFiring && !IsWrangled) || (IsFiring && IsWrangled))
		hParticle.AcceptInput("Start", "", null, null)
	else 
	{
		hParticle.AcceptInput("Stop", "", null, null)
		EmitSoundEx({
			sound_name = "weapons/flame_thrower_loop.wav"
			channel = 1
			sound_level = 70
			entity = self
			origin = self.EyePosition()
			flags = 4
		})
		EmitSoundEx({
			sound_name = "weapons/flame_thrower_start.wav"
			sound_level = 70
			entity = self
			origin = self.EyePosition()
			flags = 4
		})
		SoundLoopVol = 1.01
	}

	if(IsFiring && m_iShells != 0)
		FiredLastFrame = true
	else
		FiredLastFrame = false
	
	return -1
}